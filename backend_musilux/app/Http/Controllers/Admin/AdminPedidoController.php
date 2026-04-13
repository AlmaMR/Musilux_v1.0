<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class AdminPedidoController extends Controller
{
    /**
     * Lista todos los pedidos con paginación.
     * GET /api/admin/pedidos
     * Middleware: permiso:pedidos.leer
     */
    public function index(Request $request): JsonResponse
    {
        // TODO: implementar cuando exista el modelo Pedido
        return response()->json([
            'data'    => [],
            'message' => 'Módulo de pedidos en construcción.',
        ]);
    }

    /**
     * Muestra el detalle de un pedido.
     * GET /api/admin/pedidos/{id}
     * Middleware: permiso:pedidos.leer
     */
    public function show(string $id): JsonResponse
    {
        return response()->json([
            'data'    => null,
            'message' => 'Módulo de pedidos en construcción.',
        ]);
    }

    /**
     * Actualiza el estado o la guía de envío de un pedido.
     * PUT /api/admin/pedidos/{id}/estado
     * Middleware: permiso:pedidos.actualizar
     */
    public function actualizarEstado(Request $request, string $id): JsonResponse
    {
        $request->validate([
            'estado'      => 'sometimes|string|max:50',
            'guia_envio'  => 'sometimes|string|max:100',
        ]);

        // TODO: implementar cuando exista el modelo Pedido
        return response()->json([
            'message' => 'Estado actualizado (módulo en construcción).',
        ]);
    }
}
