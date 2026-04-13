import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/auth_service.dart';
import '../../api_constants.dart';
import '../../core/app_router.dart';
import '../../theme/colors.dart';
import '../../widgets/rol_guard.dart';

class PedidosDashboard extends StatefulWidget {
  const PedidosDashboard({super.key});

  @override
  State<PedidosDashboard> createState() => _PedidosDashboardState();
}

class _PedidosDashboardState extends State<PedidosDashboard> {
  List<dynamic> _pedidos = [];
  bool _cargando = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarPedidos();
  }

  Future<void> _cargarPedidos() async {
    setState(() { _cargando = true; _error = null; });

    final token = await AuthService().getToken();

    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/admin/pedidos'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() => _pedidos = data['data'] ?? []);
      } else if (response.statusCode == 403) {
        setState(() => _error = 'Sin permiso para ver pedidos.');
      } else {
        setState(() => _error = 'Error al cargar pedidos.');
      }
    } catch (_) {
      setState(() => _error = 'No se pudo conectar al servidor.');
    } finally {
      setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Pedidos — ${auth.usuario?.nombres ?? ''}'),
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.maybePop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.login, (_) => false,
                );
              }
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_cargando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
            const SizedBox(height: 12),
            Text(_error!, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _cargarPedidos,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (_pedidos.isEmpty) {
      return const Center(
        child: Text(
          'No hay pedidos registrados aún.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _cargarPedidos,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _pedidos.length,
        itemBuilder: (context, index) {
          final pedido = _pedidos[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: const Icon(Icons.receipt_long, color: Colors.orange),
              title: Text('Pedido #${pedido['id'] ?? index}'),
              subtitle: Text(pedido['estado'] ?? 'Sin estado'),
              trailing: RolGuard(
                permiso: 'pedidos.actualizar',
                child: IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () {
                    // TODO: navegar a detalle de pedido
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
