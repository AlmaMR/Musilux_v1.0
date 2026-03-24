<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasFactory, Notifiable, HasUuids, HasApiTokens;

    protected $table = 'usuarios';

    protected $primaryKey = 'id';
    protected $keyType = 'string';
    public $incrementing = false;

    const CREATED_AT = 'creado_en';
    const UPDATED_AT = 'actualizado_en';

    protected $fillable = [
        'id_rol',
        'nombres',
        'apellidos',
        'correo',
        'contrasena_hash',
        'esta_activo',
    ];

    protected $hidden = [
        'contrasena_hash',
    ];

    public function getAuthPassword(): string
    {
        return $this->contrasena_hash;
    }

    public function rol()
    {
        return $this->belongsTo(Rol::class, 'id_rol');
    }

    protected function casts(): array
    {
        return [
            'esta_activo'    => 'boolean',
            'creado_en'      => 'datetime',
            'actualizado_en' => 'datetime',
        ];
    }
}
