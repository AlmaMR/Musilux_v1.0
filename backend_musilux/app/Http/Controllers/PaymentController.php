<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Stripe\Stripe;
use Stripe\PaymentIntent;
use Stripe\Checkout\Session;

class PaymentController extends Controller
{
    public function __construct()
    {
        // Aseguramos la clave de Stripe está configurada
        Stripe::setApiKey(config('services.stripe.secret'));
    }

    /**
     * Crea un PaymentIntent a partir del total enviado desde el frontend.
     * Request JSON esperado: { "amount": 123.45 }
     * Devuelve: { client_secret, publishableKey }
     */
    public function createPaymentIntent(Request $request)
    {
        $request->validate([
            'amount' => ['required', 'numeric', 'min:0.01'],
        ]);

    // Stripe espera el monto en centavos (integer)
    $amountFloat = $request->input('amount');
    $amount = (int) round($amountFloat * 100);

        try {
            $pi = PaymentIntent::create([
                'amount' => $amount,
                // Usar MXN (pesos mexicanos). Cambia si necesitas otra moneda.
                'currency' => 'mxn',
                'automatic_payment_methods' => ['enabled' => true],
                // metadata opcional: puedes incluir user id, orden id, etc.
                'metadata' => [
                    'platform' => 'musilux',
                ],
            ]);

            return response()->json([
                'client_secret' => $pi->client_secret,
                'publishableKey' => config('services.stripe.key'),
            ]);
        } catch (\Exception $e) {
            Log::error('Stripe createPaymentIntent error: ' . $e->getMessage());
            return response()->json(['message' => 'Error creating payment intent'], 500);
        }
    }

    /**
     * Crea una sesión de Stripe Checkout (útil para web)
     * Request JSON esperado: { "amount": 123.45 }
     * Devuelve: { url }
     */
    public function createCheckoutSession(Request $request)
    {
        $request->validate([
            'amount' => ['required', 'numeric', 'min:0.01'],
            'items' => ['required', 'array',],
        ]);

        $amountFloat = $request->input('amount');
        $amount = (int) round($amountFloat * 100);

        $items = $request->input('items', []);
        $discount = $request->input('discount', 0);

        // calcular subtotal/total (en unidades)
        $subtotal = 0.0;
        foreach ($items as $it) {
            $p = isset($it['precio_unitario']) ? floatval($it['precio_unitario']) : 0.0;
            $q = isset($it['cantidad']) ? intval($it['cantidad']) : 1;
            $subtotal += $p * $q;
        }
        $total = $subtotal - floatval($discount);

        $userId = $request->user()?->id;

        DB::beginTransaction();
        try {
            $pedidoId = (string) Str::uuid();

            DB::table('pedidos')->insert([
                'id' => $pedidoId,
                'id_usuario' => $userId,
                'id_cupon' => null,
                'estado' => 'pendiente',
                'subtotal' => $subtotal,
                'descuento' => $discount,
                'total' => $total,
                'direccion_envio' => null,
                'creado_en' => now(),
            ]);

            $stripeLineItems = [];
            foreach ($items as $it) {
                $idProducto = $it['id_producto'] ?? null;
                $cantidad = isset($it['cantidad']) ? intval($it['cantidad']) : 1;
                $precioUnitario = isset($it['precio_unitario']) ? floatval($it['precio_unitario']) : 0.0;

                // Intentar obtener nombre e imagen desde la BD usando id_producto
                $nombre = $it['nombre_producto'] ?? null;
                $imagen = $it['imagen_producto'] ?? null;

                if ($idProducto) {
                    // Nombre desde productos.nombre
                    $prodNombre = DB::table('productos')->where('id', $idProducto)->value('nombre');
                    if ($prodNombre) {
                        $nombre = $prodNombre;
                    }

                    // Imagen principal desde multimedia_producto.url_archivo (si existe es_principal)
                    $img = DB::table('multimedia_producto')
                             ->where('id_producto', $idProducto)
                             ->where('es_principal', true)
                             ->value('url_archivo');
                    if (!$img) {
                        // Fallback: cualquier multimedia para el producto
                        $img = DB::table('multimedia_producto')
                                 ->where('id_producto', $idProducto)
                                 ->value('url_archivo');
                    }
                    if ($img) {
                        $imagen = $img;
                    }
                }

                // Valores por defecto si aún no existen
                $nombre = $nombre ?? ($it['description'] ?? 'Producto');

                DB::table('items_pedido')->insert([
                    'id_pedido' => $pedidoId,
                    'id_producto' => $idProducto,
                    'cantidad' => $cantidad,
                    'precio_unitario' => $precioUnitario,
                    'nombre_producto' => $nombre,
                    'imagen_producto' => $imagen,
                    'created_at' => now(),
                    'updated_at' => now(),
                ]);

                // Construir línea para Stripe
                $stripeLineItems[] = [
                    'price_data' => [
                        'currency' => 'mxn',
                        'product_data' => ['name' => $nombre],
                        'unit_amount' => (int) round($precioUnitario * 100),
                    ],
                    'quantity' => $cantidad,
                ];
            }

            $frontend = env('FRONTEND_URL', env('APP_URL'));
            $session = Session::create([
                'payment_method_types' => ['card'],
                'line_items' => $stripeLineItems,
                'mode' => 'payment',
                'success_url' => rtrim($frontend, '/') . '/checkout/success?session_id={CHECKOUT_SESSION_ID}',
                'cancel_url' => rtrim($frontend, '/') . '/checkout/cancel',
                'metadata' => ['id_pedido' => $pedidoId],
            ]);

            DB::commit();
            return response()->json(['url' => $session->url]);
        } catch (\Exception $e) {
            DB::rollBack();
            Log::error('Stripe Checkout error / DB error: ' . $e->getMessage());
            return response()->json(['message' => 'Error creating checkout session'], 500);
        }
    }

