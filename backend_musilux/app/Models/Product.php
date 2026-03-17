<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Product extends Model
{
    use HasFactory, HasUuids;

    protected $table = 'productos';
    protected $primaryKey = 'id';
    protected $keyType = 'string';
    public $incrementing = false;

    // Mapeo de timestamps a las columnas en español de MySQL
    const CREATED_AT = 'creado_en';
    const UPDATED_AT = 'actualizado_en';

    protected $fillable = [
        'categoria_id',
        'nombre',
        'slug',
        'descripcion',
        'precio',
        'inventario',
        'esta_activo',
        'tipo_producto',
        'bpm',
    ];

    protected $casts = [
        'precio' => 'float',
        'esta_activo' => 'boolean',
        'inventario' => 'integer',
    ];

    public function category(): BelongsTo
    {
        return $this->belongsTo(Category::class, 'categoria_id');
    }

    public function tags(): BelongsToMany
    {
        // Asumiendo que la tabla pivote usa id_producto e id_etiqueta
        return $this->belongsToMany(Tag::class, 'producto_etiqueta', 'id_producto', 'id_etiqueta');
    }

    public function especificaciones(): HasMany
    {
        return $this->hasMany(ProductSpec::class, 'id_producto');
    }

    public function multimedia(): HasMany
    {
        return $this->hasMany(ProductImage::class, 'id_producto');
    }
}
