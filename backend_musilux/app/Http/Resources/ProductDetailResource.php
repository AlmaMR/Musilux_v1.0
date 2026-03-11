<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ProductDetailResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'titulo' => $this->nombre,
            'precio' => $this->precio,
            'desc' => $this->descripcion,
            'img' => $this->whenLoaded('multimedia', function () {
                $principal = $this->multimedia->firstWhere('es_principal', true);
                return $principal ? $principal->url_archivo : $this->multimedia->first()?->url_archivo;
            }),
            'specs' => $this->whenLoaded('especificaciones', function () {
                return $this->especificaciones->map(fn($spec) => "{$spec->clave}: {$spec->valor}");
            }),
            'tipo_producto' => $this->tipo_producto,
        ];
    }
}
