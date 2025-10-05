import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:game/pixel_adventure.dart';

enum PlayerState {idle, running}

enum PlayerDirection {left, right, none}

class Player extends SpriteAnimationGroupComponent with HasGameReference<PixelAdventure>, KeyboardHandler{

String Character;
Player({ position, required this.Character}): super(position: position);

late final SpriteAnimation idleAnimation,runningAnimation;
final double stepTime=0.05;

PlayerDirection playerDirection = PlayerDirection.none;
double moveSpeed = 100;
Vector2 velocity = Vector2(0, 0);
bool isfacingright = true;

// Loads Assets to the game (inbuilt function that can be modified)
  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    return super.onLoad();
  }

  //Updates the values of variables in the program (Inbuilt function would use it to midify player position)
  @override
  void update(double dt) {
    _updatePosition(dt);
    super.update(dt);
  }

 @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
          keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
          keysPressed.contains(LogicalKeyboardKey.arrowRight);
    
    if(isRightKeyPressed && isLeftKeyPressed){
      playerDirection = PlayerDirection.none;
    }else if (isRightKeyPressed){
      playerDirection = PlayerDirection.right;
    }else if (isLeftKeyPressed){
      playerDirection = PlayerDirection.left;
    }
    else{
      playerDirection = PlayerDirection.none;
    }
    return super.onKeyEvent(event, keysPressed);
  }

  void _loadAllAnimations() {
    idleAnimation=_CreateaAnimation('Idle', 11);
    runningAnimation= _CreateaAnimation('Run', 12);

 // list of all animations 
 animations = {
  PlayerState.idle: idleAnimation,
  PlayerState.running: runningAnimation,};
  
  //set current animation
  current = PlayerState.idle;
  
 }

 SpriteAnimation _CreateaAnimation(String animation, int amount){
    return SpriteAnimation.fromFrameData( game.images.fromCache('Main Characters/$Character/$animation (32x32).png'), SpriteAnimationData.sequenced(
      amount: amount, 
      stepTime: stepTime, 
      textureSize: Vector2(32, 32),
      ),
      );
 }
 
  void _updatePosition(double dt) {

    double dirX = 0.0;
    switch (playerDirection) {
      case PlayerDirection.left:
        if (isfacingright){
          flipHorizontallyAroundCenter();
          isfacingright= false;
        }
        current= PlayerState.running;
        dirX-=moveSpeed;
        break;
      case PlayerDirection.right:
        if (!isfacingright){
          flipHorizontallyAroundCenter();
          isfacingright= true ;
        }
        current= PlayerState.running;
        dirX+=moveSpeed;
        break;
      case PlayerDirection.none:
        current= PlayerState.idle; 
        break;
      default: 
    }
    velocity= Vector2(dirX, 0.0);
    position += velocity * dt;
  }
}