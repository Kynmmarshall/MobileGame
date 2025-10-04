import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/services/keyboard_key.g.dart';
import 'package:game/pixel_adventure.dart';

enum PlayerState {idle, running}

enum PlayerDirection {Left, Right, None}

class Player extends SpriteAnimationGroupComponent with HasGameReference<PixelAdventure>, KeyboardHandler{

String Character;
Player({ position, required this.Character}): super(position: position);

late final SpriteAnimation idleAnimation,runningAnimation;
final double stepTime=0.05;

PlayerDirection playerDirection = PlayerDirection.Left;
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

  //for keyboard inputs
  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _getKeyboardInputs();
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
      case PlayerDirection.Left:
        if (isfacingright){
          flipHorizontallyAroundCenter();
          isfacingright= false;
        }
        dirX-=moveSpeed;
        current= PlayerState.running;
        break;
      case PlayerDirection.Right:
        if (!isfacingright){
          flipHorizontallyAroundCenter();
          isfacingright= true ;
        }
        dirX+=moveSpeed;
        current= PlayerState.running;
        break;
      case PlayerDirection.None:
        current= PlayerState.idle; 
        break;
      default: 
    }
    velocity= Vector2(dirX, 0.0);
    position += velocity * dt;
  }
  
  void _getKeyboardInputs() {}
}