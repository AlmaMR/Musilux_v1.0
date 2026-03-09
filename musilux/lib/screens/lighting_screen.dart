import 'package:flutter/material.dart';
import '../widgets/shared_components.dart';
import '../theme/colors.dart';

class LightingScreen extends StatefulWidget {
  const LightingScreen({Key? key}) : super(key: key);

  @override
  State<LightingScreen> createState() => _LightingScreenState();
}

class _LightingScreenState extends State<LightingScreen> {
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

    int crossAxisCount = 4;
    if (screenWidth < 600)
      crossAxisCount = 1;
    else if (screenWidth < 900)
      crossAxisCount = 2;
    else if (screenWidth < 1200)
      crossAxisCount = 3;

    var filteredProducts = _iluminacionProducts.where((product) {
      if (_selectedCategory == 'Todos') return true;
      return (product['tags'] as List).contains(_selectedCategory);
    }).toList();

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
            const Text(
              'Equipos de Iluminación y FX',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enciende tu escenario con nuestra mejor selección de luces.',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 30),

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
                      childAspectRatio: 0.72,
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
                            Navigator.pushNamed(context, '/detalle'),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

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

final List<Map<String, dynamic>> _iluminacionProducts = [
  {
    'title': 'Cabeza Móvil Beam 230W',
    'price': 4500.00,
    'tags': ['Profesional', 'LED'],
    'image':
        'https://m.media-amazon.com/images/I/41fmKWKV0nL._AC_UF894,1000_QL80_.jpg',
    'isSale': false,
  },
  {
    'title': 'Láser RGB Animación',
    'price': 2800.00,
    'tags': ['DJ', 'Láser'],
    'image':
        'https://m.media-amazon.com/images/I/71CVXK+vXfL._AC_UF894,1000_QL80_.jpg',
    'isSale': true,
  },
  {
    'title': 'Máquina de Humo 1500W',
    'price': 1200.00,
    'tags': ['FX', 'Humo'],
    'image':
        'https://m.media-amazon.com/images/I/61cflmAri4L._AC_UF1000,1000_QL80_.jpg',
    'isSale': false,
  },
  {
    'title': 'Barra LED Ultravioleta UV',
    'price': 850.00,
    'tags': ['Neón', 'LED'],
    'image':
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSTjCQBd1vJMazO6fzzaMRHLCww_omyUi5waw&s',
    'isSale': false,
  },
  {
    'title': 'Par LED 54x3W RGBW',
    'price': 650.00,
    'tags': ['Escenario', 'LED'],
    'image':
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSdQDcWOHDlB8yvlO4_qFQuP-u8gV8VISi72Q&s',
    'isSale': true,
  },
  {
    'title': 'Controlador DMX 512',
    'price': 1400.00,
    'tags': ['Control', 'Profesional'],
    'image':
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQQBVDWXr07n7P8kU0e2WqFfaP1MnF6jbgRjA&s',
    'isSale': false,
  },
];
