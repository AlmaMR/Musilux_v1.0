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

  static const List<String> _estados = [
    'pendiente',
    'confirmado',
    'en_preparacion',
    'enviado',
    'entregado',
    'cancelado',
  ];

  @override
  void initState() {
    super.initState();
    _cargarPedidos();
  }

  Future<void> _cargarPedidos() async {
    setState(() {
      _cargando = true;
      _error = null;
    });

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

  Future<void> _cambiarEstado(String pedidoId, String estadoActual) async {
    final seleccionado = await showDialog<String>(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text('Cambiar estado'),
        children: _estados
            .map(
              (estado) => SimpleDialogOption(
                child: Text(estado),
                onPressed: () => Navigator.pop(context, estado),
              ),
            )
            .toList(),
      ),
    );

    if (seleccionado == null || seleccionado == estadoActual) return;

    final token = await AuthService().getToken();
    final response = await http.put(
      Uri.parse('${ApiConstants.baseUrl}/admin/pedidos/$pedidoId/estado'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'estado': seleccionado}),
    );

    if (!mounted) return;

    if (response.statusCode == 200) {
      await _cargarPedidos();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Estado actualizado a "$seleccionado"'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo actualizar el estado.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatMoney(dynamic value) {
    if (value == null) return 'N/A';
    if (value is num) {
      return '\$${value.toStringAsFixed(2)}';
    }
    final parsed = double.tryParse(value.toString());
    if (parsed != null) {
      return '\$${parsed.toStringAsFixed(2)}';
    }
    return value.toString();
  }

  String _formatDate(dynamic value) {
    if (value == null) return 'N/A';
    final parsed = DateTime.tryParse(value.toString());
    if (parsed != null) {
      return parsed.toLocal().toString();
    }
    return value.toString();
  }

  Widget _buildField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Pedidos — ${auth.usuario?.nombres ?? ''}'),
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
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil(AppRoutes.login, (_) => false);
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
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
        ),
      );
    }

    if (_pedidos.isEmpty) {
      return RefreshIndicator(
        onRefresh: _cargarPedidos,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 160),
            Center(
              child: Text(
                'No hay pedidos disponibles.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _cargarPedidos,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _pedidos.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final pedido = _pedidos[index] as Map<String, dynamic>;
          final estado = pedido['estado']?.toString() ?? 'Sin estado';
          final id = pedido['id']?.toString() ?? 'N/A';

          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              leading: const Icon(Icons.receipt_long, color: Colors.orange),
              title: Text('Pedido #$id'),
              subtitle: Text(estado),
              children: [
                _buildField(
                  'Usuario',
                  pedido['id_usuario']?.toString() ?? 'N/A',
                ),
                _buildField('Estado', estado),
                _buildField(
                  'Subtotal',
                  _formatMoney(pedido['subtotal'] ?? pedido['monto_subtotal']),
                ),
                _buildField(
                  'Impuesto',
                  _formatMoney(
                    pedido['monto_impuesto'] ??
                        pedido['tax'] ??
                        pedido['impuesto'],
                  ),
                ),
                _buildField(
                  'Costo envío',
                  _formatMoney(
                    pedido['costo_envio'] ?? pedido['shipping_cost'],
                  ),
                ),
                _buildField(
                  'Monto total',
                  _formatMoney(pedido['monto_total'] ?? pedido['total']),
                ),
                _buildField(
                  'Dirección envío',
                  pedido['id_direccion_envio']?.toString() ??
                      pedido['direccion_envio']?.toString() ??
                      'N/A',
                ),
                _buildField(
                  'Intento pago',
                  pedido['id_intento_pago']?.toString() ?? 'N/A',
                ),
                _buildField(
                  'Creado en',
                  _formatDate(pedido['creado_en'] ?? pedido['created_at']),
                ),
                _buildField(
                  'Actualizado en',
                  _formatDate(pedido['actualizado_en'] ?? pedido['updated_at']),
                ),
                const SizedBox(height: 12),
                RolGuard(
                  permiso: 'pedidos.actualizar',
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.sync_alt),
                      label: const Text('Cambiar estado'),
                      onPressed: () {
                        if (pedido['id'] != null) {
                          _cambiarEstado(pedido['id'].toString(), estado);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
