import 'package:flutter/material.dart';
import '../widgets/shared_components.dart';
import '../theme/colors.dart';

class VinylsScreen extends StatefulWidget {
  const VinylsScreen({super.key});

  @override
  State<VinylsScreen> createState() => _VinylsScreenState();
}

class _VinylsScreenState extends State<VinylsScreen> {
  String _selectedCategory = 'Todos';
  String _selectedSort = 'Recomendados';

  final List<String> _categories = [
    'Todos',
    'Rock',
    'Pop',
    'Jazz',
    'Clásica',
    'Electrónica',
    'Grunge',
    'Metal',
    'Acustico',
    'Alternativo',
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
    if (screenWidth < 600) {
      crossAxisCount = 1;
    } else if (screenWidth < 900) {
      crossAxisCount = 2;
    } else if (screenWidth < 1200) {
      crossAxisCount = 3;
    }

    var filteredProducts = _vinilosProducts.where((product) {
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
              'Discos de Vinilo',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'La mejor calidad de audio analógico de tus artistas favoritos.',
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
                        'No hay discos en esta categoría',
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

final List<Map<String, dynamic>> _vinilosProducts = [
  {
    'title': 'Sliver - Nirvana',
    'price': 299.99,
    'tags': ['Rock', 'Oferta'],
    'image':
        'https://m.media-amazon.com/images/I/81oDljdj-FL._UF1000,1000_QL80_.jpg',
    'isSale': true,
  },
  {
    'title': 'Unplugged in New York - Nirvana',
    'price': 999.99,
    'tags': ['Rock', 'Grunge', 'Acustico'],
    'image':
        'https://m.media-amazon.com/images/I/61kVo9GKvjL._UF1000,1000_QL80_.jpg',
    'isSale': false,
  },
  {
    'title': 'Highway to Hell- AC/DC',
    'price': 942.99,
    'tags': ['Rock', 'Alternativo'],
    'image': 'https://m.media-amazon.com/images/I/71SKVywshEL.jpg',
    'isSale': false,
  },
  {
    'title': 'Nevermind - Nirvana',
    'price': 1049.99,
    'tags': ['Rock', 'Grunge'],
    'image': 'https://m.media-amazon.com/images/I/61ZhsEYnSdL.jpg',
    'isSale': false,
  },
  {
    'title': 'Abbey Road - The Beatles',
    'price': 450.00,
    'tags': ['Rock', 'Clásico'],
    'image': 'https://m.media-amazon.com/images/I/91YlTtiGi0L.jpg',
    'isSale': false,
  },
  {
    'title': 'Kind of Blue - Miles Davis',
    'price': 520.00,
    'tags': ['Jazz'],
    'image':
        'https://m.media-amazon.com/images/I/71W8b8QzfiL._UF1000,1000_QL80_.jpg',
    'isSale': false,
  },
  {
    'title': 'Thriller - Michael Jackson',
    'price': 380.00,
    'tags': ['Pop'],
    'image':
        'https://m.media-amazon.com/images/I/81ogsUqshzL._UF1000,1000_QL80_.jpg',
    'isSale': false,
  },
];
