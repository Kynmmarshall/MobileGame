import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:game/components/collision_block.dart';
import 'package:game/components/utils.dart';
import 'package:game/pixel_adventure.dart';

enum PlayerState {idle, running}

class Player extends SpriteAnimationGroupComponent with 
HasGameReference<PixelAdventure>, KeyboardHandler{

String character;
Player({ 
  position, 
  this.character = "Ninja Frog",
  }): super(position: position);

late final SpriteAnimation idleAnimation,runningAnimation;
final double stepTime=0.05;

final double _gravity = 13;
final double _jumpForce = 260;
final double _terminalVelocity = 300;


//PlayerDirection playerDirection = PlayerDirection.none;
double horisontalMovement = 0;
double moveSpeed = 100;
Vector2 velocity = Vector2(0, 0);
List<CollisionBlock> collisionBlocks = [];
bool isonground = false;
bool hasjumped = false;
bool isfacingright = true;

// Loads Assets to the game (inbuilt function that can be modified)
  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    debugMode = true;
    return super.onLoad();
  }

  //Updates the values of variables in the program (Inbuilt function would use it to midify player position)
  @override
  void update(double dt) {
    _updatePlayerState();
    _updatePosition(dt);
    _checkHorizontalCollision();
    _applyGravity(dt);
    _checkVerticalCollision();
    super.update(dt);
  }

 @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horisontalMovement = 0;
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
          keysPressed.contains(LogicalKeyboardKey.keyA);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
          keysPressed.contains(LogicalKeyboardKey.keyD);
    
    horisontalMovement += isLeftKeyPressed ? -1:0;
    horisontalMovement += isRightKeyPressed ? 1:0;

    hasjumped = keysPressed.contains(LogicalKeyboardKey.space); 

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
    return SpriteAnimation.fromFrameData( game.images.fromCache('Main Characters/$character/$animation (32x32).png'), SpriteAnimationData.sequenced(
      amount: amount, 
      stepTime: stepTime, 
      textureSize: Vector2(32, 32),
      ),
      );
 }
 
  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;

    if(velocity.x < 0 && scale.x > 0){
      flipHorizontallyAroundCenter();
    }else if (velocity.x > 0 && scale.x < 0){
      flipHorizontallyAroundCenter();
    }

    //check if moving then create animation
    if (velocity.x > 0 || velocity.x < 0) playerState =PlayerState.running;

    current = playerState;
  }

  void _updatePosition(double dt) {
    if (hasjumped && isonground){
         _playerjump(dt);
    }

    velocity.x = horisontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }
  
  void _checkHorizontalCollision() 
  {
    for (final blocks in collisionBlocks){
      if (!blocks.isPlatform) {
        if(checkCollision(this , blocks)){
          if (velocity.x > 0){
            velocity.x = 0;
            position.x = blocks.x - width;
            break;
          }else if (velocity.x < 0){
            velocity.x = 0;
            position.x = blocks.x + blocks.width + width;
            break;
          }
        }
      }
    }
  }
  
  void _applyGravity(double dt) {
    
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(-_jumpForce, _terminalVelocity);
    position.y += velocity.y * dt;

  }
  
  void _playerjump(double dt) {
    velocity.y = -_jumpForce;
    position.y += velocity.y * dt;
    hasjumped = false;
    isonground = false;
  }

  void _checkVerticalCollision() {
    for (final blocks in collisionBlocks){
      if (blocks.isPlatform) {

      }
      else{
        if(checkCollision(this , blocks)){
          if (velocity.y > 0){
            velocity.y = 0;
            position.y = blocks.y - height;
            isonground = true;
            break;
          }
          else if(velocity.y < 0){
            velocity.y = 0;
            position.y = blocks.y + blocks.height;
            break;
          }
        }
      }
    }
  

  }
  
  
}