    /**
     * Recupera información de una sesión de Checkout por id.
     * GET /checkout/session/{id}
     */
    public function getCheckoutSession(Request $request, $id)
    {
        try {
            // Intentar expandir payment_intent y line_items
            $session = Session::retrieve($id, ['expand' => ['payment_intent', 'line_items']]);

            $result = [
                'id' => $session->id ?? null,
                'payment_status' => $session->payment_status ?? null,
                'amount_total' => $session->amount_total ?? null,
                'currency' => $session->currency ?? null,
                'payment_intent' => $session->payment_intent ?? null,
                'line_items' => [],
            ];

            // Si la propiedad line_items está disponible y es iterables
            if (isset($session->line_items) && is_iterable($session->line_items->data)) {
                foreach ($session->line_items->data as $li) {
                    $result['line_items'][] = [
                        'description' => $li->description ?? null,
                        'quantity' => $li->quantity ?? 1,
                        'price' => $li->price->unit_amount ?? null,
                        'currency' => $li->price->currency ?? null,
                        'product_name' => $li->price->product ?? null,
                    ];
                }
            }

            return response()->json($result);
        } catch (\Exception $e) {
            Log::error('Stripe retrieve session error: ' . $e->getMessage());
            return response()->json(['message' => 'Error retrieving session: ' . $e->getMessage()], 500);
        }
    }

    /**
     * Webhook básico para recibir eventos de Stripe (opcional)
     */
    public function webhook(Request $request)
    {
        // Por simplicidad procesamos el payload directamente. En producción usar Stripe\Webhook y verificar signature.
        $payload = $request->getContent();
        $event = json_decode($payload, true);
        Log::info('Stripe webhook received', $event ?? []);

        // Manejar eventos relevantes
        if (isset($event['type'])) {
            switch ($event['type']) {
                case 'checkout.session.completed':
                    // Cuando Checkout completa, buscar metadata.id_pedido y marcar confirmado
                    $session = $event['data']['object'] ?? null;
                    $pedidoId = $session['metadata']['id_pedido'] ?? null;
                    if ($pedidoId) {
                        DB::table('pedidos')->where('id', $pedidoId)->update(['estado' => 'confirmado', 'actualizado_en' => now()]);
                        Log::info('Pedido marcado como confirmado: ' . $pedidoId);
                    } else {
                        Log::warning('checkout.session.completed sin metadata.id_pedido');
                    }
                    break;
                case 'payment_intent.succeeded':
                    Log::info('PaymentIntent succeeded: ' . ($event['data']['object']['id'] ?? ''));
                    break;
            }
        }

        return response()->json(['received' => true]);
    }

    /**
     * Devuelve el número de pedidos del usuario autenticado.
     * GET /pedidos/mis/count
     */
    public function myOrdersCount(Request $request)
    {
        $user = $request->user();
        if (!$user) {
            return response()->json(['message' => 'Unauthorized'], 401);
        }

        try {
            $count = DB::table('pedidos')->where('id_usuario', $user->id)->count();
            return response()->json(['count' => $count]);
        } catch (\Exception $e) {
            Log::error('Error counting pedidos for user ' . $user->id . ': ' . $e->getMessage());
            return response()->json(['message' => 'Error retrieving pedidos count'], 500);
        }
    }
}
