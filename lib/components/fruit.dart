import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
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
  bool Collected = false;
  @override
  FutureOr<void> onLoad() {

    add(RectangleHitbox(
      position:Vector2(fruitHitBox.offsetX, fruitHitBox.offsetY),
      size: Vector2(fruitHitBox.width, fruitHitBox.width ),
      collisionType: CollisionType.passive,
    ));
    priority = -1;
    //debugMode = true;
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
  
  void collidedWithPlayer() async{
    
    if(!Collected){
      Collected = true;

      await Future.delayed(const Duration(milliseconds: 1));
      
      //if(game.playsound) game.playCollectSound();
      animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Fruits/Collected.png'), 
      SpriteAnimationData.sequenced(
      amount: 6, 
      stepTime: stepTime, 
      textureSize: Vector2(32, 32),
      loop: false
      ),
      );
    await Future.delayed(const Duration(milliseconds: 10));
    await animationTicker?.completed;
    removeFromParent();
    }
  
  }

   

}