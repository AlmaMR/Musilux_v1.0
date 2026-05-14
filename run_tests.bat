@echo off
REM Script para ejecutar pruebas automatizadas de Musilux (Windows)
REM Uso: run_tests.bat [backend|frontend|all|dev|clean]

setlocal enabledelayedexpansion

set "SCRIPT_DIR=%~dp0"
set "BACKEND_DIR=%SCRIPT_DIR%backend_musilux"
set "FRONTEND_DIR=%SCRIPT_DIR%musilux"

REM Colores (códigos ANSI)
set "GREEN=[32m"
set "RED=[31m"
set "YELLOW=[33m"
set "BLUE=[34m"
set "RESET=[0m"

:main
set "command=%1"
if "%command%"=="" set "command=all"

if "%command%"=="backend" (
    call :run_backend_tests
) else if "%command%"=="frontend" (
    call :run_frontend_tests
) else if "%command%"=="all" (
    call :run_backend_tests
    call :run_frontend_tests
) else if "%command%"=="dev" (
    call :run_dev_servers
) else if "%command%"=="clean" (
    call :cleanup
) else (
    echo Uso: %0 [backend^|frontend^|all^|dev^|clean]
    echo.
    echo Comandos:
    echo   backend   - Ejecutar pruebas del backend
    echo   frontend  - Ejecutar pruebas del frontend
    echo   all       - Ejecutar todas las pruebas (default^)
    echo   dev       - Iniciar servidores de desarrollo
    echo   clean     - Limpiar archivos temporales
    exit /b 1
)
exit /b 0

:run_backend_tests
echo.
echo ════════════════════════════════════════
echo   Ejecutando Pruebas del Backend
echo ════════════════════════════════════════
echo.

cd /d "%BACKEND_DIR%"

REM Verificar que Composer está instalado
where composer >nul 2>nul
if errorlevel 1 (
    echo [31m✗ Composer no está instalado[0m
    exit /b 1
)

REM Instalar dependencias
echo [33mℹ Instalando dependencias de Composer...[0m
call composer install --prefer-dist --no-progress >nul 2>&1

REM Generar clave de aplicación
echo [33mℹ Generando clave de aplicación...[0m
php artisan key:generate

REM Ejecutar PHPUnit
echo [33mℹ Ejecutando pruebas con PHPUnit...[0m
call .\vendor\bin\phpunit.bat --configuration phpunit.xml --colors=always

if errorlevel 1 (
    echo [31m✗ Algunas pruebas del backend fallaron[0m
    cd /d "%SCRIPT_DIR%"
    exit /b 1
) else (
    echo [32m✓ Todas las pruebas del backend pasaron[0m
    cd /d "%SCRIPT_DIR%"
    exit /b 0
)

:run_frontend_tests
echo.
echo ════════════════════════════════════════
echo   Ejecutando Pruebas del Frontend
echo ════════════════════════════════════════
echo.

cd /d "%FRONTEND_DIR%"

REM Verificar que Flutter está instalado
where flutter >nul 2>nul
if errorlevel 1 (
    echo [31m✗ Flutter no está instalado[0m
    exit /b 1
)

REM Obtener dependencias
echo [33mℹ Instalando dependencias de Flutter...[0m
call flutter pub get

REM Ejecutar pruebas
echo [33mℹ Ejecutando pruebas de Flutter...[0m
call flutter test

if errorlevel 1 (
    echo [31m✗ Algunas pruebas del frontend fallaron[0m
    cd /d "%SCRIPT_DIR%"
    exit /b 1
) else (
    echo [32m✓ Todas las pruebas del frontend pasaron[0m
    cd /d "%SCRIPT_DIR%"
    exit /b 0
)

:run_dev_servers
echo.
echo ════════════════════════════════════════
echo   Iniciando Servidores de Desarrollo
echo ════════════════════════════════════════
echo.

echo [33mℹ Backend: php -S 0.0.0.0:8080 -t public[0m
echo [33mℹ Frontend: flutter run[0m
echo.

cd /d "%BACKEND_DIR%"
echo [33mℹ Iniciando servidor PHP en puerto 8080...[0m
start cmd /k "php -S 0.0.0.0:8080 -t public"

timeout /t 3 /nobreak

echo [32m✓ Backend iniciado en http://localhost:8080[0m
echo [33mℹ Presiona Ctrl+C en la ventana del servidor para detener[0m
exit /b 0

:cleanup
echo.
echo ════════════════════════════════════════
echo   Limpiando Archivos Temporales
echo ════════════════════════════════════════
echo.

cd /d "%BACKEND_DIR%"

REM Limpiar cache de Laravel
php artisan cache:clear >nul 2>&1
php artisan view:clear >nul 2>&1
php artisan config:clear >nul 2>&1

echo [32m✓ Limpieza completada[0m
exit /b 0

endlocal
