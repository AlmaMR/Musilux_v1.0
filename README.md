# Content for README.md
Musilux es una plataforma móvil desarrollada en Flutter diseñada para revolucionar la comercialización de instrumentos musicales, equipos de iluminación y vinilos. Combina la experiencia de una tienda física con herramientas digitales avanzadas como preescucha de audio y asistencia mediante IA.

## 🚀 Características Principales

* **Catálogo Dinámico:** Visualización técnica de equipos y curaduría de vinilos.
* **Integración con Youtube:** Preescucha de álbumes y tracks de demostración directamente en la App.
* **Pagos Seguros con Stripe:** Procesamiento de pagos robusto para la compra de instrumentos y accesorios.
* **Asistente Chatbot:** Soporte técnico y recomendaciones personalizadas mediante IA.
* **Experiencia Híbrida:** Enfoque en fidelidad sonora y especificaciones para profesionales.

---

## 🛠️ Requisitos Previos

Antes de comenzar, asegúrate de tener instalado lo siguiente:

* [Flutter SDK](https://docs.flutter.dev/get-started/install) (Versión estable más reciente).
* [Dart SDK](https://dart.dev/get-started/sdk).
* Un IDE compatible (VS Code, Android Studio o IntelliJ).
* CocoaPods (solo para usuarios de macOS/iOS).
* Cuentas de desarrollador en:
    * Para los pagos:
        * [Stripe Dashboard](https://dashboard.stripe.com/) (para llaves de API).
    * Para los demos de música:
        * [Youtube Developer Dashboard](https://console.cloud.google.com/apis/api/youtube.googleapis.com/credentials?project=musilux) (para Client ID y Secret).
    * Para el Chatbot cualquiera de las siguientes opciones:
        * [OpenAI](https://platform.openai.com/) (Pago minimo de $5 USD por una cantidad de tokens).
        * [Gemini API](https://ai.google.dev/gemini-api/docs/api-key?hl=es-419) (Pago por petición).

---

## ⚙️ Configuración del Proyecto

### 1. Clonar el Repositorio
```bash
git clone https://github.com/AlmaMR/Musilux_v1.0.git
cd Musilux_v1.0
```

### 2. Instalar dependencias
#### 2.2 Dart
Abrir una terminal en el proyecto y acceder al backend
```bash
cd backend
composer install
php artisan key:generate
php artisan migrate
php artisan migrate:fresh
php artisan migrate:fresh --seed
```
#### 2.2 Dart
Abrir una nueva terminal en el proyecto y acceder al frontend
```bash
cd musilux
flutter pub get
```

### 3. Configuración de Variables de Entorno
Crea un archivo .env en la raíz del backend del proyecto (basado en .env.example) y añade tus llaves:
```bash
APP_KEY= llave generada por "php artisan key:generate"

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306 o el puerto que tu uses para mysql
DB_DATABASE=musilux_db o el nombre que tu quieras
DB_USERNAME=root
DB_PASSWORD= tu contraseña de MySQL o dejalo vacio si no tienes

YOUTUBE_API_KEY= llave que optienes de tu cuenta de desarrollador

OPENAI_API_KEY= llave que optienes de tu cuenta de desarrollador
GEMINI_API_KEY= llave que optienes de tu cuenta de desarrollador

STRIPE_SECRET= llave que optienes de tu cuenta de desarrollador
STRIPE_PUBLICABLE= llave que optienes de tu cuenta de desarrollador
```

### 4. Ejecutar en emulador o dispositivo
#### 4.1. Backend
Pega en la consola del backend uno de los siguientes comandos:
```bash
php -S 0.0.0.0:8080 -t public
```
```bash
php artisan serve
```
#### 4.2. Frontend
Pega en la consola del frontend el siguiente comando:
```bash
flutter run
```
---

## 🛠️ Especificaciones Técnicas e Integraciones

### Arquitectura
El sistema utiliza una **Arquitectura de Capas** para separar la interfaz de usuario de la lógica de negocio y el consumo de datos, facilitando el mantenimiento.

### Integraciones de APIs
*   **Youtube API:** Curaduría de vinilos con preescucha de fragmentos y metadatos de álbumes.
*   **Stripe API:** Pasarela de pago segura para la compra de equipo técnico.
*   **Chatbot AI:** Asistente inteligente para dudas técnicas sobre vataje y alcance de iluminación.
*   **JWT (JSON Web Tokens):** Seguridad para el manejo de sesiones entre Flutter y Laravel.

### 🏗️ Estructura de Directorios (Frontend)
La lógica de Musilux se organiza de manera modular dentro de la carpeta `lib/` para facilitar el mantenimiento y la escalabilidad del sistema:
*   `lib/core`: Contiene la configuración central de la navegación con `app_router.dart`.
*   `lib/features`: Módulos específicos por funcionalidad. Actualmente incluye el subdirectorio `catalog/data` donde se gestionan los servicios y modelos exclusivos del catálogo de productos.
*   `lib/models`: Define las estructuras de datos fundamentales de la app, como `product.dart`, `cart_item.dart`, `chat_message.dart`, y la gestión de roles y sesiones de usuario (`rol_model.dart`, `usuario_sesion.dart`).
*   `lib/providers`: Implementa la lógica de estado global mediante ChangeNotifier. Aquí se controla la autenticación (`auth_provider.dart`), el carrito de compras (`cart_provider.dart`) y la mensajería en tiempo real (`chat_provider.dart`).
*   `lib/screens`: Aloja las vistas principales, incluyendo un módulo de administración (`admin/`) y pantallas específicas como el chat y la gestión de inventario para administradores.
*   `lib/services`: Es el motor de comunicación externa. Contiene la lógica para consumir la API de Laravel (`api_service.dart`), gestionar pagos (`payment_service.dart`), interactuar con Youtube (`youtube_service.dart`) y administrar archivos en la nube con Firebase Storage.
*   `lib/theme`: Centraliza la identidad visual de la aplicación, definiendo la paleta de colores en `colors.dart`.
*   `lib/utils`: Conjunto de herramientas de soporte técnico, especialmente enfocadas en la compatibilidad web (`browser_utils.dart`) y manejadores de mensajes para el navegador.
*   `lib/widgets`: Componentes visuales reutilizables y lógica de protección de interfaz, como `rol_guard.dart` para restringir accesos y el buscador integrado de Youtube.

#### 📂 Archivos Base en lib/
*   `api_constants.dart`: Almacena las URLs base y constantes para las peticiones HTTP.
*   `firebase_options.dart`: Configuración técnica para la vinculación con servicios de Google Firebase.
*   `main.dart`: El punto de partida que arranca la aplicación y configura los servicios iniciales.

### 🗄️ Estructura de Directorios (Backend - Laravel)
El servidor de Musilux está construido sobre Laravel, siguiendo el patrón **MVC** (**Modelo-Vista-Controlador**) y una arquitectura orientada a servicios para alimentar la API móvil:
*   `app/Http/Controllers`: Contiene la lógica de control. Aquí se reciben las peticiones de la app móvil (ej. `ProductController`, `OrderController`) y se coordina la respuesta.  
*   `app/Http/Middleware`: Incluye los filtros de seguridad, como la validación de tokens **JWT** para asegurar que solo usuarios autenticados realicen compras o accedan al panel de administración.
*   `app/Models`: Representa la estructura de la base de datos MySQL en código PHP (Eloquent). Define las relaciones entre productos, categorías, usuarios y ventas.  
*   `database/migrations`: Contiene el historial de la estructura de la base de datos, permitiendo recrear las tablas de instrumentos, vinilos e iluminación en cualquier entorno.  
*   `database/seeders`: Archivos para poblar la base de datos con información inicial (ej. el catálogo inicial de productos o el usuario administrador).
*   `routes/api.php`: Es el archivo más importante para el frontend. Aquí se definen todos los endpoints que la app de Flutter consume (ej. `GET /products`, `POST /orders`).
*   `storage/app/public`: Almacena los recursos multimedia como las imágenes de los instrumentos y las demos de audio que se sirven a la aplicación.
*   `.env`: Archivo de configuración crítica donde se almacenan las llaves secretas de **Stripe**, las credenciales de la base de datos y el **JWT_SECRET**.

### 🔄 Flujo de Comunicación (Frontend ↔ Backend)
El ecosistema Musilux funciona mediante peticiones **RESTful**. Cuando un usuario busca un vinilo en la aplicación (Flutter), la app solicita la información al controlador correspondiente en **Laravel**. Este valida la sesión mediante un token JWT, consulta la base de datos MySQL, enriquece los datos con la **API de Youtube** y devuelve una respuesta JSON optimizada que la app móvil renderiza en milisegundos.

---

## 📈 Metodología de Trabajo
Este proyecto se desarrolla bajo el marco **Scrum**, con entregas incrementales enfocadas en mejorar la conversión de visitantes a clientes mediante demos gratuitas de calidad.
