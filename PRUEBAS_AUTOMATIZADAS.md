# Pruebas Automatizadas de Musilux

## Descripción General

Este proyecto contiene pruebas automatizadas para verificar la inicialización correcta del backend (Laravel) y frontend (Flutter), así como la conectividad con APIs externas (YouTube, Gemini, Stripe).

## Estructura de Pruebas

### Backend Tests (PHPUnit)

Las pruebas del backend se encuentran en `backend_musilux/tests/Feature/`:

#### 1. **BackendServerTest.php**
- **Propósito**: Verifica que el servidor PHP integrado puede iniciarse correctamente
- **Comando**: `php -S 0.0.0.0:8080 -t public`
- **Validación**: Confirma que el servidor responde en http://127.0.0.1:8080/

#### 2. **ExternalServicesIntegrationTest.php**
- **YouTube API**: Verifica conectividad y autenticación con Google's YouTube Data API v3
  - Valida: Obtención de metadatos de videos
  - Configurable en: `.env` → `YOUTUBE_API_KEY`

- **Gemini API**: Verifica conectividad con Google's Generative AI API
  - Valida: Generación de texto y respuestas coherentes
  - Configurable en: `.env` → `GEMINI_API_KEY`

- **Stripe API**: Verifica conectividad con Stripe Payment API
  - Valida: Autenticación y acceso a saldo de cuenta
  - Configurable en: `.env` → `STRIPE_SECRET`, `STRIPE_PUBLICABLE`

#### 3. **FrontendInitializationTest.php**
- **Propósito**: Verifica la estructura del proyecto Flutter
- **Validaciones**:
  - Existe carpeta `musilux/`
  - Contiene `pubspec.yaml` válido
  - Contiene `lib/main.dart` con estructura correcta
  - Estructura de plataformas (Android, iOS, Web)

### Frontend Tests (Flutter)

Las pruebas de Flutter se ejecutan en `musilux/` con:
```bash
flutter test
```

## Ejecutar Pruebas Localmente

### Requisitos Previos

**Backend:**
- PHP 8.2+
- Composer
- Claves API configuradas en `.env`

**Frontend:**
- Flutter SDK 3.11.0+
- Dart SDK (incluido con Flutter)

### Variables de Entorno Requeridas

Crear o actualizar `backend_musilux/.env` con:

```env
# Base de datos de prueba (automático en phpunit.xml)
DB_CONNECTION=sqlite
DB_DATABASE=:memory:

# APIs Externas
YOUTUBE_API_KEY=tu_clave_de_youtube
GEMINI_API_KEY=tu_clave_de_gemini
STRIPE_SECRET=sk_test_xxxxxxxx
STRIPE_PUBLICABLE=pk_test_xxxxxxxx
```

### Ejecutar Backend Tests

```bash
# Desde backend_musilux/
composer install
php artisan key:generate

# Ejecutar todas las pruebas
./vendor/bin/phpunit

# Ejecutar pruebas específicas
./vendor/bin/phpunit --filter BackendServerTest
./vendor/bin/phpunit --filter ExternalServicesIntegrationTest
./vendor/bin/phpunit --filter FrontendInitializationTest

# Con salida detallada
./vendor/bin/phpunit --verbose
```

### Ejecutar Frontend Tests

```bash
# Desde musilux/
flutter pub get

# Ejecutar todas las pruebas
flutter test

# Ejecutar pruebas específicas
flutter test test/widget_test.dart
```

### Inicializar Servidor Backend Manualmente

```bash
cd backend_musilux
php -S 0.0.0.0:8080 -t public
```

El servidor estará disponible en `http://localhost:8080`

### Inicializar Frontend Manualmente

```bash
cd musilux
flutter run
```

## CI/CD Pipeline

El archivo `.github/workflows/ci.yml` automatiza las pruebas en cada push o pull request:

1. **Job Backend**: 
   - Configura PHP 8.2
   - Instala dependencias de Composer
   - Ejecuta pruebas con PHPUnit
   - Pruebas de APIs externas (requiere GitHub Secrets)

2. **Job Flutter**:
   - Configura Flutter 3.11.0
   - Instala dependencias con `flutter pub get`
   - Ejecuta pruebas con `flutter test`

### Configurar Secrets en GitHub

Para que las pruebas de APIs funcionen en CI, agregar estos secretos al repositorio:

```
YOUTUBE_API_KEY
GEMINI_API_KEY
STRIPE_SECRET
STRIPE_PUBLICABLE
```

Ir a: **Settings → Secrets and variables → Actions**

## Pruebas de Cobertura

Para generar reporte de cobertura en backend:

```bash
cd backend_musilux
./vendor/bin/phpunit --coverage-html coverage --configuration phpunit.xml
```

Se generará un reporte HTML en `backend_musilux/coverage/`

## Troubleshooting

### Backend Tests

**Error: "YOUTUBE_API_KEY no está configurada"**
- Solución: Agregar `YOUTUBE_API_KEY` a `.env`

**Error: "No se pudo conectar con Stripe"**
- Solución: Verificar que `STRIPE_SECRET` es una clave de test válida

**Error: Puerto 8080 en uso**
- Solución: Cambiar puerto en el test o terminar el proceso usando ese puerto

### Frontend Tests

**Error: "Flutter not found"**
- Solución: Instalar Flutter SDK desde https://flutter.dev

**Error: "pubspec.yaml not found"**
- Solución: Ejecutar desde la carpeta `musilux/`

## Referencias

- [Laravel Testing](https://laravel.com/docs/testing)
- [PHPUnit](https://phpunit.de/)
- [Flutter Testing](https://flutter.dev/docs/testing)
- [YouTube Data API](https://developers.google.com/youtube/v3)
- [Google Generative AI](https://ai.google.dev/)
- [Stripe API](https://stripe.com/docs/api)
