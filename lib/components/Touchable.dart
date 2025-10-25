import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:game/pixel_adventure.dart';

class Touchable extends SpriteAnimationComponent with HasGameReference<PixelAdventure>, TapCallbacks{

  String? type;
  final stepTime = 0.05;
  final amount = 6;
  Touchable({
    position,
    size,
    this.type,
  }): super(
      position: position, 
      size: size);
  
  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox());
    animation = SpriteAnimation.fromFrameData( game.images.fromCache('Terrain/Touchables/$type.png'), SpriteAnimationData.sequenced(
      amount: amount, 
      stepTime: stepTime, 
      textureSize: Vector2(32, 32),
      ),
      );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    
    super.update(dt);
  }

  @override
  void onTapDown(TapDownEvent event) {
    switch(type){
      case 'Play':
        _startGame();
        break;
      case 'Exit':
        game.exitGame();
      case 'Home':
        game.menu_screen = true;
        game.play = false;
        game.currentLevelIndex = -1;
        game.loadNextLevel();
      case 'Credits':
        game.currentLevelIndex = 0;
        game.loadNextLevel();
      default:
    }
    super.onTapDown(event);
  }

  void _startGame() {
    if (game.play) return;
    game.play = true;
    game.menu_screen = false;
    game.currentLevelIndex = 1;
    game.loadNextLevel();
    print("Play button tapped - starting game");
  }

}
