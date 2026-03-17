<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ProductDetailResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'id_categoria' => $this->id_categoria,
            'nombre' => $this->nombre,
            'slug' => $this->slug,
            'descripcion' => $this->descripcion,
            'tipo_producto' => $this->tipo_producto,
            'precio' => (float) $this->precio,
            'inventario' => (int) $this->inventario,
            'bpm' => $this->bpm,
            'esta_activo' => (bool) $this->esta_activo,
            'categoria' => $this->whenLoaded('category', function () {
                return [
                    'id' => $this->category->id,
                    'nombre' => $this->category->nombre,
                    'slug' => $this->category->slug,
                ];
            }),
            'multimedia' => $this->whenLoaded('multimedia', function () {
                return $this->multimedia->map(function ($media) {
                    return [
                        'id' => $media->id,
                        'tipo_multimedia' => $media->tipo_multimedia,
                        'url_archivo' => $media->url_archivo,
                        'es_principal' => (bool) $media->es_principal,
                    ];
                });
            }),
        ];
    }
}