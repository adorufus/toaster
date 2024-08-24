import "dart:ffi";
import 'package:ffi/ffi.dart';
import 'package:sdl2/sdl2.dart';

class Renderer {
  int height;
  int width;
  Pointer<SdlWindow> window = nullptr;
  Pointer<SdlRenderer> renderer = nullptr;
  final test = calloc<Int32>();

  Renderer(this.height, this.width);

  bool init(String title) {
    window = SdlWindowEx.create(
      title: title,
      w: 640,
      h: 480,
      flags: SDL_WINDOW_RESIZABLE | SDL_WINDOW_SHOWN
    );

    if (window == nullptr) {
      print(sdlGetError());
      sdlQuit();
      return false;
    }

    renderer = window.createRenderer(
        -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
    if (renderer == nullptr) {
      print(sdlGetError());
      window.destroy();
      sdlQuit();
      return false;
    }

    return true;
  }

  void clear() {
    renderer.setDrawColor(0, 0, 0, SDL_ALPHA_OPAQUE);
    renderer.clear();
    renderer.setDrawColor(255, 255, 255, SDL_ALPHA_OPAQUE);
  }

  void present() {
    renderer.present();
  }

  Pointer<SdlWindow> getWindow() {
    return window;
  }

  Pointer<SdlRenderer> getRenderer() {
    return renderer;
  }
}

// class Renderer {

//   bool init(Pointer<Pointer<SdlRenderer>> renderer, Pointer<Pointer<SdlWindow>> window, String title, int windowHeight, int windowWidth) {
//     window.value = sdlCreateWindow(title, SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, windowWidth, windowHeight, SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE);

//     if(window == nullptr) {
//       print("window could not be created! SDL_error: ${sdlGetError()}");
//       return false;
//     }

//     renderer.value = sdlCreateRenderer(window.value, -1, SDL_RENDERER_ACCELERATED);
//     if(renderer == nullptr) {
//       print("renderer could not be initialized! SDL_Error: ${sdlGetError()}");
//       return false;
//     }

//     return true;
//   }

//   void clear(Pointer<SdlRenderer> renderer){
//     sdlSetRenderDrawColor(renderer, 0xff, 0xff, 0xff, 0xff);
//     sdlRenderClear(renderer);
//   }

//   void present(Pointer<SdlRenderer> renderer) {
//     sdlRenderPresent(renderer);
//   }

//   void drawRect(Pointer<SdlRenderer> renderer, Pointer<SdlRect> rect, SdlColor color) { 
//     sdlSetRenderDrawColor(renderer, color.r, color.g, color.b, color.a);
//     sdlRenderFillRect(renderer, rect);
//   }


//   void destroy(Pointer<SdlRenderer> renderer, Pointer<SdlWindow> window) {
//     sdlDestroyRenderer(renderer);
//     sdlDestroyWindow(window);
//     sdlQuit();
//   }


// }