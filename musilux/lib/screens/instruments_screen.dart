import 'package:flutter/material.dart';
import '../widgets/shared_components.dart';
import '../theme/colors.dart';

class InstrumentsScreen extends StatefulWidget {
  const InstrumentsScreen({Key? key}) : super(key: key);

  @override
  State<InstrumentsScreen> createState() => _InstrumentsScreenState();
}

class _InstrumentsScreenState extends State<InstrumentsScreen> {
  String _selectedCategory = 'Todos';
  String _selectedSort = 'Recomendados';

  final List<String> _categories = [
    'Todos',
    'Guitarras',
    'Bajos',
    'Baterías',
    'Teclados',
    'Accesorios',
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

    var filteredProducts = _instrumentosProducts.where((product) {
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
              'Instrumentos Musicales',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Encuentra el sonido perfecto para ti.',
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

final List<Map<String, dynamic>> _instrumentosProducts = [
  {
    'title': 'Guitarra Eléctrica Fender',
    'price': 18500.00,
    'tags': ['Guitarras', 'Profesional'],
    'image':
        '[https://images.unsplash.com/photo-1564186763535-ebb964f94349?w=600](https://images.unsplash.com/photo-1564186763535-ebb964f94349?w=600)',
    'isSale': false,
  },
  {
    'title': 'Batería Acústica Yamaha',
    'price': 15499.00,
    'tags': ['Baterías', 'Oferta'],
    'image':
        '[https://images.unsplash.com/photo-1519892300165-cb5542fb47c7?w=600](https://images.unsplash.com/photo-1519892300165-cb5542fb47c7?w=600)',
    'isSale': true,
  },
  {
    'title': 'Bajo Eléctrico Ibanez',
    'price': 7200.00,
    'tags': ['Bajos'],
    'image':
        '[https://images.unsplash.com/photo-1564186763535-ebb964f94349?w=600](https://images.unsplash.com/photo-1564186763535-ebb964f94349?w=600)',
    'isSale': false,
  },
  {
    'title': 'Teclado Korg 61 Teclas',
    'price': 8200.00,
    'tags': ['Teclados', 'Oferta'],
    'image':
        '[https://images.unsplash.com/photo-1552422535-c45813c61732?w=600](https://images.unsplash.com/photo-1552422535-c45813c61732?w=600)',
    'isSale': true,
  },
  {
    'title': 'Guitarra Acústica Taylor',
    'price': 9500.00,
    'tags': ['Guitarras', 'Acústica'],
    'image':
        '[https://images.unsplash.com/photo-1550985543-f47f38aeea53?w=600](https://images.unsplash.com/photo-1550985543-f47f38aeea53?w=600)',
    'isSale': true,
  },
];
