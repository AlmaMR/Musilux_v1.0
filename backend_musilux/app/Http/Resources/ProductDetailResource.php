<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\Storage;

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
            // Campos de Spotify
            'spotify_track_id' => $this->spotify_track_id,
            'spotify_track_name' => $this->spotify_track_name,
            'spotify_artist_name' => $this->spotify_artist_name,
            'spotify_preview_url' => $this->spotify_preview_url,
            'spotify_album_image_url' => $this->spotify_album_image_url,
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
                        'url_archivo' => $this->resolveMediaUrl($media->url_archivo),
                        'es_principal' => (bool) $media->es_principal,
                    ];
                });
            }),
        ];
    }

    /**
     * Builds the full public URL for a media file.
     * If the value is already a full URL (external/Spotify images), returns as-is.
     * Otherwise builds the URL using Laravel Storage.
     */
    private function resolveMediaUrl(?string $path): ?string
    {
        if (empty($path)) return null;
        if (str_starts_with($path, 'http://') || str_starts_with($path, 'https://')) {
            return $path;
        }
        return url(Storage::url($path));
    }
}