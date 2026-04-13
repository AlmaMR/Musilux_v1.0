<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\RolController;
use App\Http\Controllers\SpotifyController;
use App\Http\Controllers\Admin\AdminPedidoController;
use App\Http\Controllers\Admin\AdminUsuarioController;
use App\Http\Controllers\Admin\ReporteController;
use App\Http\Controllers\Admin\CuponController;
use App\Http\Controllers\Admin\TicketController;
use App\Http\Controllers\Admin\RolAdminController;

// ──────────────────────────────────────────────
// Roles (público — necesario antes del registro)
// ──────────────────────────────────────────────
Route::get('/roles', [RolController::class, 'index']);

// ──────────────────────────────────────────────
// Autenticación
// ──────────────────────────────────────────────
Route::prefix('auth')->group(function () {

    // Públicas
    Route::get('/roles',     [AuthController::class, 'roles']);
    Route::post('/register', [AuthController::class, 'register']);
    Route::post('/login',    [AuthController::class, 'login']);

    // Requieren token válido
    Route::middleware('auth:sanctum')->group(function () {
        Route::post('/logout', [AuthController::class, 'logout']);
        Route::get('/me',      [AuthController::class, 'me']);
    });
});

// ──────────────────────────────────────────────
// Productos — lectura pública
// ──────────────────────────────────────────────
Route::get('/products',      [ProductController::class, 'index']);
Route::get('/products/{id}', [ProductController::class, 'show']);

// ──────────────────────────────────────────────
// Spotify (público — backend actúa de proxy)
// ──────────────────────────────────────────────
Route::get('/spotify/search', [SpotifyController::class, 'search']);

// ──────────────────────────────────────────────
// Rutas autenticadas
// ──────────────────────────────────────────────
Route::middleware('auth:sanctum')->group(function () {

    // Productos — escritura protegida por permiso granular
    Route::middleware('permiso:productos.crear')->group(function () {
        Route::post('/products', [ProductController::class, 'store']);
    });

    Route::middleware('permiso:productos.actualizar')->group(function () {
        Route::put('/products/{id}', [ProductController::class, 'update']);
    });

    Route::middleware('permiso:productos.eliminar')->group(function () {
        Route::delete('/products/{id}', [ProductController::class, 'destroy']);
    });

    // ──────────────────────────────────────────
    // PANEL ADMIN — prefijo /admin
    // ──────────────────────────────────────────
    Route::prefix('admin')->group(function () {

        // Admin inventario — CRUD productos
        Route::middleware('permiso:productos.crear,productos.actualizar,productos.eliminar')
            ->group(function () {
                Route::post('/products',        [ProductController::class, 'store']);
                Route::put('/products/{id}',    [ProductController::class, 'update']);
                Route::delete('/products/{id}', [ProductController::class, 'destroy']);
            });

        // Admin pedidos
        Route::middleware('permiso:pedidos.leer')->group(function () {
            Route::get('/pedidos',       [AdminPedidoController::class, 'index']);
            Route::get('/pedidos/{id}',  [AdminPedidoController::class, 'show']);
        });
        Route::middleware('permiso:pedidos.actualizar')->group(function () {
            Route::put('/pedidos/{id}/estado', [AdminPedidoController::class, 'actualizarEstado']);
        });

        // Admin usuarios
        Route::middleware('permiso:usuarios.leer')->group(function () {
            Route::get('/usuarios',      [AdminUsuarioController::class, 'index']);
            Route::get('/usuarios/{id}', [AdminUsuarioController::class, 'show']);
        });
        Route::middleware('permiso:usuarios.actualizar')->group(function () {
            Route::put('/usuarios/{id}', [AdminUsuarioController::class, 'update']);
        });
        Route::middleware('permiso:usuarios.eliminar')->group(function () {
            Route::delete('/usuarios/{id}', [AdminUsuarioController::class, 'suspender']);
        });

        // Admin ventas
        Route::middleware('permiso:reportes.leer')->group(function () {
            Route::get('/reportes/ingresos', [ReporteController::class, 'ingresos']);
            Route::get('/reportes/metricas', [ReporteController::class, 'metricas']);
        });
        Route::middleware('permiso:cupones.crear,cupones.actualizar')->group(function () {
            Route::get('/cupones',       [CuponController::class, 'index']);
            Route::post('/cupones',      [CuponController::class, 'store']);
            Route::put('/cupones/{id}',  [CuponController::class, 'update']);
        });

        // Admin soporte
        Route::middleware('permiso:tickets.leer')->group(function () {
            Route::get('/tickets',       [TicketController::class, 'index']);
            Route::get('/tickets/{id}',  [TicketController::class, 'show']);
        });
        Route::middleware('permiso:tickets.crear,tickets.actualizar')->group(function () {
            Route::post('/tickets/{id}/respuestas', [TicketController::class, 'responder']);
            Route::put('/tickets/{id}/estado',      [TicketController::class, 'actualizarEstado']);
        });

        // Superadmin — gestión de roles y permisos
        Route::middleware('permiso:roles.leer,roles.crear,roles.actualizar,roles.eliminar')
            ->group(function () {
                Route::get('/roles',                   [RolAdminController::class, 'index']);
                Route::post('/roles',                  [RolAdminController::class, 'store']);
                Route::put('/roles/{id}',              [RolAdminController::class, 'update']);
                Route::delete('/roles/{id}',           [RolAdminController::class, 'destroy']);
                Route::post('/roles/{id}/permisos',    [RolAdminController::class, 'asignarPermisos']);
            });
    });
});

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
