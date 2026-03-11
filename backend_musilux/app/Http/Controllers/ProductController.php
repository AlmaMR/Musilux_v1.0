<?php

namespace App\Http\Controllers;

use App\Models\Product;
use Illuminate\Http\Request;
use App\Http\Resources\ProductListResource;
use App\Http\Resources\ProductDetailResource;

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
}
