<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Concerns\HasUuids; // Importante para UUID

class Producto extends Model
{
    use HasFactory, HasUuids; // HasUuids permite que Laravel genere el UUID automáticamente al crear

    // 1. Definir nombre de la tabla explícitamente
    protected $table = 'productos';

    // 2. Configurar la llave primaria (UUID)
    protected $primaryKey = 'id';
    protected $keyType = 'string';
    public $incrementing = false;

    // 3. Mapear los Timestamps personalizados
    // const CREATED_AT = 'creado_en';
    // const UPDATED_AT = 'actualizado_en';

    // 4. Definir los campos que se pueden llenar masivamente
    protected $fillable = [
        'categoria_id',
        'nombre',
        'slug',
        'descripcion',
        'tipo_producto', // ENUM: 'fisico', 'digital', 'servicio'
        'precio',
        'inventario',
        'bpm',
        'esta_activo'
    ];

    // 5. Casts para asegurar tipos de datos correctos
    protected $casts = [
        'precio' => 'decimal:2',
        'esta_activo' => 'boolean',
        'inventario' => 'integer',
        'bpm' => 'integer',
    ];
}
