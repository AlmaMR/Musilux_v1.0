<?php

namespace App\Http\Controllers;

use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;

class ChatbotController extends Controller
{
    public function chat(Request $request)
    {
        $validated = $request->validate([
            'question' => 'required|string|max:1000',
        ]);

        $question = $validated['question'];

        $products = Product::with('category')
            ->where('esta_activo', true)
            ->limit(20)
            ->get(['id', 'id_categoria', 'nombre', 'descripcion', 'precio', 'tipo_producto']);

        $productList = $products->map(function (Product $product) {
            $category = $product->category ? $product->category->nombre : 'Sin categoría';
            $descripcion = trim($product->descripcion ?? 'Sin descripción');
            $price = number_format($product->precio, 2);

            return "- {$product->nombre} ({$category}) - {$product->tipo_producto} - $" . $price
                . "\n  {$descripcion}";
        })->implode("\n");

        $systemMessage = "Eres un asistente virtual de Musilux. Responde en español de forma clara, amable y breve. "
            . "Estamos especializados en vinilos, instrumentos musicales y equipos de iluminación. "
            . "Si el usuario pregunta por algo fuera de esas categorías, responde que no lo ofrecemos y sugiere alternativas dentro de nuestros productos.";

        $userMessage = "Aquí tienes un resumen de los productos disponibles:\n{$productList}\n\n" 
            . "Pregunta del usuario:\n\"{$question}\"";

        $response = Http::withToken(config('services.openai.key'))
            ->timeout(30)
            ->post('https://api.openai.com/v1/chat/completions', [
                'model' => 'gpt-4o-mini',
                'messages' => [
                    ['role' => 'system', 'content' => $systemMessage],
                    ['role' => 'user', 'content' => $userMessage],
                ],
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
}
