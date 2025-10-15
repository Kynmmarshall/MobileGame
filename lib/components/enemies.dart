import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:game/pixel_adventure.dart';

class Enemies extends SpriteAnimationComponent with HasGameReference<PixelAdventure>,
CollisionCallbacks{
  final String enemy;
  Enemies({
    this.enemy = 'Chicken',
    position,
    size,
    offsetNeg,
    offsetPos,
}):super(
    position: position,
    size: size,
  );
  final double stepTime = 0.05;

  @override
  FutureOr<void> onLoad() {
    debugMode = true;
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('assets/images/Enemies/$enemy/Idle (32x34).png'), 
      SpriteAnimationData.sequenced(
      amount: 13, 
      stepTime: stepTime, 
      textureSize: Vector2(32, 34),
      ),
      );
    return super.onLoad();
  }

}