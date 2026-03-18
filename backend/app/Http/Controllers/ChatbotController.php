<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use OpenAI\Laravel\Facades\OpenAI;

class ChatbotController extends Controller
{
    public function chat(Request $request)
    {
        $request->validate([
            'message' => 'required|string'
        ]);

        $userMessage = $request->input('message');

        $response = OpenAI::chat()->create([
            'model' => 'gpt-4o-mini',
            'messages' => [
                [
                    'role' => 'system',
                    'content' => 'Eres un asistente de atención al cliente de Musilux. Ayudas con productos musicales, pedidos y soporte.'
                ],
                [
                    'role' => 'user',
                    'content' => $userMessage
                ]
            ],
        ]);

        return response()->json([
            'reply' => $response->choices[0]->message->content
        ]);
    }
}