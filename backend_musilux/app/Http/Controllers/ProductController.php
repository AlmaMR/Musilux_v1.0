<?php

namespace App\Http\Controllers;

use App\Models\Product;
use App\Models\ProductMedia;
use Illuminate\Http\Request;
use App\Http\Resources\ProductListResource;
use App\Http\Resources\ProductDetailResource;
use Illuminate\Validation\Rule;
use Illuminate\Support\Str;

class ProductController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $query = Product::with(['multimedia']);

        if ($request->has('category')) {
            $query->whereHas('category', function ($q) use ($request) {
                $q->where('slug', $request->category);
            });
        }

        $products = $query->get();

        return ProductListResource::collection($products);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $product = Product::with(['multimedia', 'category'])->findOrFail($id);
        return new ProductDetailResource($product);
    }

    /**
     * Store a newly created resource in storage (POST).
     */
    public function store(Request $request)
    {
        $data = $request->validate([
            'id_categoria' => 'nullable|integer|exists:categorias,id',
            'nombre' => 'required|string|max:255',
            'descripcion' => 'nullable|string',
            'tipo_producto' => [
                'required',
                'string',
                // Asegura que el valor enviado desde Flutter exista en la base de datos
                Rule::in(['fisico', 'digital', 'servicio']),
            ],
            'precio' => 'required|numeric|min:0',
            'inventario' => 'required|integer|min:0',
            'bpm' => 'nullable|integer',
            'esta_activo' => 'boolean',
            // Campos de Spotify (opcionales, solo para vinilos/digitales)
            'spotify_track_id' => 'nullable|string|max:255',
            'spotify_track_name' => 'nullable|string|max:255',
            'spotify_artist_name' => 'nullable|string|max:255',
            'spotify_preview_url' => 'nullable|string|max:500',
            'spotify_album_image_url' => 'nullable|string|max:500',
            // Usamos 'string' en lugar de 'url' porque FILTER_VALIDATE_URL de PHP
            // puede rechazar URLs de Firebase Storage que contienen %2F en el path.
            'imagen_url' => 'nullable|string|max:2048',
        ]);

        // Generar Slug automáticamente
        $data['slug'] = Str::slug($data['nombre']) . '-' . uniqid();

        // id_categoria es obligatoria en BD — usar categoría 1 (General) como fallback
        if (empty($data['id_categoria'])) {
            $data['id_categoria'] = 1;
        }

        // Asignar valor por defecto si es digital
        if (($data['tipo_producto'] ?? '') === 'digital') {
            $data['inventario'] = 0;
        }

        $imagenUrl = $data['imagen_url'] ?? null;
        unset($data['imagen_url']);

        $product = Product::create($data);

        if ($imagenUrl) {
            ProductMedia::create([
                'id_producto'     => $product->id,
                'tipo_multimedia' => 'imagen',
                'url_archivo'     => $imagenUrl,
                'es_principal'    => true,
            ]);
        }

        return (new ProductDetailResource($product->load(['multimedia', 'category'])))
            ->response()
            ->setStatusCode(201);
    }

    /**
     * Update the specified resource in storage (PUT/PATCH).
     */
    public function update(Request $request, string $id)
    {
        $product = Product::findOrFail($id);
        
        $data = $request->validate([
            'id_categoria' => 'nullable|exists:categorias,id',
            'nombre' => 'required|string|max:255',
            'descripcion' => 'nullable|string',
            'tipo_producto' => [
                'required',
                'string',
                // Asegura que el valor enviado desde Flutter exista en la base de datos
                Rule::in(['fisico', 'digital', 'servicio']),
            ],
            'precio' => 'required|numeric|min:0',
            'inventario' => 'required|integer|min:0',
            'bpm' => 'nullable|integer',
            'esta_activo' => 'boolean',
            // Campos de Spotify (opcionales)
            'spotify_track_id' => 'nullable|string|max:255',
            'spotify_track_name' => 'nullable|string|max:255',
            'spotify_artist_name' => 'nullable|string|max:255',
            'spotify_preview_url' => 'nullable|string|max:500',
            'spotify_album_image_url' => 'nullable|string|max:500',
            'imagen_url' => 'nullable|string|max:2048',
        ]);

        if (isset($data['nombre'])) {
            $data['slug'] = Str::slug($data['nombre']) . '-' . uniqid();
        }

        $imagenUrl = $data['imagen_url'] ?? null;
        unset($data['imagen_url']);

        $product->update($data);

        if ($imagenUrl) {
            // Reemplaza la imagen principal anterior
            $product->multimedia()->where('es_principal', true)->delete();
            ProductMedia::create([
                'id_producto'     => $product->id,
                'tipo_multimedia' => 'imagen',
                'url_archivo'     => $imagenUrl,
                'es_principal'    => true,
            ]);
        }

        return new ProductDetailResource($product->fresh()->load(['multimedia', 'category']));
    }

    /**
     * Remove the specified resource from storage (DELETE).
     */
    public function destroy(string $id)
    {
        $product = Product::findOrFail($id);
        $product->delete();

        return response()->json(null, 204);
    }
}
