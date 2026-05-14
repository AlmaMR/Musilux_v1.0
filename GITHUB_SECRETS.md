# GitHub Actions Secrets Configuration

Este documento describe cómo configurar los secretos necesarios para ejecutar las pruebas automatizadas en GitHub Actions.

## Pasos para Configurar Secrets

1. Ve a tu repositorio en GitHub
2. Haz clic en **Settings** → **Secrets and variables** → **Actions**
3. Haz clic en **New repository secret**
4. Agrega cada uno de los siguientes secretos:

## Secretos Requeridos

### 1. YOUTUBE_API_KEY
**Descripción**: Clave de API de Google Cloud para YouTube Data API v3

**Cómo obtener**:
1. Ve a [Google Cloud Console](https://console.cloud.google.com/)
2. Crea un nuevo proyecto
3. Activa la API: "YouTube Data API v3"
4. Crea una credencial de tipo "API key"
5. Copia la clave

**Formato**: `AIza...` (comienza con AIza)

**Prueba**: La prueba valida que puedes obtener información de videos públicos

### 2. GEMINI_API_KEY
**Descripción**: Clave de API para Google Generative AI (Gemini)

**Cómo obtener**:
1. Ve a [Google AI Studio](https://ai.google.dev/tutorials/setup)
2. Haz clic en "Get API Key"
3. Selecciona o crea un proyecto de Google Cloud
4. Copia la clave de API generada

**Formato**: `AIza...` (similar a YouTube)

**Prueba**: La prueba valida que puedes hacer solicitudes de generación de contenido

### 3. STRIPE_SECRET
**Descripción**: Clave secreta de Stripe para ambiente de prueba

**Cómo obtener**:
1. Ve a [Stripe Dashboard](https://dashboard.stripe.com/login)
2. Inicia sesión con tu cuenta Stripe
3. Ve a **Developers** → **API Keys**
4. Copia la "Secret key" (comienza con `sk_test_`)

**Formato**: `sk_test_...`

**Prueba**: La prueba valida acceso a tu cuenta de Stripe y saldo

### 4. STRIPE_PUBLICABLE
**Descripción**: Clave pública de Stripe para ambiente de prueba

**Cómo obtener**:
1. En el mismo lugar que STRIPE_SECRET
2. Copia la "Publishable key" (comienza con `pk_test_`)

**Formato**: `pk_test_...`

**Prueba**: Se usa en conjunto con STRIPE_SECRET para pagos de prueba

## Verificación de Secrets

Después de agregar los secrets, puedes verificar que están configurados correctamente:

1. Ve a **Settings** → **Secrets and variables** → **Actions**
2. Deberías ver los 4 secretos listados (pero no sus valores)
3. Los valores están encriptados y no se mostrarán en los logs

## Prueba de Secrets en GitHub Actions

Los secrets se usan automáticamente en `.github/workflows/ci.yml`:

```yaml
- name: Run backend tests
  env:
    YOUTUBE_API_KEY: ${{ secrets.YOUTUBE_API_KEY }}
    GEMINI_API_KEY: ${{ secrets.GEMINI_API_KEY }}
    STRIPE_SECRET: ${{ secrets.STRIPE_SECRET }}
    STRIPE_PUBLICABLE: ${{ secrets.STRIPE_PUBLICABLE }}
  run: ./vendor/bin/phpunit --configuration phpunit.xml
```

## Ambiente de Desarrollo Local

Para ejecutar las pruebas localmente, agrega estas variables a tu `.env`:

```env
YOUTUBE_API_KEY=tu_clave_de_youtube
GEMINI_API_KEY=tu_clave_de_gemini
STRIPE_SECRET=sk_test_...
STRIPE_PUBLICABLE=pk_test_...
```

⚠️ **IMPORTANTE**: Nunca commits `.env` con claves reales. Úsalo solo para desarrollo local.

## Seguridad

- **Claves de Stripe**: Las claves de "test" son seguras para usar en pruebas, pero nunca uses claves de producción en un repositorio público
- **Claves de Google**: Las claves de API pueden tener restricciones configuradas (p.ej., solo YouTube API)
- **Rotación**: Es recomendable regenerar estas claves periódicamente
- **Auditoría**: Los logs de GitHub Actions no mostrarán los valores de los secrets

## Troubleshooting

### "Secrets no encontrado"
Si las pruebas fallan diciendo que las claves no están configuradas:
1. Verifica que los nombres de los secrets son exactos (case-sensitive)
2. Espera unos minutos después de agregar los secrets
3. Intenta con un nuevo push

### "Acceso denegado a API"
1. Verifica que las claves son correctas
2. Para YouTube y Gemini, verifica que el proyecto tiene la API activada
3. Para Stripe, verifica que usas claves de "test" (comienzan con sk_test_ o pk_test_)

### "Error de cuota"
Si ves errores de cuota en YouTube o Gemini:
1. Las APIs tienen límites de requests diarios (gratis)
2. En desarrollo local, las pruebas no deberían exceder estos límites
3. Para producción, considera planes pagos

## Referencias

- [Google Cloud Console](https://console.cloud.google.com/)
- [Google AI Studio](https://ai.google.dev/)
- [Stripe Dashboard](https://dashboard.stripe.com/)
- [GitHub Secrets Documentation](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
