import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

class ColorCanvasScreen extends StatefulWidget {
  final String imagePath;
  const ColorCanvasScreen({super.key, required this.imagePath});

  @override
  State<ColorCanvasScreen> createState() => _ColorCanvasScreenState();
}

class _ColorCanvasScreenState extends State<ColorCanvasScreen> {
  img.Image? originalImage;
  Uint8List? displayedImage;

  Color selectedColor = Colors.red;
  bool isGradient = false;

  List<Uint8List> undoStack = [];

  @override
  void initState() {
    super.initState();
    loadImage();
  }

  Future<void> loadImage() async {
    final data = await rootBundle.load(widget.imagePath);
    final bytes = data.buffer.asUint8List();
    originalImage = img.decodeImage(bytes);
    displayedImage = Uint8List.fromList(img.encodePng(originalImage!));
    setState(() {});
  }

  void bucketFill(int x, int y) {
    if (originalImage == null) return;

    undoStack.add(Uint8List.fromList(displayedImage!));

    final targetColor = originalImage!.getPixel(x, y);
    final fillColor = img.ColorRgb8(
      selectedColor.red,
      selectedColor.green,
      selectedColor.blue,
    );


    if (targetColor == fillColor) return;

    List<List<int>> stack = [];
    stack.add([x, y]);

    while (stack.isNotEmpty) {
      final pos = stack.removeLast();
      int px = pos[0];
      int py = pos[1];

      if (px < 0 ||
          py < 0 ||
          px >= originalImage!.width ||
          py >= originalImage!.height) continue;

      if (originalImage!.getPixel(px, py) != targetColor) continue;

      originalImage!.setPixel(px, py, fillColor);


      stack.add([px + 1, py]);
      stack.add([px - 1, py]);
      stack.add([px, py + 1]);
      stack.add([px, py - 1]);
    }

    displayedImage = Uint8List.fromList(img.encodePng(originalImage!));
    setState(() {});
  }

  void undo() {
    if (undoStack.isNotEmpty) {
      displayedImage = undoStack.removeLast();
      originalImage = img.decodeImage(displayedImage!);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6C1C1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.gradient, color: Colors.black),
            onPressed: () {
              setState(() {
                isGradient = !isGradient;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.undo, color: Colors.black),
            onPressed: undo,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: displayedImage == null
                ? const Center(child: CircularProgressIndicator())
                : GestureDetector(
              onTapDown: (details) {
                final box = context.findRenderObject() as RenderBox;
                final localPosition =
                box.globalToLocal(details.globalPosition);

                final dx = (localPosition.dx *
                    originalImage!.width /
                    box.size.width)
                    .toInt();
                final dy = (localPosition.dy *
                    originalImage!.height /
                    box.size.height)
                    .toInt();

                bucketFill(dx, dy);
              },
              child: Image.memory(displayedImage!),
            ),
          ),

          // Color Palette
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _colorDot(Colors.red),
                _colorDot(Colors.blue),
                _colorDot(Colors.green),
                _colorDot(Colors.yellow),
                _colorDot(Colors.purple),
                _colorDot(Colors.orange),
                _colorDot(Colors.pink),
                _colorDot(Colors.brown),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _colorDot(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
      },
      child: CircleAvatar(
        backgroundColor: color,
        radius: 18,
      ),
    );
  }
}
