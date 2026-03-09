<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ProductoController; // <--- ¡IMPORTANTE!

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

// Definición de rutas para Productos
// Esto generará automáticamente las rutas: /api/productos (GET, POST, etc.)
Route::get('/productos', [ProductoController::class, 'index']);
Route::post('/productos', [ProductoController::class, 'store']);
Route::get('/productos/{id}', [ProductoController::class, 'show']);
Route::put('/productos/{id}', [ProductoController::class, 'update']);
Route::delete('/productos/{id}', [ProductoController::class, 'destroy']);
