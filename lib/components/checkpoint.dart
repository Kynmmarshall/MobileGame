import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:game/pixel_adventure.dart';

class Checkpoint extends SpriteAnimationComponent  with HasGameReference<PixelAdventure>{

  Checkpoint({
    position,
    size,
  }) : super(
    position : position,
    size : size,
  );
 
 @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox());
    animation= SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Checkpoints/Checkpoint/Checkpoint (No Flag).png'), 
      SpriteAnimationData.sequenced(
        amount: 1, 
        stepTime: 1, 
        textureSize: Vector2.all(64),
        )
        );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);
  }


}