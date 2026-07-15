import 'package:flutter/material.dart';
import 'color_canvas_screen.dart';

class ColorScreen extends StatelessWidget {
  const ColorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6D6DA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // HEADER
              Row(
                children: [
                  Image.asset('assets/images/cat_color.png', height: 80),

                ],
              ),

              const SizedBox(height: 20),

              _sectionTitle(context, 'Animals'),
              _imageRow(context, [
                'assets/templates/animal_dog.png',
                'assets/templates/animal_giraffe.png',
                'assets/templates/animal_lion.png',
              ]),

              const SizedBox(height: 20),

              _sectionTitle(context, 'Characters'),
              _imageRow(context, [
                'assets/templates/char_girl.png',
                'assets/templates/char_princess.png',
                'assets/templates/char_boy.png',
              ]),

              const SizedBox(height: 20),

              _sectionTitle(context, 'Explore More'),
              _imageRow(context, [
                'assets/templates/car.png',
                'assets/templates/rocket.png',
                'assets/templates/cat.png',
              ]),
            ],
          ),
        ),
      ),

      // BOTTOM NAV
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Icon(Icons.home, size: 32),
            //Icon(Icons.save, size: 32),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        //const Icon(Icons.arrow_forward_ios),
      ],
    );
  }

  Widget _imageRow(BuildContext context, List<String> images) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: images.map((img) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ColorCanvasScreen(imagePath: img),
              ),
            );
          },
          child: Container(
            width: 95,
            height: 95,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(8),
            child: Image.asset(img),
          ),
        );
      }).toList(),
    );
  }
}
