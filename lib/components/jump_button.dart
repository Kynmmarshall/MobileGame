import 'dart:async';
import 'package:flame/components.dart';
import 'package:game/pixel_adventure.dart';

class JumpButton extends SpriteComponent with HasGameReference<PixelAdventure>{
  JumpButton();

  final margin = 32;
  final buttonSize = 64;

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache('Joystick components/jumpButton.png'));
    position = Vector2(
      game.size.x - margin - buttonSize,
      game.size.y  - margin - buttonSize,  
      );
    return super.onLoad();
  }
}