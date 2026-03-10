import 'package:flutter/material.dart';
import 'package:musilux/widgets/shared_components.dart';
import '../theme/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Estados para controlar qué vista mostrar
  bool isAuthenticated = false; // ¿Inició sesión?
  bool isLoginView = true; // true = Mostrar Login, false = Mostrar Registro

  // Claves para los formularios
  final _registerFormKey = GlobalKey<FormState>();
  final _loginFormKey = GlobalKey<FormState>();

  // Controladores de texto para guardar los datos
  final _nombresController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _correoController = TextEditingController();
  final _passwordController = TextEditingController();

  // Variable para guardar la fecha
  String _fechaRegistro = '';

  @override
  void dispose() {
    _nombresController.dispose();
    _apellidosController.dispose();
    _correoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Función para simular el registro
  void _registrarse() {
    if (_registerFormKey.currentState!.validate()) {
      setState(() {
        // Obtenemos la fecha actual
        final now = DateTime.now();
        final meses = [
          'Ene',
          'Feb',
          'Mar',
          'Abr',
          'May',
          'Jun',
          'Jul',
          'Ago',
          'Sep',
          'Oct',
          'Nov',
          'Dic',
        ];
        _fechaRegistro =
            '${now.day} de ${meses[now.month - 1]} del ${now.year}';

        isAuthenticated =
            true; // Iniciamos la sesión automáticamente al registrar
      });
    }
  }

  // Función para simular el inicio de sesión
  void _iniciarSesion() {
    if (_loginFormKey.currentState!.validate()) {
      setState(() {
        isAuthenticated = true;
        // Si no se había registrado (datos vacíos), llenamos datos genéricos de prueba
        if (_nombresController.text.isEmpty) {
          _nombresController.text = 'Usuario';
          _apellidosController.text = 'Musilux';
          _fechaRegistro = 'Usuario antiguo';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
        child: Center(
          child: Container(
            width: 450, // Ancho máximo para que no se vea gigante en web
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(13),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            // Decidimos qué vista mostrar dependiendo del estado
            child: isAuthenticated
                ? _buildProfileInfo()
                : (isLoginView ? _buildLoginForm() : _buildRegisterForm()),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // VISTA: INFORMACIÓN DEL PERFIL
  // ==========================================
  Widget _buildProfileInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundColor: AppColors.primaryPurple,
          child: Icon(Icons.person, size: 50, color: Colors.white),
        ),
        const SizedBox(height: 20),
        Text(
          '${_nombresController.text} ${_apellidosController.text}'.trim(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.headerBg,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          _correoController.text,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Divider(),
        ),

        _buildInfoRow(Icons.calendar_today, 'Miembro desde', _fechaRegistro),
        const SizedBox(height: 15),
        _buildInfoRow(
          Icons.shopping_bag_outlined,
          'Mis pedidos',
          '0 pedidos realizados',
        ),

        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                isAuthenticated = false;
                // Opcional: limpiar datos al cerrar sesión
                // _passwordController.clear();
              });
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
            ),
            child: const Text('Cerrar Sesión'),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryPurple),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.black54, fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================
  // VISTA: FORMULARIO DE REGISTRO
  // ==========================================
  Widget _buildRegisterForm() {
    return Form(
      key: _registerFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Crear Cuenta',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Únete a Musilux para realizar tus compras.',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 30),

          _buildTextFormField(
            'Nombres',
            controller: _nombresController,
            validator: (value) =>
                value!.isEmpty ? 'Por favor, ingresa tu nombre' : null,
          ),
          const SizedBox(height: 16),
          _buildTextFormField('Apellidos', controller: _apellidosController),
          const SizedBox(height: 16),
          _buildTextFormField(
            'Correo electrónico',
            controller: _correoController,
            isEmail: true,
            validator: (value) {
              if (value!.isEmpty) return 'Por favor, ingresa tu correo';
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Ingresa un correo válido';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextFormField(
            'Contraseña',
            controller: _passwordController,
            isPassword: true,
            validator: (value) {
              if (value!.isEmpty) return 'Por favor, ingresa una contraseña';
              if (value.length < 6) {
                return 'La contraseña debe tener al menos 6 caracteres';
              }
              return null;
            },
          ),

          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _registrarse,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurpleHover,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Registrarse',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Center(
            child: TextButton(
              onPressed: () => setState(() => isLoginView = true),
              child: const Text(
                '¿Ya tienes cuenta? Inicia sesión aquí',
                style: TextStyle(color: AppColors.primaryPurple),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // VISTA: FORMULARIO DE INICIO DE SESIÓN
  // ==========================================
  Widget _buildLoginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Iniciar Sesión',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Bienvenido de nuevo a Musilux.',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 30),

          _buildTextFormField(
            'Correo electrónico',
            controller: _correoController,
            isEmail: true,
            validator: (value) {
              if (value!.isEmpty) return 'Por favor, ingresa tu correo';
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Ingresa un correo válido';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextFormField(
            'Contraseña',
            controller: _passwordController,
            isPassword: true,
            validator: (value) =>
                value!.isEmpty ? 'Por favor, ingresa tu contraseña' : null,
          ),

          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _iniciarSesion,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurpleHover,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Ingresar',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Center(
            child: TextButton(
              onPressed: () => setState(() => isLoginView = false),
              child: const Text(
                '¿No tienes cuenta? Regístrate aquí',
                style: TextStyle(color: AppColors.primaryPurple),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper para construir los inputs con validación
  Widget _buildTextFormField(
    String label, {
    required TextEditingController controller,
    bool isPassword = false,
    bool isEmail = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primaryPurple),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
