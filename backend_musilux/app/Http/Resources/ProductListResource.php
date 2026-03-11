<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ProductListResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'title' => $this->nombre,
            'price' => $this->precio,
            'imageUrl' => $this->whenLoaded('multimedia', function () {
                $principal = $this->multimedia->firstWhere('es_principal', true);
                return $principal ? $principal->url_archivo : $this->multimedia->first()?->url_archivo;
            }),
            'tags' => $this->whenLoaded('tags', function () {
                return $this->tags->pluck('nombre');
            }),
            'isSale' => $this->whenLoaded('tags', function () {
                return $this->tags->contains('nombre', 'Oferta');
            }),
        ];
    }
}
