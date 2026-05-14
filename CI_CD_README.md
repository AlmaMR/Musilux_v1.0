# 🚀 CI/CD Automático - GitHub Actions

## ✅ Configuración Completada

Las pruebas automatizadas ahora se ejecutan automáticamente cuando subes código a GitHub. El workflow está configurado para:

### 🔄 Triggers Automáticos
- **Push** a ramas: `alma`, `adanDeveloper`, `main`, `master`
- **Pull Requests** a ramas: `alma`, `adanDeveloper`, `main`, `master`
- **Ejecución manual** desde la interfaz de GitHub

### 📋 Jobs Configurados

#### 1. **Backend Tests** (PHP/Laravel)
- ✅ Configura PHP 8.2 con todas las extensiones necesarias
- ✅ Instala dependencias de Composer con cache
- ✅ Configura entorno de testing
- ✅ Ejecuta todas las pruebas PHPUnit
- ✅ Incluye pruebas de APIs externas (YouTube, Gemini, Stripe)

#### 2. **Frontend Tests** (Flutter)
- ✅ Configura Flutter 3.11.0
- ✅ Instala dependencias con cache
- ✅ Ejecuta análisis estático (`flutter analyze`)
- ✅ Ejecuta pruebas unitarias (`flutter test`)

#### 3. **Coverage Reports** (Opcional)
- ✅ Sube reportes de cobertura a Codecov
- ✅ Solo se ejecuta si los tests pasan

## 🔐 Configuración de Secrets

Para que las pruebas de APIs funcionen completamente, necesitas configurar estos **secrets** en GitHub:

### Pasos para configurar secrets:

1. Ve a tu repositorio en GitHub
2. Haz clic en **Settings** → **Secrets and variables** → **Actions**
3. Haz clic en **New repository secret**
4. Agrega cada uno de los siguientes secrets:

### Secrets Requeridos:

| Secret Name | Descripción | Cómo obtener |
|-------------|-------------|--------------|
| `YOUTUBE_API_KEY` | API Key de Google YouTube Data API v3 | [Google Cloud Console](https://console.cloud.google.com/) |
| `GEMINI_API_KEY` | API Key de Google Generative AI | [Google AI Studio](https://ai.google.dev/) |
| `STRIPE_SECRET` | Clave secreta de Stripe (test mode) | [Stripe Dashboard](https://dashboard.stripe.com/) |
| `STRIPE_PUBLICABLE` | Clave pública de Stripe (test mode) | [Stripe Dashboard](https://dashboard.stripe.com/) |

### Cómo obtener las claves:

#### YouTube API Key:
1. Ve a [Google Cloud Console](https://console.cloud.google.com/)
2. Crea un proyecto o selecciona uno existente
3. Activa la API "YouTube Data API v3"
4. Crea credenciales → API Key
5. Copia la clave generada

#### Gemini API Key:
1. Ve a [Google AI Studio](https://ai.google.dev/tutorials/setup)
2. Haz clic en "Get API Key"
3. Selecciona tu proyecto de Google Cloud
4. Copia la clave de API

#### Stripe Keys:
1. Ve a [Stripe Dashboard](https://dashboard.stripe.com/login)
2. Ve a **Developers** → **API Keys**
3. Copia:
   - **Secret key** (comienza con `sk_test_`) → `STRIPE_SECRET`
   - **Publishable key** (comienza con `pk_test_`) → `STRIPE_PUBLICABLE`

## 📊 Ver Resultados

### Ver estado de las pruebas:
1. Ve a la pestaña **Actions** en tu repositorio
2. Cada push/PR activará automáticamente el workflow
3. Haz clic en el workflow para ver detalles
4. Los resultados se muestran en tiempo real

### Estados posibles:
- 🟢 **Success**: Todas las pruebas pasaron
- 🔴 **Failure**: Algunas pruebas fallaron
- 🟡 **In Progress**: Ejecutándose
- ⚪ **Skipped**: No se ejecutó (ej: job opcional)

## 🛠️ Troubleshooting

### "Secrets no encontrados"
Si las pruebas de APIs fallan:
1. Verifica que los nombres de los secrets sean exactos (case-sensitive)
2. Espera 1-2 minutos después de crear los secrets
3. Intenta hacer un nuevo push para activar el workflow

### "Composer/Flutter installation failed"
- El workflow tiene cache configurado para acelerar instalaciones
- Si falla, verifica que los archivos `composer.json` y `pubspec.yaml` sean válidos

### "Tests timeout"
- Las pruebas tienen timeout de 10 minutos por defecto
- Si necesitas más tiempo, puedes ajustar en el workflow

## 🎯 Próximos Pasos Recomendados

### Mejoras al CI/CD:
1. **Agregar deployment automático** cuando se merge a `main`
2. **Notificaciones** en Slack/Discord cuando fallen las pruebas
3. **Análisis estático** adicional (PHPStan, ESLint)
4. **Tests de integración** con base de datos real
5. **Performance tests** y benchmarks

### Monitoreo:
1. **Codecov** para reportes de cobertura detallados
2. **Dependabot** para actualizar dependencias automáticamente
3. **Security scanning** para vulnerabilidades

## 📝 Comandos Locales (para desarrollo)

Si quieres ejecutar las pruebas localmente antes de hacer push:

### Windows:
```bash
# Todas las pruebas
run_tests.bat all

# Solo backend
run_tests.bat backend

# Solo frontend
run_tests.bat frontend
```

### Linux/macOS:
```bash
# Todas las pruebas
./run_tests.sh all

# Solo backend
./run_tests.sh backend

# Solo frontend
./run_tests.sh frontend
```

## 🔍 Archivos de Configuración

- **Workflow principal**: `.github/workflows/ci.yml`
- **Scripts locales**: `run_tests.bat` y `run_tests.sh`
- **Documentación completa**: `PRUEBAS_AUTOMATIZADAS.md`
- **Guía de secrets**: `GITHUB_SECRETS.md`

---

🎉 **¡Tu CI/CD está listo!** Cada vez que hagas push o abras un PR, las pruebas se ejecutarán automáticamente y te dirán si todo está funcionando correctamente.