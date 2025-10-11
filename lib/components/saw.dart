import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:game/pixel_adventure.dart';

class Saw extends SpriteAnimationComponent with HasGameReference<PixelAdventure>{
  
  final bool isvertical;
  final double offsetNeg;
  final double offsetPos;

  Saw({
    position,
    size,
    this.isvertical = false,
    this.offsetNeg = 0,
    this.offsetPos = 0,
  }
  ):super(
    position: position,
    size: size,  
  );

  final double sawSpeed=0.03;
  double moveSpeed = 80;
  static const tileSize = 16;
  double moveDirection = 1;
  double rangeNeg = 0;
  double rangePos = 0;

  @override
  FutureOr<void> onLoad() {
    priority = -1;
    add(CircleHitbox());
    if(isvertical){
      rangeNeg = position.y - tileSize * offsetNeg;
      rangePos = position.y + tileSize * offsetPos;
    }else{
      rangeNeg = position.x - tileSize * offsetNeg;
      rangePos = position.x + tileSize * offsetPos;
    }
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Traps/Saw/On (38x38).png'), 
      SpriteAnimationData.sequenced(
        amount: 8, 
        stepTime: sawSpeed, 
        textureSize: Vector2(38, 38))
        );
    return super.onLoad();
  }
  @override
  void update(double dt) {
    if(isvertical){
      _moveVertically(dt);
      }
    else{
      _moveHorizontally(dt);
      }
    super.update(dt);
  }
  
  void _moveVertically(double dt) {
    if (position.y >= rangePos ){
      moveDirection = -1;
    }
    else if (position.y <= rangeNeg ){
      moveDirection = 1;
    }
    position.y += moveDirection * moveSpeed * dt;
  }
  
  void _moveHorizontally(double dt) {
    if (position.x >= rangePos ){
      moveDirection = -1;
    }
    else if (position.x <= rangeNeg ){
      moveDirection = 1;
    }
    position.x += moveDirection * moveSpeed * dt;
  }
}