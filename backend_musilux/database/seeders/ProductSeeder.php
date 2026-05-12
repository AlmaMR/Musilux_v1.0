<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class ProductSeeder extends Seeder
{
    public function run(): void
    {
        $ahora = now();

        $productos = [];

        foreach ($productos as $producto) {
            // Generar slug único
            $producto['slug']       = Str::slug($producto['nombre']) . '-' . uniqid();
            $producto['creado_en']  = $ahora;
            $producto['actualizado_en'] = $ahora;

            // Usar UUID generado manualmente
            $id = (string) Str::uuid();
            DB::table('productos')->insert(array_merge(['id' => $id], $producto));
        }

        $this->command->info('✔  ' . count($productos) . ' productos insertados correctamente.');
    }
}
