<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Carbon\Carbon;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // Desactivar revisión de claves foráneas para poder limpiar las tablas
        DB::statement('SET FOREIGN_KEY_CHECKS=0;');
        DB::table('productos')->truncate();
        DB::table('categorias')->truncate();
        DB::statement('SET FOREIGN_KEY_CHECKS=1;');

        $now = Carbon::now();

        // ==========================================
        // 1. INSERTAR CATEGORÍAS
        // ==========================================
        // Guardamos los IDs para usarlos en los productos
        $catInstrumentosId = 1;
        $catIluminacionId = 2;
        $catVinilosId = 3;

        $categorias = [
            [
                'id' => $catInstrumentosId,
                'nombre' => 'Instrumentos',
                'slug' => 'instrumentos',
                'descripcion' => 'Guitarras, bajos, baterías y más.',
                'created_at' => $now,
                'updated_at' => $now,
            ],
            [
                'id' => $catIluminacionId,
                'nombre' => 'Iluminación',
                'slug' => 'iluminacion',
                'descripcion' => 'Luces LED, láseres y efectos para escenario.',
                'created_at' => $now,
                'updated_at' => $now,
            ],
            [
                'id' => $catVinilosId,
                'nombre' => 'Vinilos',
                'slug' => 'vinilos',
                'descripcion' => 'Discos de vinilo clásicos y modernos.',
                'created_at' => $now,
                'updated_at' => $now,
            ],
        ];

        DB::table('categorias')->insert($categorias);
        $this->command->info('Categorías insertadas correctamente.');

        // ==========================================
        // 2. INSERTAR PRODUCTOS
        // ==========================================
        
        $productos = [
            // --- VINILOS ---
            [
                'id' => Str::uuid()->toString(),
                'categoria_id' => $catVinilosId, // Relación con Vinilos
                'nombre' => 'In Utero - Nirvana',
                'slug' => 'in-utero-nirvana',
                'descripcion' => 'In Utero es el tercer y último álbum de estudio de la banda estadounidense de grunge Nirvana, lanzado el 13 de septiembre de 1993.',
                'tipo_producto' => 'fisico',
                'precio' => 599.99,
                'inventario' => 15,
                'bpm' => null,
                'esta_activo' => true,
                'created_at' => $now,
                'updated_at' => $now,
            ],
            [
                'id' => Str::uuid()->toString(),
                'categoria_id' => $catVinilosId,
                'nombre' => 'Sliver - Nirvana',
                'slug' => 'sliver-nirvana',
                'descripcion' => 'Sencillo clásico de la banda, edición especial remasterizada.',
                'tipo_producto' => 'fisico',
                'precio' => 299.99,
                'inventario' => 8,
                'bpm' => null,
                'esta_activo' => true,
                'created_at' => $now,
                'updated_at' => $now,
            ],
            [
                'id' => Str::uuid()->toString(),
                'categoria_id' => $catVinilosId,
                'nombre' => 'Incesticide 20 Anniversary',
                'slug' => 'incesticide-20-anniversary',
                'descripcion' => 'Compilación de rarezas, lados B y demos.',
                'tipo_producto' => 'fisico',
                'precio' => 1999.99,
                'inventario' => 3,
                'bpm' => null,
                'esta_activo' => true,
                'created_at' => $now,
                'updated_at' => $now,
            ],

            // --- INSTRUMENTOS ---
            [
                'id' => Str::uuid()->toString(),
                'categoria_id' => $catInstrumentosId, // Relación con Instrumentos
                'nombre' => 'Fender Bajo Eléctrico',
                'slug' => 'fender-bajo-electrico',
                'descripcion' => 'Bajo eléctrico de 4 cuerdas, ideal para principiantes y profesionales. Incluye funda.',
                'tipo_producto' => 'fisico',
                'precio' => 7999.99,
                'inventario' => 5,
                'bpm' => null,
                'esta_activo' => true,
                'created_at' => $now,
                'updated_at' => $now,
            ],
            [
                'id' => Str::uuid()->toString(),
                'categoria_id' => $catInstrumentosId,
                'nombre' => 'Guitarra Acústica Yamaha',
                'slug' => 'guitarra-acustica-yamaha',
                'descripcion' => 'Sonido cálido y resonante, madera de abeto.',
                'tipo_producto' => 'fisico',
                'precio' => 3500.00,
                'inventario' => 10,
                'bpm' => null,
                'esta_activo' => true,
                'created_at' => $now,
                'updated_at' => $now,
            ],

            // --- ILUMINACIÓN ---
            [
                'id' => Str::uuid()->toString(),
                'categoria_id' => $catIluminacionId, // Relación con Iluminación
                'nombre' => 'Bola de Discoteca Grande',
                'slug' => 'bola-discoteca-grande',
                'descripcion' => 'Bola de espejos de 50cm, perfecta para fiestas y eventos retro.',
                'tipo_producto' => 'fisico',
                'precio' => 1899.99,
                'inventario' => 20,
                'bpm' => null,
                'esta_activo' => true,
                'created_at' => $now,
                'updated_at' => $now,
            ],
            
            // --- SERVICIOS / DIGITAL ---
            [
                'id' => Str::uuid()->toString(),
                'categoria_id' => $catInstrumentosId,
                'nombre' => 'Clase de Guitarra Online',
                'slug' => 'clase-guitarra-online',
                'descripcion' => '1 hora de clase personalizada por Zoom.',
                'tipo_producto' => 'servicio',
                'precio' => 300.00,
                'inventario' => 100,
                'bpm' => null,
                'esta_activo' => true,
                'created_at' => $now,
                'updated_at' => $now,
            ],
        ];

        DB::table('productos')->insert($productos);
        $this->command->info('Productos insertados correctamente.');
    }
}
