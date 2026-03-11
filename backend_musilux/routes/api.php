<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ProductController;
use Illuminate\Support\Facades\DB;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::apiResource('products', ProductController::class);

Route::get('/debug-db', function () {
    $config = [
        'DB_CONNECTION' => config('database.default'),
        'DB_HOST' => config('database.connections.mysql.host'),
        'DB_PORT' => config('database.connections.mysql.port'),
        'DB_DATABASE' => config('database.connections.mysql.database'),
        'DB_USERNAME' => config('database.connections.mysql.username'),
        'DB_PASSWORD' => config('database.connections.mysql.password') ? '********' : '(empty)',
    ];

    try {
        DB::connection()->getPdo();
        $db_status = 'Successfully connected to the database.';
    } catch (\Exception $e) {
        $db_status = 'Could not connect to the database. Error: ' . $e->getMessage();
    }

    return response()->json([
        'database_config' => $config,
        'database_status' => $db_status
    ]);
});
