#!/bin/bash

# Script para ejecutar pruebas automatizadas de Musilux
# Uso: ./run_tests.sh [backend|frontend|all]

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Colores para salida
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${BLUE}════════════════════════════════════════${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}════════════════════════════════════════${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

# Función para ejecutar pruebas del backend
run_backend_tests() {
    print_header "Ejecutando Pruebas del Backend"
    
    cd "$SCRIPT_DIR/backend_musilux"
    
    # Verificar que Composer está instalado
    if ! command -v composer &> /dev/null; then
        print_error "Composer no está instalado"
        return 1
    fi
    
    # Instalar dependencias
    print_info "Instalando dependencias de Composer..."
    composer install --prefer-dist --no-progress 2>&1 | grep -v "^$" || true
    
    # Generar clave de aplicación
    print_info "Generando clave de aplicación..."
    php artisan key:generate
    
    # Ejecutar PHPUnit
    print_info "Ejecutando pruebas con PHPUnit..."
    if ./vendor/bin/phpunit --configuration phpunit.xml --colors=always; then
        print_success "Todas las pruebas del backend pasaron"
        cd "$SCRIPT_DIR"
        return 0
    else
        print_error "Algunas pruebas del backend fallaron"
        cd "$SCRIPT_DIR"
        return 1
    fi
}

# Función para ejecutar pruebas del frontend
run_frontend_tests() {
    print_header "Ejecutando Pruebas del Frontend"
    
    cd "$SCRIPT_DIR/musilux"
    
    # Verificar que Flutter está instalado
    if ! command -v flutter &> /dev/null; then
        print_error "Flutter no está instalado"
        return 1
    fi
    
    # Obtener dependencias
    print_info "Instalando dependencias de Flutter..."
    flutter pub get
    
    # Ejecutar pruebas
    print_info "Ejecutando pruebas de Flutter..."
    if flutter test; then
        print_success "Todas las pruebas del frontend pasaron"
        cd "$SCRIPT_DIR"
        return 0
    else
        print_error "Algunas pruebas del frontend fallaron"
        cd "$SCRIPT_DIR"
        return 1
    fi
}

# Función para inicializar servidores de desarrollo
run_dev_servers() {
    print_header "Iniciando Servidores de Desarrollo"
    
    print_info "Backend: php -S 0.0.0.0:8080 -t public"
    print_info "Frontend: flutter run"
    
    # Terminal 1: Backend
    cd "$SCRIPT_DIR/backend_musilux"
    print_info "Iniciando servidor PHP en puerto 8080..."
    php -S 0.0.0.0:8080 -t public &
    BACKEND_PID=$!
    
    sleep 2
    
    if curl -s http://localhost:8080/ > /dev/null; then
        print_success "Backend iniciado en http://localhost:8080"
    else
        print_error "No se pudo iniciar el backend"
        kill $BACKEND_PID 2>/dev/null || true
        return 1
    fi
    
    # Terminal 2: Frontend (comentado - requiere interacción)
    # cd "$SCRIPT_DIR/musilux"
    # print_info "Iniciando Flutter..."
    # flutter run &
    # FRONTEND_PID=$!
    
    print_info "Backend ejecutándose (PID: $BACKEND_PID)"
    print_info "Presiona Ctrl+C para detener"
    
    wait $BACKEND_PID
}

# Función para limpiar archivos temporales
cleanup() {
    print_header "Limpiando Archivos Temporales"
    
    cd "$SCRIPT_DIR/backend_musilux"
    
    # Limpiar cache de Laravel
    php artisan cache:clear 2>/dev/null || true
    php artisan view:clear 2>/dev/null || true
    php artisan config:clear 2>/dev/null || true
    
    print_success "Limpieza completada"
}

# Main
main() {
    local command=${1:-all}
    
    case $command in
        backend)
            run_backend_tests
            ;;
        frontend)
            run_frontend_tests
            ;;
        all)
            run_backend_tests || true
            run_frontend_tests || true
            ;;
        dev)
            run_dev_servers
            ;;
        clean)
            cleanup
            ;;
        *)
            echo "Uso: $0 [backend|frontend|all|dev|clean]"
            echo ""
            echo "Comandos:"
            echo "  backend   - Ejecutar pruebas del backend"
            echo "  frontend  - Ejecutar pruebas del frontend"
            echo "  all       - Ejecutar todas las pruebas (default)"
            echo "  dev       - Iniciar servidores de desarrollo"
            echo "  clean     - Limpiar archivos temporales"
            exit 1
            ;;
    esac
}

main "$@"
