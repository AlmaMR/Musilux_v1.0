<?php

namespace App\Http\Controllers;

use App\Models\Producto;
use Illuminate\Http\Request;
use Illuminate\Support\Str; // Para generar el slug

class ProductoController extends Controller
{
    public function index()
    {
        // Retornamos solo los productos activos
        return response()->json(Producto::where('esta_activo', true)->get(), 200);
    }

    public function store(Request $request)
    {
        // Validaciones según tu esquema SQL
        $request->validate([
            'categoria_id' => 'required|exists:categorias,id',
            'nombre' => 'required|string|max:200',
            'tipo_producto' => 'required|in:fisico,digital,servicio',
            'precio' => 'required|numeric|min:0',
            'inventario' => 'integer|min:0',
        ]);

        $data = $request->all();

        // Generar Slug automáticamente basado en el nombre
        $data['slug'] = Str::slug($request->nombre) . '-' . uniqid(); 
        
        // Asignar valor por defecto si es digital (inventario 0 según tu comentario SQL)
        if ($data['tipo_producto'] === 'digital') {
            $data['inventario'] = 0;
        }

        $producto = Producto::create($data);

        return response()->json($producto, 201);
    }

    public function show($id)
    {
        $producto = Producto::find($id);
        if (!$producto) {
            return response()->json(['message' => 'Producto no encontrado'], 404);
        }
        return response()->json($producto, 200);
    }

    public function update(Request $request, $id)
    {
        $producto = Producto::find($id);
        if (!$producto) {
            return response()->json(['message' => 'Producto no encontrado'], 404);
        }

        // Si actualizan el nombre, actualizamos el slug
        $data = $request->all();
        if ($request->has('nombre')) {
            $data['slug'] = Str::slug($request->nombre) . '-' . uniqid();
        }

        $producto->update($data);
        return response()->json($producto, 200);
    }

    public function destroy($id)
    {
        $producto = Producto::find($id);
        if (!$producto) {
            return response()->json(['message' => 'Producto no encontrado'], 404);
        }
        
        // Opción A: Borrado físico (DELETE FROM...)
        $producto->delete();
        
        // Opción B: Borrado lógico (recomendado para mantener integridad)
        // $producto->update(['esta_activo' => false]);

        return response()->json(['message' => 'Producto eliminado'], 200);
    }
}
