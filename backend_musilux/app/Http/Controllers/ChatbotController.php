<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Http;

class ChatbotController extends Controller
{
    public function chat(Request $request)
    {
        $validated = $request->validate([
            'messages' => 'required|array',
            'messages.*.role' => 'required|string|in:system,user,assistant',
            'messages.*.content' => 'required|string',
        ]);

        $messages = $validated['messages'];

        $orderContext = $this->buildOrderContext($request->user()->id);

        $systemMessage = [
            'role' => 'system',
            'content' => trim(
                "Eres un asistente virtual de Musilux. Solo debes usar la información de pedidos del usuario autenticado para responder preguntas sobre sus compras. " .
                "No utilices datos de otros clientes ni inventes pedidos que no estén en esta cuenta." .
                "musilux es una tienda especializada en la venta de vinilos, canciones y instrumentos musicales.".
                "si el usuario te pide información sobre sus pedidos, úsala para responder.".
                "si el usuario pide informacion no relacionada con sus pedidos o de otros productos de la tienda, dile que no tiene acceso a esa información.".
                "si el usuario pregunta de algun objeto que no esta relacionado a vinilos, instrumentos musicales o canciones, redireccionalo a las compras de la tienda".
                "A continuación se muestran los pedidos del usuario autenticado:\n\n{$orderContext}"
            ),
        ];

        $messages = array_merge([$systemMessage], $messages);

        $response = Http::withToken(config('services.openai.key'))
            ->withHeaders(['Accept' => 'application/json'])
            ->withOptions(['verify' => false])
            ->timeout(30)
            ->post('https://api.openai.com/v1/chat/completions', [
                'model' => 'gpt-4o-mini',
                'messages' => $messages,
                'temperature' => 0.5,
                'max_tokens' => 400,
            ]);

        if ($response->failed()) {
            return response()->json([
                'message' => 'Error al procesar la solicitud del chatbot.',
                'error' => $response->body(),
            ], 500);
        }

        $data = $response->json();
        $answer = data_get($data, 'choices.0.message.content');

        if (!$answer) {
            return response()->json([
                'message' => 'OpenAI devolvió una respuesta inválida.',
                'debug' => $data,
            ], 500);
        }

        return response()->json(['answer' => trim($answer)]);
    }

    private function buildOrderContext(string $userId): string
    {
        $orders = DB::table('pedidos')
            ->where('id_usuario', $userId)
            ->orderByDesc('id')
            ->get(['id', 'estado', 'subtotal', 'monto_total']);

        if ($orders->isEmpty()) {
            return 'El usuario no tiene pedidos registrados en su cuenta.';
        }

        $orderIds = $orders->pluck('id');

        $items = DB::table('detalles_pedido')
            ->join('productos', 'detalles_pedido.id_producto', '=', 'productos.id')
            ->whereIn('detalles_pedido.id_pedido', $orderIds)
            ->get([
                'detalles_pedido.id_pedido as pedido_id',
                'productos.nombre as producto',
                'detalles_pedido.cantidad',
                'detalles_pedido.precio_unitario',
                'detalles_pedido.subtotal',
            ]);

        $itemsByOrder = $items->groupBy('pedido_id');

        $lines = [];
        foreach ($orders as $order) {
            $lines[] = "Pedido #{$order->id} — estado: {$order->estado} — subtotal: {$order->subtotal} — total: {$order->monto_total}";
            $orderItems = $itemsByOrder[$order->id] ?? collect();
            foreach ($orderItems as $item) {
                $lines[] = "  - {$item->producto} x{$item->cantidad} @ {$item->precio_unitario} (subtotal {$item->subtotal})";
            }
            $lines[] = '';
        }

        return implode("\n", $lines);
    }
}
