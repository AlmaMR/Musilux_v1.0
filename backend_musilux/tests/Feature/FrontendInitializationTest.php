<?php

namespace Tests\Feature;

use Tests\TestCase;

class FrontendInitializationTest extends TestCase
{
    /**
     * Verifica que la estructura del frontend Flutter existe
     * El frontend se inicializa con: flutter run
     */
    public function test_flutter_project_structure_exists(): void
    {
        $basePath = dirname(base_path());
        $flutterPath = $basePath . DIRECTORY_SEPARATOR . 'musilux';
        
        $this->assertDirectoryExists(
            $flutterPath,
            'La carpeta del proyecto Flutter no existe en: ' . $flutterPath
        );

        // Verificar archivos clave de Flutter
        $requiredFiles = [
            'pubspec.yaml',
            'lib' . DIRECTORY_SEPARATOR . 'main.dart',
            'android' . DIRECTORY_SEPARATOR . 'build.gradle.kts',
            'ios' . DIRECTORY_SEPARATOR . 'Runner.xcodeproj',
            'web' . DIRECTORY_SEPARATOR . 'index.html',
        ];

        foreach ($requiredFiles as $file) {
            $path = $flutterPath . DIRECTORY_SEPARATOR . $file;
            $this->assertTrue(
                file_exists($path) || is_dir($path),
                'Archivo/carpeta requerido no existe: ' . $path
            );
        }
    }

    /**
     * Verifica que pubspec.yaml existe y es válido
     */
    public function test_pubspec_yaml_is_valid(): void
    {
        $basePath = dirname(base_path());
        $pubspecPath = $basePath . DIRECTORY_SEPARATOR . 'musilux' . DIRECTORY_SEPARATOR . 'pubspec.yaml';
        
        $this->assertFileExists($pubspecPath, 'pubspec.yaml no encontrado en: ' . $pubspecPath);
        
        $content = file_get_contents($pubspecPath);
        $this->assertNotFalse($content, 'No se pudo leer pubspec.yaml');
        
        // Verificar estructura básica YAML
        $this->assertStringContainsString('name:', $content, 'pubspec.yaml no contiene "name:"');
        $this->assertStringContainsString('version:', $content, 'pubspec.yaml no contiene "version:"');
    }

    /**
     * Verifica que el main.dart existe y contiene runApp
     */
    public function test_main_dart_structure_valid(): void
    {
        $basePath = dirname(base_path());
        $mainDartPath = $basePath . DIRECTORY_SEPARATOR . 'musilux' . DIRECTORY_SEPARATOR 
            . 'lib' . DIRECTORY_SEPARATOR . 'main.dart';
        
        $this->assertFileExists($mainDartPath, 'lib/main.dart no existe: ' . $mainDartPath);
        
        $content = file_get_contents($mainDartPath);
        $this->assertNotFalse($content, 'No se pudo leer main.dart');
        
        // Verificar estructura mínima de Dart
        $this->assertStringContainsString('void main', $content, 'main.dart no contiene void main');
        $this->assertStringContainsString('runApp', $content, 'main.dart no contiene runApp()');
    }
}
