import 'package:flutter/material.dart';
import '../widgets/shared_components.dart';

class InstrumentsScreen extends StatelessWidget {
  const InstrumentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    return BaseLayout(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : 40,
          vertical: 30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Instrumentos Musicales',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Encuentra guitarras, baterías, pianos y más para desatar tu creatividad.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),

            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                ProductCard(
                  title: 'Guitarra Acústica Yamaha',
                  price: 3499.00,
                  imageUrl:
                      'https://images.unsplash.com/photo-1564186763535-ebb21ef5277f?w=400',
                  tags: const ['Acústica', 'Principiante', 'Yamaha'],
                  onDetailsTap: () =>
                      Navigator.pushNamed(context, '/detalle-producto'),
                ),
                ProductCard(
                  title: 'Teclado MIDI Akai',
                  price: 2100.50,
                  imageUrl:
                      'https://images.unsplash.com/photo-1598514982205-f36b96d1e8d4?w=400',
                  tags: const ['Estudio', 'MIDI', 'Producción'],
                  onDetailsTap: () =>
                      Navigator.pushNamed(context, '/detalle-producto'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
