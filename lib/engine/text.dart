import 'dart:ffi';
import 'dart:math';
import 'package:ffi/ffi.dart';
import 'package:sdl2/sdl2.dart';

class Text {
  Pointer<TtfFont> font = nullptr;

  int init(String fontPath, int fontSize) {
    font = TtfFontEx.open(fontPath, fontSize);

    if (font == nullptr) {
      print('Unable to load font: \'$fontPath\'!\n'
          'SDL2_ttf Error: ${ttfGetError()}\n');
      return 0;
    }

    return 1;
  }

  void render(
      Pointer<SdlRenderer> renderer, String message, double x, double y) {
    Pointer<SdlTexture> texture = nullptr;
    late Rectangle<double> textRect;

    var textureSurface = font.renderUtf8Shaded(
        message,
        SdlColorEx.rgbaToU32(255, 255, 255, SDL_ALPHA_OPAQUE),
        SdlColorEx.rgbaToU32(0, 0, 0, SDL_ALPHA_OPAQUE));

    if (textureSurface == nullptr) {
      print('Unable to render text surface!\n'
          'SDL2_ttf Error: ${ttfGetError()}\n');
      return;
    }

    texture = renderer.createTextureFromSurface(textureSurface);

    if (texture == nullptr) {
      print('Unable to create texture from rendered text!\n'
          'SDL2 Error: ${sdlGetError()}\n');
    } else {
      textRect = Rectangle<double>(x, y, textureSurface.ref.w.toDouble(),
          textureSurface.ref.h.toDouble());

      if (renderer == nullptr) {
        print("no renderer found, SDL_Error: ${sdlGetError()}");
      }

      renderer.copy(texture, dstrect: textRect);

      texture.destroy();
    }

    textureSurface.free();
  }

  void destroy() {
    font.close();
    font = nullptr;
    ttfQuit();
  }
}
