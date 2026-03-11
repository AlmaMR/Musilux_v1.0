import 'package:flutter/material.dart';
import '../features/catalog/data/product_model.dart';
import '../features/catalog/data/api_service.dart';
import '../theme/colors.dart';
import '../widgets/shared_components.dart';

class AdminProductsScreen extends StatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  final ProductService _productService = ProductService();
  late Future<List<ProductModel>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _refreshProducts();
  }

  void _refreshProducts() {
    setState(() {
      _productsFuture = _productService.getProducts();
    });
  }

  void _showProductForm({ProductModel? product}) {
    showDialog(
      context: context,
      builder: (context) => ProductFormDialog(
        product: product,
        onSave: (newProduct) async {
          bool success;
          if (product == null) {
            success = await _productService.createProduct(newProduct);
          } else {
            success = await _productService.updateProduct(newProduct);
          }

          if (success) {
            if (!mounted) return;
            Navigator.pop(context);
            _refreshProducts();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Operación exitosa')));
          } else {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error al guardar el producto')),
            );
          }
        },
      ),
    );
  }

  void _deleteProduct(String id) async {
    bool confirm =
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirmar'),
            content: const Text('¿Estás seguro de eliminar este producto?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Eliminar',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ) ??
        false;

    if (confirm) {
      bool success = await _productService.deleteProduct(id);
      if (success) {
        if (!mounted) return;
        _refreshProducts();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Producto eliminado')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Administración de Productos',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showProductForm(),
                  icon: const Icon(Icons.add),
                  label: const Text('Nuevo Producto'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            FutureBuilder<List<ProductModel>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No hay productos registrados.'),
                  );
                }

                final products = snapshot.data!;
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primaryPurple.withValues(
                          alpha: 0.1,
                        ),
                        child: Text(product.tipoProducto[0].toUpperCase()),
                      ),
                      title: Text(product.nombre),
                      subtitle: Text(
                        '\$${product.precio} - Stock: ${product.inventario}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showProductForm(product: product),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteProduct(product.id!),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProductFormDialog extends StatefulWidget {
  final ProductModel? product;
  final Function(ProductModel) onSave;

  const ProductFormDialog({super.key, this.product, required this.onSave});

  @override
  State<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<ProductFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreCtrl;
  late TextEditingController _slugCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _precioCtrl;
  late TextEditingController _invCtrl;
  late TextEditingController _bpmCtrl;
  String _tipoProducto = 'fisico';
  bool _estaActivo = true;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nombreCtrl = TextEditingController(text: p?.nombre ?? '');
    _slugCtrl = TextEditingController(text: p?.slug ?? '');
    _descCtrl = TextEditingController(text: p?.descripcion ?? '');
    _precioCtrl = TextEditingController(text: p?.precio.toString() ?? '');
    _invCtrl = TextEditingController(text: p?.inventario.toString() ?? '');
    _bpmCtrl = TextEditingController(text: p?.bpm?.toString() ?? '');
    _tipoProducto = p?.tipoProducto ?? 'fisico';
    _estaActivo = p?.estaActivo ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.product == null ? 'Nuevo Producto' : 'Editar Producto',
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nombreCtrl,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
                onChanged: (val) {
                  if (widget.product == null) {
                    // Generar slug simple automáticamente al crear
                    _slugCtrl.text = val.toLowerCase().replaceAll(' ', '-');
                  }
                },
              ),
              TextFormField(
                controller: _slugCtrl,
                decoration: const InputDecoration(labelText: 'Slug'),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              DropdownButtonFormField<String>(
                initialValue: _tipoProducto,
                decoration: const InputDecoration(
                  labelText: 'Tipo de Producto',
                ),
                items: const [
                  DropdownMenuItem(value: 'fisico', child: Text('Físico')),
                  DropdownMenuItem(value: 'digital', child: Text('Digital')),
                  DropdownMenuItem(value: 'servicio', child: Text('Servicio')),
                ],
                onChanged: (v) => setState(() => _tipoProducto = v!),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _precioCtrl,
                      decoration: const InputDecoration(labelText: 'Precio'),
                      keyboardType: TextInputType.number,
                      validator: (v) => v!.isEmpty ? 'Requerido' : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _invCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Inventario',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) => v!.isEmpty ? 'Requerido' : null,
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: _bpmCtrl,
                decoration: const InputDecoration(labelText: 'BPM (Opcional)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 2,
              ),
              SwitchListTile(
                title: const Text('Activo'),
                value: _estaActivo,
                onChanged: (v) => setState(() => _estaActivo = v),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final newProduct = ProductModel(
                id: widget.product?.id,
                nombre: _nombreCtrl.text,
                slug: _slugCtrl.text,
                descripcion: _descCtrl.text,
                tipoProducto: _tipoProducto,
                precio: double.parse(_precioCtrl.text),
                inventario: int.parse(_invCtrl.text),
                bpm: int.tryParse(_bpmCtrl.text),
                estaActivo: _estaActivo,
              );
              widget.onSave(newProduct);
            }
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
