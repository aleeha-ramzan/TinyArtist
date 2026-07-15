import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

enum Tool { pen, eraser, line, rect, circle, text, pan }

class DrawScreen extends StatefulWidget {
  const DrawScreen({super.key});
  @override
  State<DrawScreen> createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  List<List<DrawObject>> layers = [[]];
  int activeLayer = 0;

  final redo = <DrawObject>[];

  Tool tool = Tool.pen;
  Color color = Colors.black;
  double size = 4;

  Offset? start, current;

  final controller = TransformationController();

  void add(DrawObject o) {
    setState(() {
      layers[activeLayer].add(o);
      redo.clear();
    });
  }

  void undo() {
    if (layers[activeLayer].isNotEmpty) {
      setState(() => redo.add(layers[activeLayer].removeLast()));
    }
  }

  void redoOp() {
    if (redo.isNotEmpty) {
      setState(() => layers[activeLayer].add(redo.removeLast()));
    }
  }

  void pickColor() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Pick Color"),
        content: ColorPicker(
          pickerColor: color,
          onColorChanged: (c) => setState(() => color = c),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Done"))
        ],
      ),
    );
  }

  void addText(Offset p) {
    final c = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Text"),
        content: TextField(controller: c),
        actions: [
          TextButton(
              onPressed: () {
                add(DrawText(c.text, p, color, size * 4));
                Navigator.pop(context);
              },
              child: const Text("Add"))
        ],
      ),
    );
  }

  Future<void> importImage() async {
    final p = ImagePicker();
    final f = await p.pickImage(source: ImageSource.gallery);
    if (f == null) return;
    final data = await f.readAsBytes();
    final img = await decodeImageFromList(data);
    add(DrawImage(img));
  }

  Future<void> save() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    PaintPainter(layers, null, null).paint(canvas, const Size(2000, 2000));
    final img = await recorder.endRecording().toImage(2000, 2000);
    final bytes = await img.toByteData(format: ui.ImageByteFormat.png);
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/drawing.png");
    await file.writeAsBytes(bytes!.buffer.asUint8List());
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Saved: ${file.path}")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Paint"),
        actions: [
          IconButton(icon: const Icon(Icons.undo), onPressed: undo),
          IconButton(icon: const Icon(Icons.redo), onPressed: redoOp),
          IconButton(icon: const Icon(Icons.save), onPressed: save),
        ],
      ),
      body: InteractiveViewer(
        transformationController: controller,
        child: GestureDetector(
          onPanStart: (d) {
            start = d.localPosition;
            current = start;
          },
          onPanUpdate: (d) {
            current = d.localPosition;
            if (tool == Tool.pen || tool == Tool.eraser) {
              add(DrawLine([start!, current!], tool == Tool.eraser ? Colors.white : color, size));
              start = current;
            }
          },
          onPanEnd: (_) {
            if (tool == Tool.text && current != null) addText(current!);
            if (tool == Tool.line) add(DrawLine([start!, current!], color, size));
            if (tool == Tool.rect) add(DrawRect(start!, current!, color, size));
            if (tool == Tool.circle) add(DrawCircle(start!, current!, color, size));
            start = null;
            current = null;
          },
          child: CustomPaint(
            painter: PaintPainter(layers, start, current),
            size: const Size(2000, 2000),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          btn(Icons.brush, Tool.pen),
          btn(Icons.crop_square, Tool.rect),
          btn(Icons.circle, Tool.circle),
          btn(Icons.text_fields, Tool.text),
          IconButton(icon: const Icon(Icons.color_lens), onPressed: pickColor),
          IconButton(icon: const Icon(Icons.image), onPressed: importImage),
        ]),
      ),
    );
  }

  Widget btn(IconData i, Tool t) => IconButton(icon: Icon(i), onPressed: () => setState(() => tool = t));
}

/* DRAW OBJECTS */

abstract class DrawObject {
  void draw(Canvas c);
}

class DrawLine extends DrawObject {
  final List<Offset> p;
  final Color c;
  final double w;
  DrawLine(this.p, this.c, this.w);
  @override
  void draw(Canvas cns) {
    final pnt = Paint()..color = c..strokeWidth = w..strokeCap = StrokeCap.round;
    cns.drawLine(p.first, p.last, pnt);
  }
}

class DrawRect extends DrawObject {
  final Offset a,b; final Color c; final double w;
  DrawRect(this.a,this.b,this.c,this.w);
  @override
  void draw(Canvas cns){
    cns.drawRect(Rect.fromPoints(a,b),Paint()..color=c..strokeWidth=w..style=PaintingStyle.stroke);
  }
}

class DrawCircle extends DrawObject {
  final Offset a,b; final Color c; final double w;
  DrawCircle(this.a,this.b,this.c,this.w);
  @override
  void draw(Canvas cns){
    cns.drawCircle(a,(a-b).distance,Paint()..color=c..strokeWidth=w..style=PaintingStyle.stroke);
  }
}

class DrawText extends DrawObject {
  final String t; final Offset p; final Color c; final double s;
  DrawText(this.t,this.p,this.c,this.s);
  @override
  void draw(Canvas cns){
    final tp=TextPainter(text:TextSpan(text:t,style:TextStyle(color:c,fontSize:s)),textDirection:TextDirection.ltr);
    tp.layout(); tp.paint(cns,p);
  }
}

class DrawImage extends DrawObject {
  final ui.Image img;
  DrawImage(this.img);
  @override
  void draw(Canvas c)=>c.drawImage(img, Offset.zero, Paint());
}

class PaintPainter extends CustomPainter {
  final List<List<DrawObject>> layers;
  final Offset? s,c;
  PaintPainter(this.layers,this.s,this.c);
  @override
  void paint(Canvas canvas, Size size){
    for(final l in layers){ for(final o in l){ o.draw(canvas); } }
  }
  @override bool shouldRepaint(_) => true;
}