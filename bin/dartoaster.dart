import 'package:dartoaster/engine/renderer.dart';
import 'package:dartoaster/engine/tools/primitive_drawing.dart';
import 'package:dartoaster/engine/text.dart';
import 'dart:ffi';
import 'dart:math';
import 'package:ffi/ffi.dart';
import 'package:sdl2/sdl2.dart';
import 'package:sdl2/sdl2gfx.dart' as gfx;

int main() {
  gfx.FpsManager fpsManager = gfx.FpsManager();

  fpsManager.setFramerate(60);

  if (sdlInit(SDL_INIT_VIDEO) != 0) {
    print(sdlGetError());
    return -1;
  }

  var imgFlags = IMG_INIT_PNG | IMG_INIT_JPG;

  if(imgInit(imgFlags) != imgFlags) {
    print(sdlGetError());
    sdlQuit();

    return -1;
  }

  ttfInit();

  Renderer engineRenderer = Renderer(600, 800);

  engineRenderer.init("Toaster | FPS: ${fpsManager.getFramerate()}");

  var lines = <Point<double>>[
    Point(320, 200),
    Point(300, 240),
    Point(340, 240),
    Point(320, 200)
  ];

  PrimitiveDrawing shape = PrimitiveDrawing(engineRenderer.getRenderer());

  Text debugText = Text();

  debugText.init("assets/Montserrat-Regular.ttf", 12);

  var event = calloc<SdlEvent>();
  var time = sdlGetTicks();
  var frameRate = 0;
  var frameCount = 0;

  Pointer<SdlTexture> texture = nullptr;

  var loadTexture = engineRenderer.getRenderer().loadTexture("assets/player.png");

  if(loadTexture == nullptr) {
    print("Cannot load texture");
    return 1;
  }

  texture = loadTexture;

  var running = true;
  while (running) {
    while (event.poll() != 0) {
      switch (event.type) {
        case SDL_QUIT:
          running = false;
          break;
        default:
          break;
      }
    }

    fpsManager.delay();
    if ((sdlGetTicks() - time) > 1000) {
      frameRate = frameCount;
      frameCount = 0;
      time = sdlGetTicks();
    } else {
      frameCount++;
    }

    print(frameRate);

    engineRenderer.clear();

    if(texture != nullptr) {
      engineRenderer.getRenderer().copy(texture);
    }

    debugText.render(
        engineRenderer.getRenderer(), "Toaster is toasting", 10.0, 10.0);
    debugText.render(engineRenderer.getRenderer(),
        "FPS: ${frameRate}", 10.0, 40.0);
    debugText.render(engineRenderer.getRenderer(),
        "Frame Count: ${fpsManager.getFramecount()}", 10.0, 70.0);

    shape.draw(points: lines);
    shape.createBox();

    engineRenderer.present();
  }
  
  gfx.gfxFree();
  event.callocFree();
  debugText.destroy();
  engineRenderer.getRenderer().destroy();
  sdlQuit();
  return 0;
}

// int main(List<String> arguments) {
//   Pointer<SdlWindow> window = nullptr;
//   Pointer<SdlRenderer> renderer = nullptr;

//   Renderer engineRenderer = Renderer();

//   if(!engineRenderer.init(calloc(renderer.address), calloc(window.address), "The Toaster", 600, 800)){ 
//     return 1;
//   }

//   if(renderer == nullptr) {
//     print("memek");
//   }

//   Text debugText = Text();
//   if(!debugText.init("assets/Montserrat-Regular.ttf", 12)) {
//     renderer.destroy();

//     return 1;
//   }

//   bool quit = false;
//   Pointer<SdlEvent> e = malloc<SdlEvent>();

//   while(!quit) {
//     while(sdlPollEvent(e) != 0) { 
//       if(e.type == SDL_QUIT) {
//         quit = true;
//       }
//     }

//     engineRenderer.clear(renderer);
//     engineRenderer.present(renderer);

//     final textColor = calloc<SdlColor>();

//     textColor.ref.r = 0x00;
//     textColor.ref.g = 0x00;
//     textColor.ref.b = 0x00;
//     textColor.ref.a = 0xff;

//     debugText.render(renderer, "Hello Toaster", 10, 10, textColor.ref);
//   }

//   malloc.free(e);
//   engineRenderer.destroy(renderer, window);

//   return 0;
// }
