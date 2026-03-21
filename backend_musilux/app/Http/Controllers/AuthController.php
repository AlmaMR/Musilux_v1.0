<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    /**
     * Registro de nuevo usuario.
     * POST /api/auth/register
     */
    public function register(Request $request): JsonResponse
    {
        $data = $request->validate([
            'nombre' => 'required|string|max:255',
            'email'  => 'required|email|unique:usuarios,email',
            'password' => 'required|string|min:8|confirmed',
        ]);

        $user = User::create([
            'nombre'        => $data['nombre'],
            'email'         => $data['email'],
            'password_hash' => Hash::make($data['password']),
        ]);

        $token = $user->createToken('musilux-token')->plainTextToken;

        return response()->json([
            'user'  => [
                'id'     => $user->id,
                'nombre' => $user->nombre,
                'email'  => $user->email,
            ],
            'token' => $token,
        ], 201);
    }

    /**
     * Inicio de sesión.
     * POST /api/auth/login
     */
    public function login(Request $request): JsonResponse
    {
        $request->validate([
            'email'    => 'required|email',
            'password' => 'required|string',
        ]);

        $user = User::where('email', $request->email)->first();

        if (! $user || ! Hash::check($request->password, $user->password_hash)) {
            throw ValidationException::withMessages([
                'email' => ['Las credenciales son incorrectas.'],
            ]);
        }

        // Revocar tokens anteriores para mantener solo una sesión activa
        $user->tokens()->delete();

        $token = $user->createToken('musilux-token')->plainTextToken;

        return response()->json([
            'user' => [
                'id'     => $user->id,
                'nombre' => $user->nombre,
                'email'  => $user->email,
            ],
            'token' => $token,
        ]);
    }

    /**
     * Cierre de sesión (revoca el token actual).
     * POST /api/auth/logout
     */
    public function logout(Request $request): JsonResponse
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json(['message' => 'Sesión cerrada correctamente.']);
    }

    /**
     * Retorna el usuario autenticado.
     * GET /api/auth/me
     */
    public function me(Request $request): JsonResponse
    {
        $user = $request->user();
        return response()->json([
            'id'     => $user->id,
            'nombre' => $user->nombre,
            'email'  => $user->email,
        ]);
    }
}
