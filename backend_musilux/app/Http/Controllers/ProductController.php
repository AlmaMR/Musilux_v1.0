<?php

namespace App\Http\Controllers;

use App\Models\Product;
use Illuminate\Http\Request;
use App\Http\Resources\ProductListResource;
use App\Http\Resources\ProductDetailResource;
use Illuminate\Validation\Rule;
use Illuminate\Support\Str; // Importamos Str para generar los slugs

class ProductController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $query = Product::with(['multimedia', 'tags']);

        if ($request->has('category')) {
            $query->whereHas('category', function ($q) use ($request) {
                $q->where('slug', $request->category);
            });
        }

        if ($request->has('tag')) {
            $query->whereHas('tags', function ($q) use ($request) {
                $q->where('nombre', $request->tag);
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
        $product = Product::with(['multimedia', 'tags', 'especificaciones'])->findOrFail($id);
        return new ProductDetailResource($product);
    }

    /**
     * Store a newly created resource in storage (POST).
     */
    public function store(Request $request)
    {
        $request->validate([
            'categoria_id' => 'required|exists:categorias,id',
            'nombre' => 'required|string|max:255',
            'descripcion' => 'nullable|string',
            'tipo_producto' => [
                'required',
                'string',
                // Asegura que el valor enviado desde Flutter exista en la base de datos
                Rule::in(['vinilo', 'instrumento', 'iluminacion', 'fisico', 'digital', 'servicio']),
            ],
            'precio' => 'required|numeric|min:0',
            'inventario' => 'required|integer|min:0',
            'bpm' => 'nullable|integer',
            'esta_activo' => 'boolean',
        ]);

        $data = $request->all();

        // Generar Slug automáticamente
        $data['slug'] = Str::slug($request->nombre) . '-' . uniqid();

        // Asignar valor por defecto si es digital
        if (($data['tipo_producto'] ?? '') === 'digital') {
            $data['inventario'] = 0;
        }

        $product = Product::create($data);

        return new ProductDetailResource($product->load(['multimedia', 'tags', 'especificaciones']));
    }

    /**
     * Update the specified resource in storage (PUT/PATCH).
     */
    public function update(Request $request, string $id)
    {
        $product = Product::findOrFail($id);
        
        $request->validate([
            'categoria_id' => 'required|exists:categorias,id',
            'nombre' => 'required|string|max:255',
            'descripcion' => 'nullable|string',
            'tipo_producto' => [
                'required',
                'string',
                // Asegura que el valor enviado desde Flutter exista en la base de datos
                Rule::in(['vinilo', 'instrumento', 'iluminacion', 'fisico', 'digital', 'servicio']),
            ],
            'precio' => 'required|numeric|min:0',
            'inventario' => 'required|integer|min:0',
            'bpm' => 'nullable|integer',
            'esta_activo' => 'boolean',
        ]);

        $data = $request->all();
        if ($request->filled('nombre')) {
            $data['slug'] = Str::slug($request->nombre) . '-' . uniqid();
        }

        $product->update($data);
        return new ProductDetailResource($product->fresh()->load(['multimedia', 'tags', 'especificaciones']));
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
