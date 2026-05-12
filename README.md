# Musilux v1.0

Plataforma de comercio electrónico especializada en instrumentos musicales, vinilos y equipo de iluminación para escenarios. Desarrollada como aplicación móvil/web multiplataforma con Flutter y un API REST backend en Laravel.

---

## Colaboradores

| Nombre | GitHub |
|--------|--------|
| Jorge Adan Soria | [@AdanSoria](https://github.com/AdanSoria) |
| Alma Angelina Mercado | — |
| Brian Eduardo Licea | — |

---

## Tabla de contenidos

1. [Descripción general](#descripción-general)
2. [Stack tecnológico](#stack-tecnológico)
3. [Arquitectura del sistema](#arquitectura-del-sistema)
4. [Módulos Flutter (Frontend)](#módulos-flutter-frontend)
5. [Módulos Laravel (Backend API)](#módulos-laravel-backend-api)
6. [Base de datos](#base-de-datos)
7. [Integraciones externas](#integraciones-externas)
8. [Control de acceso por roles (RBAC)](#control-de-acceso-por-roles-rbac)
9. [Instalación y configuración](#instalación-y-configuración)
10. [Variables de entorno](#variables-de-entorno)
11. [Endpoints principales de la API](#endpoints-principales-de-la-api)

---

## Descripción general

Musilux es una tienda en línea orientada al mundo musical. Permite a los usuarios explorar un catálogo de productos (instrumentos, vinilos y equipo de iluminación), agregar artículos al carrito, realizar pagos con Stripe y consultar su historial de compras. Incluye un chatbot de inteligencia artificial (Google Gemini) para soporte al cliente, búsqueda de música a través de la API de Spotify y un panel de administración segmentado por áreas (pedidos, usuarios, inventario, ventas y soporte).

---

## Stack tecnológico

### Frontend
| Tecnología | Versión | Propósito |
|------------|---------|-----------|
| Flutter | ^3.11.0 | Framework UI multiplataforma |
| Dart | — | Lenguaje principal |
| Provider | — | Gestión de estado |
| flutter_stripe | — | Pagos con Stripe |
| audioplayers | — | Reproducción de audio |
| firebase_core / firebase_storage | — | Almacenamiento de archivos |
| image_picker | — | Selección de imágenes |
| cached_network_image | — | Caché de imágenes remotas |
| http | — | Comunicación con la API |
| pdf / printing | — | Generación de facturas PDF |
| shared_preferences | — | Persistencia local |

### Backend
| Tecnología | Versión | Propósito |
|------------|---------|-----------|
| Laravel | ^12.0 | Framework PHP |
| Laravel Sanctum | ^4.0 | Autenticación por tokens |
| Stripe PHP SDK | ^20.0 | Procesamiento de pagos |
| Google Gemini API | — | Chatbot de IA |
| Spotify Web API | — | Búsqueda de música (proxy) |
| Firebase Storage | — | Almacenamiento de archivos |
| MySQL / MariaDB | — | Base de datos principal |

---

## Arquitectura del sistema

```
┌─────────────────────────────────────────────────────┐
│                 Cliente Flutter                      │
│  iOS · Android · Web · macOS · Windows · Linux      │
│                                                     │
│  AuthProvider ─── CartProvider ─── ChatProvider     │
│         │               │               │           │
│      Services        Screens         Widgets        │
└───────────────────────┬─────────────────────────────┘
                        │ HTTP / JSON (Sanctum tokens)
                        ▼
┌─────────────────────────────────────────────────────┐
│              Laravel API (REST)                     │
│                                                     │
│  Routes → Controllers → Models → MySQL              │
│                │                                   │
│         Services (Gemini, Spotify, Stripe)          │
└─────────────────────────────────────────────────────┘
                        │
          ┌─────────────┼─────────────┐
          ▼             ▼             ▼
       Stripe        Gemini AI    Spotify API
    (Pagos)       (Chatbot)    (Búsqueda músical)
```

El frontend Flutter se comunica exclusivamente a través de la API REST. La autenticación usa tokens Bearer de Laravel Sanctum. El backend actúa como proxy para las APIs externas (Spotify, Gemini) para proteger las claves de acceso.

---

## Módulos Flutter (Frontend)

### Enrutamiento — `lib/core/app_router.dart`

Define todas las rutas de la app y aplica control de acceso basado en roles antes de permitir la navegación.

| Ruta | Pantalla | Acceso |
|------|----------|--------|
| `/` | Catálogo público | Todos |
| `/login` | Inicio de sesión | Todos |
| `/chat` | Chatbot IA | Autenticados |
| `/carrito` | Carrito de compras | Clientes |
| `/checkout` | Pago con Stripe | Clientes |
| `/mis-compras` | Historial de pedidos | Clientes |
| `/perfil` | Perfil de usuario | Autenticados |
| `/soporte` | Contacto / soporte | Todos |
| `/super-admin` | Dashboard superadmin | superadmin |
| `/admin/pedidos` | Gestión de pedidos | admin_pedidos |
| `/admin/usuarios` | Gestión de usuarios | admin_usuarios |
| `/admin/inventario` | Gestión de inventario | admin_inventario |
| `/admin/ventas` | Reportes de ventas | admin_ventas |
| `/admin/soporte` | Gestión de tickets | admin_soporte |

### Providers (Estado global)

| Provider | Responsabilidad |
|----------|-----------------|
| `AuthProvider` | Sesión del usuario, token, rol y permisos |
| `CartProvider` | Carrito con cálculo de IVA (16%), validación de stock y precios |
| `ChatProvider` | Historial de conversación con el chatbot de IA |

### Servicios — `lib/services/`

| Servicio | Descripción |
|----------|-------------|
| `auth_service.dart` | Login, registro, logout, gestión de tokens |
| `api_service.dart` | Productos, categorías, búsqueda y paginación |
| `payment_service.dart` | Creación de sesiones de pago con Stripe |
| `chat_service.dart` | Comunicación con el endpoint del chatbot |
| `spotify_service.dart` | Búsqueda de canciones y artistas vía proxy del backend |
| `firebase_storage_service.dart` | Subida y descarga de archivos en Firebase |

### Pantallas

#### Pantallas públicas
- **`home_screen.dart`** — Catálogo de productos con listados por categoría.
- **`login_screen.dart`** — Formulario de autenticación con redirección según rol.
- **`search_screen.dart`** — Búsqueda de productos con filtros por categoría y precio.
- **`product_detail_screen.dart`** — Detalle de producto con galería de imágenes, especificaciones, reproductor de audio y productos relacionados.
- **`contact_screen.dart`** — Formulario de soporte al cliente.

#### Pantallas de cliente
- **`instruments_screen.dart`** — Vista de categoría: instrumentos musicales.
- **`lighting_screen.dart`** — Vista de categoría: equipo de iluminación.
- **`vinyls_screen.dart`** — Vista de categoría: vinilos y discos.
- **`profile_screen.dart`** — Perfil del usuario con datos personales y dirección.
- **`profile_edit.dart`** — Edición de perfil y cambio de contraseña.
- **`mis_compras_screen.dart`** — Historial de pedidos del usuario.
- **`pedido_detail_screen.dart`** — Detalle de un pedido con estado, artículos y guía de envío.
- **`chat_screen.dart`** — Interfaz de conversación con el chatbot de IA.
- **`checkout_success_screen.dart`** — Confirmación de pago exitoso.
- **`checkout_cancel_screen.dart`** — Manejo de cancelación de pago.

#### Paneles de administración — `lib/screens/admin/`
- **`super_admin_dashboard.dart`** — Vista global del sistema para superadmin.
- **`pedidos_dashboard.dart`** — Gestión y actualización de estado de pedidos.
- **`usuarios_dashboard.dart`** — Administración de usuarios y suspensión de cuentas.
- **`inventario_dashboard.dart`** — CRUD de productos e inventario.
- **`ventas_dashboard.dart`** — Métricas y reportes de ventas.
- **`soporte_dashboard.dart`** — Gestión de tickets y respuestas de soporte.

---

## Módulos Laravel (Backend API)

### Controladores

#### Autenticación y usuarios
- **`AuthController`** — Registro, login, logout, listado de roles.
- **`UsuarioController`** — Perfil, cambio de contraseña, actualización de dirección.

#### Catálogo de productos
- **`ProductController`** — CRUD completo, filtrado por categoría, búsqueda con paginación, productos relacionados (por categoría, etiquetas y proximidad de precio).

#### Administración
| Controlador | Función |
|-------------|---------|
| `Admin\AdminPedidoController` | Listar, ver y cambiar estado de pedidos |
| `Admin\AdminUsuarioController` | Listar, ver y suspender usuarios |
| `Admin\ReporteController` | Métricas y reportes de ventas |
| `Admin\CuponController` | CRUD de cupones de descuento |
| `Admin\TicketController` | Gestión de tickets de soporte |
| `Admin\RolAdminController` | Gestión de roles y permisos |

#### Funcionalidades adicionales
- **`ChatController`** — Integración con Google Gemini para el chatbot. Persiste el historial de conversaciones por usuario.
- **`SpotifyController`** — Proxy seguro para la API de Spotify: búsqueda de canciones y artistas.
- **`PaymentController`** — Crea sesiones de pago con Stripe y procesa webhooks de confirmación.

### Middleware
- **`VerificarPermiso`** — Middleware personalizado que valida que el usuario autenticado tenga el permiso requerido antes de ejecutar cualquier acción de administración.

---

## Base de datos

El esquema está compuesto por 19 migraciones. A continuación se describen las tablas más relevantes.

```
roles            usuarios           permisos
   └── usuarios      └── pedidos        └── rol_permiso
                     └── chats_ia            └── roles
                     └── tickets

productos ──┬── categorias
            ├── multimedia_producto
            ├── imagenes_producto
            ├── especificaciones_producto
            └── etiquetas (producto_etiqueta)

pedidos ──── items_pedido ──── productos
        └── cupones

chats_ia ──── mensajes_chats_ia
tickets
personal_access_tokens
```

### Tablas clave

| Tabla | Clave primaria | Descripción |
|-------|---------------|-------------|
| `usuarios` | UUID | Usuarios con FK a rol, timestamps personalizados |
| `roles` | INT | Definición de roles del sistema |
| `permisos` | INT | Permisos granulares por acción |
| `rol_permiso` | — | Tabla pivote rol ↔ permiso |
| `productos` | UUID | Catálogo de productos con metadatos de Spotify |
| `categorias` | INT | Categorías de productos |
| `etiquetas` | INT | Etiquetas de productos |
| `pedidos` | UUID | Órdenes de compra con estado, subtotal, descuento y total |
| `items_pedido` | INT | Líneas de artículos dentro de un pedido |
| `cupones` | INT | Cupones de descuento |
| `chats_ia` | UUID | Sesiones del chatbot de IA |
| `mensajes_chats_ia` | UUID | Mensajes individuales del chatbot |
| `tickets` | INT | Tickets de soporte al cliente |

---

## Integraciones externas

### Stripe
Procesa los pagos de la tienda. El backend crea una sesión de pago (`/api/payment/checkout`) y recibe la confirmación mediante webhooks (`/api/payment/webhook`). El frontend Flutter redirige al usuario a la URL de Stripe y gestiona las pantallas de éxito/cancelación.

### Google Gemini AI
El chatbot de soporte al cliente usa la API de Gemini a través de `GeminiService`. Las conversaciones se almacenan en la base de datos (`chats_ia`, `mensajes_chats_ia`) para mantener contexto entre sesiones.

### Spotify Web API
La búsqueda de música se canaliza a través del backend (`SpotifyController` → `SpotifyService`) para proteger las credenciales. Los productos tipo vinilo pueden asociar metadatos de Spotify (BPM, ID de pista). El widget `spotify_search_widget.dart` en Flutter permite buscar canciones desde el panel de inventario.

### Firebase Storage
Se usa para almacenar imágenes y archivos multimedia de productos. `firebase_storage_service.dart` gestiona la subida y descarga desde el cliente Flutter.

---

## Control de acceso por roles (RBAC)

### Roles disponibles

| Rol | Descripción |
|-----|-------------|
| `superadmin` | Acceso total al sistema |
| `admin_pedidos` | Gestión de pedidos y envíos |
| `admin_usuarios` | Gestión y suspensión de usuarios |
| `admin_inventario` | CRUD de productos e inventario |
| `admin_ventas` | Reportes y métricas de ventas |
| `admin_soporte` | Gestión de tickets de soporte |
| `cliente` | Compras, historial y perfil |

### Flujo de autorización
1. El usuario inicia sesión → el backend devuelve un token Sanctum + datos de rol.
2. Flutter guarda la sesión en `AuthProvider`.
3. `app_router.dart` verifica el rol antes de permitir la navegación a rutas protegidas.
4. `RolGuard` widget oculta/muestra elementos de UI según el rol.
5. En el backend, el middleware `VerificarPermiso` valida el permiso requerido en cada endpoint de administración.

---

## Instalación y configuración

### Requisitos previos
- Flutter SDK >= 3.11.0
- PHP >= 8.2
- Composer
- MySQL / MariaDB
- Node.js (opcional, para scripts de assets)

### Backend (Laravel)

```bash
cd backend_musilux

# Instalar dependencias
composer install

# Configurar entorno
cp .env.example .env
php artisan key:generate

# Ejecutar migraciones y seeders
php artisan migrate --seed

# Iniciar servidor de desarrollo
php artisan serve --host=0.0.0.0 --port=8080
```

### Frontend (Flutter)

```bash
cd musilux

# Instalar dependencias
flutter pub get

# Configurar la IP del backend en lib/api_constants.dart
# (por defecto: 10.11.5.71:8080)

# Ejecutar en emulador/dispositivo
flutter run

# Compilar APK de Android
flutter build apk
```

---

## Variables de entorno

El archivo `backend_musilux/.env` debe contener las siguientes variables:

```env
APP_NAME=Musilux
APP_URL=http://localhost:8080

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=musilux
DB_USERNAME=root
DB_PASSWORD=

# Laravel Sanctum
SANCTUM_STATEFUL_DOMAINS=localhost

# Stripe
STRIPE_KEY=pk_test_...
STRIPE_SECRET=sk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...

# Google Gemini
GEMINI_API_KEY=...

# Spotify
SPOTIFY_CLIENT_ID=...
SPOTIFY_CLIENT_SECRET=...

# Firebase (si aplica)
FIREBASE_PROJECT_ID=musilux
```

---

## Endpoints principales de la API

Todos los endpoints están bajo el prefijo `/api`.

### Autenticación

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| POST | `/auth/register` | Registro de nuevo usuario |
| POST | `/auth/login` | Inicio de sesión (devuelve token) |
| POST | `/auth/logout` | Cierre de sesión (requiere token) |
| GET | `/auth/me` | Datos del usuario autenticado |

### Productos

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/products` | Listado con filtros y paginación |
| GET | `/products/{id}` | Detalle de un producto |
| GET | `/products?category=` | Filtrar por categoría |
| GET | `/products?search=` | Búsqueda por texto |

### Pedidos y pagos

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/mis-pedidos` | Pedidos del usuario autenticado |
| GET | `/mis-pedidos/{id}` | Detalle de un pedido |
| POST | `/payment/checkout` | Crear sesión de pago Stripe |
| POST | `/payment/webhook` | Webhook de confirmación Stripe |

### Chatbot IA

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| POST | `/chat` | Enviar mensaje al chatbot |
| GET | `/chat/history` | Historial de conversación |

### Spotify

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/spotify/search?q=` | Buscar canciones/artistas |

### Administración (requieren token + permiso)

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/admin/pedidos` | Listar todos los pedidos |
| PATCH | `/admin/pedidos/{id}/status` | Actualizar estado de pedido |
| GET | `/admin/usuarios` | Listar todos los usuarios |
| PATCH | `/admin/usuarios/{id}/suspend` | Suspender usuario |
| GET | `/admin/reportes` | Métricas de ventas |
| GET/POST/PUT/DELETE | `/admin/cupones` | CRUD de cupones |
| GET/POST/PUT/DELETE | `/admin/tickets` | CRUD de tickets de soporte |
| GET/POST/PUT/DELETE | `/admin/roles` | Gestión de roles y permisos |
| GET/POST/PUT/DELETE | `/admin/productos` | CRUD de inventario |

---

## Estructura de directorios

```
Musilux_v1.0/
├── musilux/                        # Aplicación Flutter
│   ├── lib/
│   │   ├── main.dart               # Punto de entrada
│   │   ├── api_constants.dart      # URL base de la API
│   │   ├── core/
│   │   │   └── app_router.dart     # Rutas y control de acceso
│   │   ├── providers/              # Estado global
│   │   ├── services/               # Comunicación con API/servicios
│   │   ├── models/                 # Modelos de datos
│   │   ├── screens/                # Pantallas (22)
│   │   │   └── admin/              # Paneles de administración
│   │   ├── widgets/                # Componentes reutilizables
│   │   ├── theme/                  # Paleta de colores
│   │   └── utils/                  # Utilidades multiplataforma
│   └── pubspec.yaml
│
└── backend_musilux/                # API Laravel
    ├── app/
    │   ├── Http/Controllers/       # Controladores
    │   │   └── Admin/              # Controladores de administración
    │   ├── Models/                 # Modelos Eloquent
    │   ├── Http/Middleware/        # Middleware de permisos
    │   └── services/               # Servicios externos
    ├── database/
    │   ├── migrations/             # 19 migraciones
    │   └── seeders/                # Datos iniciales
    ├── routes/
    │   └── api.php                 # Definición de endpoints
    └── composer.json
```

---

## Diagrama de base de datos

El archivo `ModeloBD.jpeg` en la raíz del repositorio contiene el diagrama entidad-relación completo del esquema de base de datos.

---

*Musilux v1.0 — Taller Full Stack · 2026*
