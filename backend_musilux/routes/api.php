<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\SpotifyController;
use Illuminate\Support\Facades\DB;

// ──────────────────────────────────────────────
// Rutas de Autenticación (públicas)
// ──────────────────────────────────────────────
Route::prefix('auth')->group(function () {
    Route::post('/register', [AuthController::class, 'register']);
    Route::post('/login',    [AuthController::class, 'login']);

    // Requieren token válido
    Route::middleware('auth:sanctum')->group(function () {
        Route::post('/logout', [AuthController::class, 'logout']);
        Route::get('/me',      [AuthController::class, 'me']);
    });
});

// ──────────────────────────────────────────────
// Rutas de Productos
// Lectura pública — escritura protegida por token
// ──────────────────────────────────────────────
Route::get('/products',       [ProductController::class, 'index']);
Route::get('/products/{id}',  [ProductController::class, 'show']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/products',          [ProductController::class, 'store']);
    Route::put('/products/{id}',      [ProductController::class, 'update']);
    Route::delete('/products/{id}',   [ProductController::class, 'destroy']);
});

// ──────────────────────────────────────────────
// Búsqueda Spotify (pública, backend actúa de proxy)
// ──────────────────────────────────────────────
Route::get('/spotify/search', [SpotifyController::class, 'search']);

// ──────────────────────────────────────────────
// Debug (solo desarrollo — eliminar en producción)
// ──────────────────────────────────────────────
Route::get('/debug-db', function () {
    $config = [
        'DB_CONNECTION' => config('database.default'),
        'DB_HOST'       => config('database.connections.mysql.host'),
        'DB_PORT'       => config('database.connections.mysql.port'),
        'DB_DATABASE'   => config('database.connections.mysql.database'),
        'DB_USERNAME'   => config('database.connections.mysql.username'),
        'DB_PASSWORD'   => config('database.connections.mysql.password') ? '********' : '(empty)',
    ];

    try {
        DB::connection()->getPdo();
        $db_status = 'Successfully connected to the database.';
    } catch (\Exception $e) {
        $db_status = 'Could not connect to the database. Error: ' . $e->getMessage();
    }

    return response()->json([
        'database_config' => $config,
        'database_status' => $db_status,
    ]);
});
