<?php

namespace Tests\Feature;

use Stripe\Balance;
use Stripe\Stripe;
use Tests\TestCase;

class ExternalServicesIntegrationTest extends TestCase
{
    /**
     * Prueba la conectividad con la API de YouTube
     */
    public function test_youtube_api_connectivity(): void
    {
        $apiKey = env('YOUTUBE_API_KEY');
        if (empty($apiKey)) {
            $this->markTestSkipped('YOUTUBE_API_KEY no está configurada en .env');
        }

        // Usar un video ID conocido (Rick Roll) para la prueba
        $videoId = 'dQw4w9WgXcQ';
        $url = 'https://www.googleapis.com/youtube/v3/videos'
            . '?part=snippet,contentDetails,statistics'
            . '&id=' . urlencode($videoId)
            . '&key=' . urlencode($apiKey);

        $context = stream_context_create([
            'http' => [
                'method' => 'GET',
                'timeout' => 10,
                'user_agent' => 'Musilux/1.0',
            ],
        ]);

        $response = @file_get_contents($url, false, $context);
        
        $this->assertNotFalse($response, 'No se pudo conectar con la API de YouTube');
        
        $data = json_decode($response, true);
        $this->assertIsArray($data, 'La respuesta de YouTube no es JSON válido');
        $this->assertArrayHasKey('items', $data, 'La respuesta de YouTube no contiene "items"');
        $this->assertNotEmpty($data['items'], 'YouTube retornó lista de videos vacía para ID: ' . $videoId);
    }

    /**
     * Prueba la conectividad con la API de Gemini (Google AI)
     */
    public function test_gemini_api_connectivity(): void
    {
        $apiKey = env('GEMINI_API_KEY');
        if (empty($apiKey)) {
            $this->markTestSkipped('GEMINI_API_KEY no está configurada en .env');
        }

        $url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-8b:generateContent'
            . '?key=' . urlencode($apiKey);

        $payload = [
            'system_instruction' => [
                'parts' => [[
                    'text' => 'Eres un asistente de soporte para Musilux. Responde brevemente en español.',
                ]],
            ],
            'contents' => [
                [
                    'role' => 'user',
                    'parts' => [['text' => 'Di solo una palabra sobre música.']],
                ],
            ],
            'generationConfig' => [
                'temperature' => 0.3,
                'maxOutputTokens' => 64,
                'topP' => 0.9,
            ],
        ];

        $context = stream_context_create([
            'http' => [
                'method' => 'POST',
                'header' => "Content-Type: application/json\r\n",
                'content' => json_encode($payload),
                'timeout' => 15,
            ],
        ]);

        $response = @file_get_contents($url, false, $context);
        
        $this->assertNotFalse($response, 'No se pudo conectar con la API de Gemini');
        
        $data = json_decode($response, true);
        $this->assertIsArray($data, 'La respuesta de Gemini no es JSON válido');
        $this->assertArrayHasKey('candidates', $data, 'La respuesta de Gemini no contiene "candidates"');
        $this->assertNotEmpty($data['candidates'], 'Gemini retornó candidatos vacíos');
        
        $firstCandidate = $data['candidates'][0];
        $this->assertArrayHasKey('content', $firstCandidate, 'Gemini: candidato sin "content"');
        $this->assertArrayHasKey('parts', $firstCandidate['content'], 'Gemini: content sin "parts"');
        $this->assertNotEmpty($firstCandidate['content']['parts'], 'Gemini: parts vacío');
    }

    /**
     * Prueba la conectividad con la API de Stripe
     */
    public function test_stripe_api_connectivity(): void
    {
        $secret = env('STRIPE_SECRET');
        if (empty($secret)) {
            $this->markTestSkipped('STRIPE_SECRET no está configurada en .env');
        }

        Stripe::setApiKey($secret);

        try {
            $balance = Balance::retrieve();
            
            $this->assertNotNull($balance, 'Balance::retrieve() retornó null');
            $this->assertEquals('balance', $balance->object, 'El objeto retornado no es de tipo "balance"');
            
            // Verificar estructura básica del balance
            $this->assertObjectHasProperty('available', $balance);
            $this->assertObjectHasProperty('pending', $balance);
            
        } catch (\Exception $e) {
            $this->fail('Error al conectar con Stripe API: ' . $e->getMessage());
        }
    }

    /**
     * Prueba que todas las claves API requeridas están configuradas
     */
    public function test_all_external_services_configured(): void
    {
        $requiredKeys = [
            'YOUTUBE_API_KEY',
            'GEMINI_API_KEY',
            'STRIPE_SECRET',
            'STRIPE_PUBLICABLE',
        ];

        foreach ($requiredKeys as $key) {
            $value = env($key);
            $this->assertNotEmpty(
                $value,
                "La clave de configuración requerida '{$key}' no está configurada en .env"
            );
        }
    }
}
