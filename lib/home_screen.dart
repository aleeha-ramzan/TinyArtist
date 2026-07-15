import 'package:flutter/material.dart';
import 'draw_screen.dart';
import 'color_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key,});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF6D6DA),
      body: SafeArea(
        child: Column(
          children: [

            // 🔹 TOP WELCOME ROW
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/cat_pen.png',
                    height: 60,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Welcome Tiny Artist!',
                    style: TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'cursive',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 🔹 CENTER ART BOARD (FIXED LAYOUT)
            Container(
              height: 160,
              width: size.width * 0.9,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF8D64B6),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  // ✍️ TEXT LEFT FRONT
                  Expanded(
                    child: Text(
                      'Made Art Easy',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontFamily: 'cursive',
                      ),
                    ),
                  ),

                  // 🐶 CANVAS RIGHT
                  Image.asset(
                    'assets/images/dog_canvas.png',
                    height: 150,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 60),

            // 🔹 BOTTOM BUTTONS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [

                  // DRAW BUTTON
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DrawScreen(),
                          ),
                        );
                      },
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: const Color(0xFFB884F5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/draw_book.png',
                              height: 70,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Draw ➜',
                              style: TextStyle(
                                fontSize: 22,
                                fontFamily: 'ComicSans',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // COLOR BUTTON
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ColorScreen(),
                          ),
                        );
                      },
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: const Color(0xFFC7B3FF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/color_kid.png',
                              height: 70,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Color ➜',
                              style: TextStyle(
                                fontSize: 22,
                                fontFamily: 'ComicSans',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
