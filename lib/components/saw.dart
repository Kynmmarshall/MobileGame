import 'package:flame/components.dart';
import 'package:game/pixel_adventure.dart';

class Saw extends SpriteAnimationComponent with HasGameReference<PixelAdventure>{
  Saw({
    position,
    size,
  }
  ):super(
    position: position,
    size: size,
  );
}