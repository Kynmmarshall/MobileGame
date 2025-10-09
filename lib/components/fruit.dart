import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:game/components/customHitBox.dart';
import 'package:game/pixel_adventure.dart';


class Fruit extends SpriteAnimationComponent with HasGameReference<PixelAdventure>,
CollisionCallbacks{
    final String fruit;
    Fruit({
      this.fruit = 'Apple' ,
      position , 
      size}) : 
      super(
        position: position, 
        size: size);

  final double stepTime = 0.05;
  
  customHitBox fruitHitBox = customHitBox(
    offsetX: 10,
    offsetY: 10, 
    width: 12, 
    height: 12); 

  @override
  FutureOr<void> onLoad() {

    add(RectangleHitbox(
      position:Vector2(fruitHitBox.offsetX, fruitHitBox.offsetY),
      size: Vector2(fruitHitBox.width, fruitHitBox.width ),
      collisionType: CollisionType.passive,
    ));
    priority = -1;
    debugMode = true;
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Fruits/$fruit.png'), 
      SpriteAnimationData.sequenced(
      amount: 17, 
      stepTime: stepTime, 
      textureSize: Vector2(32, 32),
      ),
      );
    return super.onLoad();
  }
  
  void collidedWithPlayer() {
    
  }

   

}