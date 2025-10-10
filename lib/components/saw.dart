import 'dart:async';

import 'package:flame/components.dart';
import 'package:game/pixel_adventure.dart';

class Saw extends SpriteAnimationComponent with HasGameReference<PixelAdventure>{
  Saw({
    position ,
    size ,
  }
  ):super(
    position: position ,
    size: size , 
  );

  final double stepTime=0.05;

  @override
  FutureOr<void> onLoad() {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Traps/Saw/On (38x38).png'), 
      SpriteAnimationData.sequenced(
        amount: 8, 
        stepTime: stepTime, 
        textureSize: Vector2(38, 38))
        );
    return super.onLoad();
  }
}