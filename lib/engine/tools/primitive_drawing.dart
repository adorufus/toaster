import 'dart:ffi';
import 'dart:math';
import 'package:sdl2/sdl2.dart';

class PrimitiveDrawing {
  Pointer<SdlRenderer> renderer;

  PrimitiveDrawing(this.renderer);

  void draw({List<Point<double>>? points}) {
    renderer.drawLines(points ?? []);
  }

  void createBox() {
    final sideLength = 50.0;
    final startX = 300.0;
    final startY = 200.0;

    // Define the points for the square
    draw(points: [
      Point(startX, startY), // Top-left
      Point(startX + sideLength, startY), // Top-right
      Point(startX + sideLength, startY + sideLength), // Bottom-right
      Point(startX, startY + sideLength), // Bottom-left
      Point(startX, startY) // Closing the square
    ]);
  }
}
