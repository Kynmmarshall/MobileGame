import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:game/components/player.dart';
import 'package:game/pixel_adventure.dart';

class Checkpoint extends SpriteAnimationComponent  with HasGameReference<PixelAdventure>, CollisionCallbacks{

  Checkpoint({
    position,
    size,
  }) : super(
    position : position,
    size : size,
  );
 
  bool reachedChekpoint = false;

 @override
  FutureOr<void> onLoad() {
    //debugMode = true;
    add(RectangleHitbox(
      position: Vector2(15, 88),
      size: Vector2(20,8),
      collisionType: CollisionType.passive
    ));
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

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if(other is Player && !reachedChekpoint){
      _reachedChekpoint();
    }
    super.onCollision(intersectionPoints, other);
  }
  
  void _reachedChekpoint() {
    reachedChekpoint = true;
    animation= SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Checkpoints/Checkpoint/Checkpoint (Flag Out) (64x64).png'), 
      SpriteAnimationData.sequenced(
        amount: 26, 
        stepTime: 0.04, 
        textureSize: Vector2.all(64),
        loop: false
        )
        );
    const flagDuration = Duration(milliseconds: 1040);
    Future.delayed(flagDuration, (){
      animation= SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Checkpoints/Checkpoint/Checkpoint (Flag Idle)(64x64).png'), 
      SpriteAnimationData.sequenced(
        amount: 10, 
        stepTime: 0.04, 
        textureSize: Vector2.all(64),
        )
        );
        Future.delayed(const Duration(seconds:4), (){
            removeFromParent();
        });
    });
  
  }

}
