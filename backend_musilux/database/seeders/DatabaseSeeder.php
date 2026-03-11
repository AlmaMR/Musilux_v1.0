<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use App\Models\Category;
use App\Models\Product;
use App\Models\Tag;
use App\Models\ProductSpec;
use App\Models\ProductImage;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // Limpiar tablas
        DB::statement('SET FOREIGN_KEY_CHECKS=0');
        Product::truncate();
        Category::truncate();
        Tag::truncate();
        ProductSpec::truncate();
        ProductImage::truncate();
        DB::table('producto_etiqueta')->truncate();
        DB::statement('SET FOREIGN_KEY_CHECKS=1');

        // Crear Categorías
        $catInstrumentos = Category::create(['nombre' => 'Instrumentos', 'slug' => 'instrumentos']);
        $catIluminacion = Category::create(['nombre' => 'Iluminación', 'slug' => 'iluminacion']);
        $catVinilos = Category::create(['nombre' => 'Vinilos', 'slug' => 'vinilos']);
        $catAudio = Category::create(['nombre' => 'Audio', 'slug' => 'audio']);

        // Crear Etiquetas
        $tagRock = Tag::create(['nombre' => 'Rock']);
        $tagOferta = Tag::create(['nombre' => 'Oferta']);
        $tagGuitarras = Tag::create(['nombre' => 'Guitarras']);
        $tagProfesional = Tag::create(['nombre' => 'Profesional']);
        $tagLed = Tag::create(['nombre' => 'LED']);
        $tagBaterias = Tag::create(['nombre' => 'Baterías']);
        $tagDj = Tag::create(['nombre' => 'DJ']);
        $tagAcustica = Tag::create(['nombre' => 'Acústica']);
        $tagTeclados = Tag::create(['nombre' => 'Teclados']);


        // --- PRODUCTOS ---

        // 1. In Utero - Nirvana
        $nirvana = Product::create([
            'categoria_id' => $catVinilos->id,
            'nombre' => 'In Utero - Nirvana',
            'descripcion' => '"In Utero" es una grabación aullante y desafiantemente punk, un retroceso poco sentimental a una era de epifanías de bandas de garaje y rock and roll crudo y sin adornos.',
            'precio' => 599.99,
            'stock' => 50,
            'esta_activo' => true,
            'tipo_producto' => 'vinilo'
        ]);
        $nirvana->tags()->attach([$tagRock->id, $tagOferta->id]);
        ProductSpec::create(['producto_id' => $nirvana->id, 'clave' => 'Dimensiones', 'valor' => '31x31 cm']);
        ProductSpec::create(['producto_id' => $nirvana->id, 'clave' => 'Discos', 'valor' => '1']);
        ProductImage::create(['producto_id' => $nirvana->id, 'url_archivo' => 'https://images.unsplash.com/photo-1526478806334-5fd488fcaabc?w=600', 'es_principal' => true]);
        ProductImage::create(['producto_id' => $nirvana->id, 'url_archivo' => 'https://images.unsplash.com/photo-1619983081563-430f63602796?w=100', 'es_principal' => false]);

        // 2. Fender Stratocaster
        $fender = Product::create([
            'categoria_id' => $catInstrumentos->id,
            'nombre' => 'Fender Stratocaster',
            'descripcion' => 'La Stratocaster es el arquetipo de la guitarra eléctrica. Cuenta con un mástil de arce, cuerpo de aliso y 3 pastillas de bobina simple para un tono cristalino y versátil.',
            'precio' => 4999.99,
            'stock' => 20,
            'esta_activo' => true,
            'tipo_producto' => 'instrumento'
        ]);
        $fender->tags()->attach([$tagGuitarras->id, $tagProfesional->id]);
        ProductSpec::create(['producto_id' => $fender->id, 'clave' => 'Cuerpo', 'valor' => 'Aliso']);
        ProductSpec::create(['producto_id' => $fender->id, 'clave' => 'Mástil', 'valor' => 'Arce']);
        ProductImage::create(['producto_id' => $fender->id, 'url_archivo' => 'https://images.unsplash.com/photo-1564186763535-ebb21ef5277f?w=600', 'es_principal' => true]);

        // 3. Cabeza Móvil Beam 230W
        $beam = Product::create([
            'categoria_id' => $catIluminacion->id,
            'nombre' => 'Cabeza Móvil Beam 230W',
            'descripcion' => 'Foco láser profesional con tecnología LED RGB. Perfecto para escenarios, discotecas y eventos en vivo. Controlable vía DMX o de forma automática rítmica.',
            'precio' => 850.00,
            'stock' => 30,
            'esta_activo' => true,
            'tipo_producto' => 'iluminacion'
        ]);
        $beam->tags()->attach([$tagProfesional->id, $tagLed->id]);
        ProductSpec::create(['producto_id' => $beam->id, 'clave' => 'Potencia', 'valor' => '230W']);
        ProductSpec::create(['producto_id' => $beam->id, 'clave' => 'DMX', 'valor' => 'Sí']);
        ProductImage::create(['producto_id' => $beam->id, 'url_archivo' => 'https://images.unsplash.com/photo-1533923156502-be31530547c4?w=600', 'es_principal' => true]);

        // --- Productos Adicionales de home_screen.dart ---
        $bateria = Product::create([
            'categoria_id' => $catInstrumentos->id,
            'nombre' => 'Batería Acústica Yamaha',
            'descripcion' => 'Batería acústica completa para principiantes y avanzados.',
            'precio' => 15499.00,
            'stock' => 15,
            'esta_activo' => true,
            'tipo_producto' => 'instrumento'
        ]);
        $bateria->tags()->attach([$tagBaterias->id, $tagOferta->id]);
        ProductImage::create(['producto_id' => $bateria->id, 'url_archivo' => 'https://m.media-amazon.com/images/S/aplus-media-library-service-media/e04da6f5-c8dd-43a8-b82a-ef27cb61cec2.__CR0,0,600,600_PT0_SX300_V1___.png', 'es_principal' => true]);

        $djControl = Product::create([
            'categoria_id' => $catAudio->id,
            'nombre' => 'Controlador DJ Pioneer',
            'descripcion' => 'Controlador de 2 canales para DJ, compatible con Serato y Rekordbox.',
            'precio' => 6200.00,
            'stock' => 25,
            'esta_activo' => true,
            'tipo_producto' => 'instrumento' // Asumido como instrumento
        ]);
        $djControl->tags()->attach([$tagAudio->id, $tagDj->id]);
        ProductImage::create(['producto_id' => $djControl->id, 'url_archivo' => 'https://m.media-amazon.com/images/I/81O80Pn0ZsL._AC_UF1000,1000_QL80_.jpg', 'es_principal' => true]);

        $taylor = Product::create([
            'categoria_id' => $catInstrumentos->id,
            'nombre' => 'Guitarra Acústica Taylor',
            'descripcion' => 'Guitarra acústica de alta gama con un sonido rico y resonante.',
            'precio' => 9500.00,
            'stock' => 10,
            'esta_activo' => true,
            'tipo_producto' => 'instrumento'
        ]);
        $taylor->tags()->attach([$tagGuitarras->id, $tagAcustica->id]);
        ProductImage::create(['producto_id' => $taylor->id, 'url_archivo' => 'https://m.media-amazon.com/images/I/7115TB+TXeL.jpg', 'es_principal' => true]);
    }
}
