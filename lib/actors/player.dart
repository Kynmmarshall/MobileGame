import 'dart:async';

import 'package:flame/components.dart';
import 'package:game/pixel_adventure.dart';

enum PlayerState {idle, running}

class Player extends SpriteAnimationGroupComponent with HasGameReference<PixelAdventure>{

String Character;
Player({required this.Character});

late final SpriteAnimation idleAnimation,runningAnimation;
final double stepTime=0.05;

@override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    return super.onLoad();
  }
  
  void _loadAllAnimations() {
    idleAnimation=_CreateaAnimation('Idle', 11);
    runningAnimation= _CreateaAnimation('Run', 12);

 // list of all animations
 animations = {
  PlayerState.idle: idleAnimation,
  PlayerState.running: runningAnimation,};
  
  //set current animation
  current= PlayerState.idle;
 }

 SpriteAnimation _CreateaAnimation(String animation, int amount){
    return SpriteAnimation.fromFrameData( game.images.fromCache('Main Characters/$Character/$animation (32x32).png'), SpriteAnimationData.sequenced(
      amount: amount, 
      stepTime: stepTime, 
      textureSize: Vector2(32, 32),
      ),
      );
 }
}