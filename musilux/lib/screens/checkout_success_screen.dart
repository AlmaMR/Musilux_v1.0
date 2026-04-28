import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../providers/cart_provider.dart';
import '../theme/colors.dart';
import '../api_constants.dart';

class CheckoutSuccessScreen extends StatefulWidget {
  const CheckoutSuccessScreen({super.key});

  @override
  State<CheckoutSuccessScreen> createState() => _CheckoutSuccessScreenState();
}

class _CheckoutSuccessScreenState extends State<CheckoutSuccessScreen> {
  bool _loading = true;
  String? _sessionId;
  double? _amount; // en unidades monetarias (ej. 500.00)
  String? _currency;
  List<Map<String, dynamic>> _items = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleSession();
    });
  }

  Future<void> _handleSession() async {
    try {
      // Stripe redirige con ?session_id=...
      final uri = Uri.base;
      final sid = uri.queryParameters['session_id'];
      if (sid == null || sid.isEmpty) {
        // No hay session id — mostrar mensaje simple y permitir volver al inicio
        setState(() {
          _loading = false;
          _error = null;
        });
        return;
      }

      setState(() {
        _sessionId = sid;
        _loading = true;
      });

      // Llamar endpoint backend para recuperar detalles de la sesión
      final url = Uri.parse('${ApiConstants.baseUrl}/checkout/session/$sid');
      final resp = await http.get(url, headers: {'Accept': 'application/json'});
      if (resp.statusCode != 200) {
        setState(() {
          _error = 'Error al obtener detalles de pago: ${resp.statusCode}';
          _loading = false;
        });
        return;
      }

      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      // amount_total viene en centavos
      final amountTotal = data['amount_total'];
      double? amount;
      if (amountTotal is int) {
        amount = amountTotal / 100.0;
      } else if (amountTotal is double) {
        amount = amountTotal / 100.0;
      }

      List<Map<String, dynamic>> items = [];
      if (data['line_items'] is List) {
        for (final li in (data['line_items'] as List)) {
          items.add(Map<String, dynamic>.from(li as Map));
        }
      }

      setState(() {
        _amount = amount;
        _currency = (data['currency'] as String?)?.toUpperCase();
        _items = items;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error inesperado: $e';
        _loading = false;
      });
    }
  }

  void _volverHome() async {
    // Vaciar carrito y volver al inicio
    await context.read<CartProvider>().vaciarCarrito();
    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pago exitoso')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: _loading
              ? const CircularProgressIndicator()
              : _error != null
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, size: 72, color: AppColors.error),
                    const SizedBox(height: 12),
                    Text(_error!, textAlign: TextAlign.center),
                    const SizedBox(height: 18),
                    ElevatedButton(
                      onPressed: _volverHome,
                      child: const Text('Volver al inicio'),
                    ),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      size: 96,
                      color: AppColors.success,
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Pago completado con éxito',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_amount != null)
                      Text(
                        'Monto: \$${_amount!.toStringAsFixed(2)} ${_currency ?? ''}',
                      ),
                    const SizedBox(height: 12),
                    if (_items.isNotEmpty) ...[
                      const Text(
                        'Productos comprados:',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 140,
                        child: ListView.builder(
                          itemCount: _items.length,
                          itemBuilder: (_, i) {
                            final it = _items[i];
                            final qty = it['quantity'] ?? 1;
                            final price = it['price'] != null
                                ? (it['price'] / 100.0)
                                : null;
                            final name =
                                it['description'] ??
                                it['product_name'] ??
                                'Artículo';
                            return ListTile(
                              title: Text(name),
                              subtitle: Text('Cantidad: $qty'),
                              trailing: price != null
                                  ? Text('\$${price.toStringAsFixed(2)}')
                                  : null,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    ElevatedButton(
                      onPressed: _volverHome,
                      child: const Text('Ir al inicio'),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
