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

    // Apunta a la tabla real del proyecto
    protected $table = 'usuarios';

    protected $primaryKey = 'id';
    protected $keyType = 'string';
    public $incrementing = false;

    // Mapeo de timestamps al esquema de la BD
    const CREATED_AT = 'creado_en';
    const UPDATED_AT = 'actualizado_en';

    protected $fillable = [
        'nombre',
        'email',
        'password_hash',
    ];

    protected $hidden = [
        'password_hash',
    ];

    /**
     * Laravel usa 'password' como campo de auth por defecto.
     * Mapeamos 'password' al campo real 'password_hash' de la BD.
     */
    public function getAuthPassword(): string
    {
        return $this->password_hash;
    }

    protected function casts(): array
    {
        return [
            'creado_en' => 'datetime',
            'actualizado_en' => 'datetime',
        ];
    }
}
