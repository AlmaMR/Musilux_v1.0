import 'package:flutter/material.dart';
import '../widgets/shared_components.dart';
import '../theme/colors.dart';

class LightingScreen extends StatefulWidget {
  const LightingScreen({Key? key}) : super(key: key);

  @override
  State<LightingScreen> createState() => _LightingScreenState();
}

class _LightingScreenState extends State<LightingScreen> {
  // Variables de estado para los filtros
  String _selectedCategory = 'Todos';
  String _selectedSort = 'Recomendados';

  final List<String> _categories = [
    'Todos',
    'LED',
    'Láser',
    'Humo',
    'FX',
    'Profesional',
  ];
  final List<String> _sortOptions = [
    'Recomendados',
    'Precio: Menor a Mayor',
    'Precio: Mayor a Menor',
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    // Calcular columnas
    int crossAxisCount = 4;
    if (screenWidth < 600)
      crossAxisCount = 1;
    else if (screenWidth < 900)
      crossAxisCount = 2;
    else if (screenWidth < 1200)
      crossAxisCount = 3;

    // 1. Filtrar lista
    var filteredProducts = _iluminacionProducts.where((product) {
      if (_selectedCategory == 'Todos') return true;
      return (product['tags'] as List).contains(_selectedCategory);
    }).toList();

    // 2. Ordenar lista
    if (_selectedSort == 'Precio: Menor a Mayor') {
      filteredProducts.sort(
        (a, b) => (a['price'] as double).compareTo(b['price'] as double),
      );
    } else if (_selectedSort == 'Precio: Mayor a Menor') {
      filteredProducts.sort(
        (a, b) => (b['price'] as double).compareTo(a['price'] as double),
      );
    }

    return BaseLayout(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 40,
          vertical: 30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TÍTULO Y DESCRIPCIÓN
            const Text(
              'Equipos de Iluminación',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            // BARRA DE FILTROS Y ORDENAMIENTO
            if (isMobile)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFilterChips(),
                  const SizedBox(height: 16),
                  _buildSortDropdown(),
                ],
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildFilterChips()),
                  const SizedBox(width: 20),
                  _buildSortDropdown(),
                ],
              ),

            const SizedBox(height: 30),

            // GRID DE PRODUCTOS (Con proporciones corregidas)
            filteredProducts.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Text(
                        'No hay productos en esta categoría',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio:
                          0.72, // Relación de aspecto perfecta para la ProductCard
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final item = filteredProducts[index];
                      return ProductCard(
                        title: item['title'],
                        price: item['price'],
                        tags: item['tags'],
                        imageUrl: item['image'],
                        isSale: item['isSale'],
                        onDetailsTap: () =>
                            Navigator.pushNamed(context, '/producto/detalle'),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  // WIDGET: Lista horizontal de etiquetas (Chips)
  Widget _buildFilterChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _categories.map((category) {
        final isSelected = _selectedCategory == category;
        return ChoiceChip(
          label: Text(
            category,
            style: TextStyle(color: isSelected ? Colors.white : Colors.black87),
          ),
          selected: isSelected,
          selectedColor: AppColors.primaryPurple,
          backgroundColor: Colors.grey.shade200,
          onSelected: (selected) {
            setState(() {
              _selectedCategory = category;
            });
          },
        );
      }).toList(),
    );
  }

  // WIDGET: ComboBox de Ordenar por
  Widget _buildSortDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.sort, size: 20, color: Colors.black54),
          const SizedBox(width: 8),
          const Text('Ordenar por: ', style: TextStyle(color: Colors.black54)),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedSort,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.primaryPurple,
              ),
              items: _sortOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedSort = newValue;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Lista de datos para los productos de iluminación
final List<Map<String, dynamic>> _iluminacionProducts = [
  {
    'title': 'Cabeza Móvil Beam 230W',
    'price': 4500.00,
    'tags': ['Profesional', 'LED'],
    'image':
        '[https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad?w=600](https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad?w=600)',
    'isSale': false,
  },
  {
    'title': 'Láser RGB Animación',
    'price': 2800.00,
    'tags': ['DJ', 'Láser'],
    'image':
        '[https://images.unsplash.com/photo-1470229722913-7c090bf356c4?w=600](https://images.unsplash.com/photo-1470229722913-7c090bf356c4?w=600)',
    'isSale': true,
  },
  {
    'title': 'Máquina de Humo 1500W',
    'price': 1200.00,
    'tags': ['FX', 'Humo'],
    'image':
        '[https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=600](https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=600)',
    'isSale': false,
  },
  {
    'title': 'Barra LED Ultravioleta UV',
    'price': 850.00,
    'tags': ['Neón', 'LED'],
    'image':
        '[https://images.unsplash.com/photo-1550684848-fac1c5b4e853?w=600](https://images.unsplash.com/photo-1550684848-fac1c5b4e853?w=600)',
    'isSale': false,
  },
  {
    'title': 'Par LED 54x3W RGBW',
    'price': 650.00,
    'tags': ['Escenario', 'LED'],
    'image':
        '[https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=600](https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=600)',
    'isSale': true,
  },
  {
    'title': 'Controlador DMX 512',
    'price': 1400.00,
    'tags': ['Control', 'Profesional'],
    'image':
        '[https://images.unsplash.com/photo-1598488035139-bdbb2231ce04?w=600](https://images.unsplash.com/photo-1598488035139-bdbb2231ce04?w=600)',
    'isSale': false,
  },
  {
    'title': 'Luz Estroboscópica 1000W',
    'price': 2100.00,
    'tags': ['Estrobo', 'Discoteca'],
    'image':
        '[https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?w=600](https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?w=600)',
    'isSale': false,
  },
  {
    'title': 'Esfera de Espejos 30cm',
    'price': 450.00,
    'tags': ['Clásico', 'Discoteca'],
    'image':
        '[https://images.unsplash.com/photo-1574169208507-84376144848b?w=600](https://images.unsplash.com/photo-1574169208507-84376144848b?w=600)',
    'isSale': true,
  },
  {
    'title': 'Máquina de Burbujas',
    'price': 800.00,
    'tags': ['FX', 'Fiesta'],
    'image':
        '[https://images.unsplash.com/photo-1516280440502-861033c4eb89?w=600](https://images.unsplash.com/photo-1516280440502-861033c4eb89?w=600)',
    'isSale': false,
  },
];
