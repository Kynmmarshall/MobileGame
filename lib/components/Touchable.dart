import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:game/pixel_adventure.dart';

class Touchable extends SpriteAnimationComponent with HasGameReference<PixelAdventure>, TapCallbacks{

  String? type;
  final double stepTime = 0.3;
  final amount = 3;
  Vector2 spriteSize = Vector2(48, 48);
  
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
    if(type == 'Home' || type == 'Exit'){
    animation = SpriteAnimation.fromFrameData( game.images.fromCache('Terrain/Touchables/$type.png'), SpriteAnimationData.sequenced(
      amount: amount, 
      stepTime: stepTime, 
      textureSize: Vector2(48, 48),
      ),
      );
      }
    return super.onLoad();
  }


  @override
  void onTapDown(TapDownEvent event) {
    switch(type){
      case 'Play':
        _startGame();
        break;
      case 'Exit':
        game.exitGame();
        break;
      case 'Home':
        game.menu_screen = true;
        game.play = false;
        game.currentLevelIndex = -1;
        game.loadNextLevel();
        break;
      case 'Credits':
        game.menu_screen = false;
        game.currentLevelIndex = 0;
        game.loadNextLevel();
        break;
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
