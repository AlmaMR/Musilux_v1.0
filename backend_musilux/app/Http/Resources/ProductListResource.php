<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ProductListResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'id_categoria' => $this->id_categoria,
            'nombre' => $this->nombre,
            'slug' => $this->slug,
            'precio' => (float) $this->precio,
            'tipo_producto' => $this->tipo_producto,
            'esta_activo' => (bool) $this->esta_activo,
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