<?php

namespace Tests\Feature;

use Tests\TestCase;

class BackendServerTest extends TestCase
{
    /**
     * Verifica que el servidor PHP integrado puede iniciarse con el comando:
     * php -S 0.0.0.0:8080 -t public
     */
    public function test_backend_server_initialization(): void
    {
        $phpBinary = PHP_BINARY;
        $publicPath = base_path('public');
        
        // Comando del servidor: php -S 0.0.0.0:8080 -t public
        $command = escapeshellarg($phpBinary) . ' -S 0.0.0.0:8080 -t ' . escapeshellarg($publicPath);

        $descriptors = [
            0 => ['pipe', 'r'],
            1 => ['pipe', 'w'],
            2 => ['pipe', 'w'],
        ];

        $process = proc_open($command, $descriptors, $pipes, base_path());
        
        $this->assertIsResource($process, 'No se pudo iniciar el servidor con: ' . $command);

        try {
            // Esperar a que el servidor responda (máximo 10 segundos)
            $started = false;
            $deadline = microtime(true) + 10.0;
            $url = 'http://127.0.0.1:8080/';

            while (microtime(true) < $deadline) {
                $context = stream_context_create([
                    'http' => ['method' => 'GET', 'timeout' => 2],
                ]);

                $response = @file_get_contents($url, false, $context);
                if ($response !== false) {
                    $started = true;
                    break;
                }

                usleep(200000); // Esperar 200ms antes de reintentar
            }

            $this->assertTrue($started, 'El servidor no respondió en http://127.0.0.1:8080/ después de 10 segundos');

            // Verificar que recibimos una respuesta HTTP válida
            $headers = $http_response_header ?? [];
            $this->assertNotEmpty($headers, 'No se recibieron cabeceras HTTP del servidor');
            
        } finally {
            // Terminar el servidor
            @proc_terminate($process);
            @proc_close($process);
        }
    }
}
