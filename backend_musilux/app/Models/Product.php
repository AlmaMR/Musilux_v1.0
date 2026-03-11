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

    protected $fillable = [
        'categoria_id',
        'nombre',
        'descripcion',
        'precio',
        'stock',
        'esta_activo',
        'tipo_producto',
    ];

    protected $casts = [
        'precio' => 'float',
        'esta_activo' => 'boolean',
        'stock' => 'integer',
    ];

    public function category(): BelongsTo
    {
        return $this->belongsTo(Category::class, 'categoria_id');
    }

    public function tags(): BelongsToMany
    {
        return $this->belongsToMany(Tag::class, 'producto_etiqueta', 'producto_id', 'etiqueta_id');
    }

    public function especificaciones(): HasMany
    {
        return $this->hasMany(ProductSpec::class, 'producto_id');
    }

    public function multimedia(): HasMany
    {
        return $this->hasMany(ProductImage::class, 'producto_id');
    }
}
