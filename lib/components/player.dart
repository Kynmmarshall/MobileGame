import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:game/components/collision_block.dart';
import 'package:game/components/customHitBox.dart';
import 'package:game/components/fruit.dart';
import 'package:game/components/utils.dart';
import 'package:game/pixel_adventure.dart';

enum PlayerState {idle, running, jumping, falling}

class Player extends SpriteAnimationGroupComponent with 
HasGameReference<PixelAdventure>, KeyboardHandler , CollisionCallbacks{

String character;
Player({ 
  position, 
  this.character = "Ninja Frog",
  }): super(position: position);

late final SpriteAnimation idleAnimation, runningAnimation, jumpingAnimation, fallingAnimation;

final double stepTime=0.05;
final double _gravity = 15;
final double _jumpForce = 300;
final double _terminalVelocity = 300;


//PlayerDirection playerDirection = PlayerDirection.none;
double horizontalMovement = 0;
double moveSpeed = 100;
Vector2 velocity = Vector2(0, 0);
List<CollisionBlock> collisionBlocks = [];

customHitBox hitbox =customHitBox(
  offsetX: 10, 
  offsetY: 4,
   width: 14, 
   height: 28);

bool isonground = false;
bool hasjumped = false;
bool isfacingright = true;

// Loads Assets to the game (inbuilt function that can be modified)
  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    debugMode = true;
    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: Vector2(hitbox.width, hitbox.height)
    ));
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
    horizontalMovement = 0;
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
          keysPressed.contains(LogicalKeyboardKey.keyA);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
          keysPressed.contains(LogicalKeyboardKey.keyD);
    
     if (isLeftKeyPressed && isRightKeyPressed) {
    horizontalMovement = 0; // Cancel if both pressed
  } else if (isLeftKeyPressed) {
    horizontalMovement = -1;
  } else if (isRightKeyPressed) {
    horizontalMovement = 1;
  } else {
    horizontalMovement = 0;
  }

    hasjumped = keysPressed.contains(LogicalKeyboardKey.space); 

    return super.onKeyEvent(event, keysPressed);
  }

  void _loadAllAnimations() {
    idleAnimation=_CreateaAnimation('Idle', 11);
    runningAnimation= _CreateaAnimation('Run', 12);
    jumpingAnimation= _CreateaAnimation('Jump', 1);
    fallingAnimation= _CreateaAnimation('Fall', 1);

 // list of all animations 
 animations = {
  PlayerState.idle: idleAnimation,
  PlayerState.running: runningAnimation,
  PlayerState.jumping: jumpingAnimation,
  PlayerState.falling: fallingAnimation,
  };
  
  //set current animation
 current = PlayerState.idle;
  
 }

 @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if(other is Fruit) {
      print("COLL");
    }
    super.onCollision(intersectionPoints, other);
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
    if (velocity.x > 0 || velocity.x < 0) playerState = PlayerState.running;

    //Check if falling set to falling
    if (velocity.y > 0) playerState = PlayerState.falling;

    //Check if jumping set to jumping
    if (velocity.y < 0) playerState = PlayerState.jumping;

    current = playerState;
  }

  void _updatePosition(double dt) {
    if (hasjumped && isonground){
         _playerjump(dt);
    }

    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }
  
  void _checkHorizontalCollision() 
  {
    for (final blocks in collisionBlocks){
      if (!blocks.isPlatform) {
        if(checkCollision(this , blocks)){
          if (velocity.x > 0){
            velocity.x = 0;
            position.x = blocks.x - hitbox.offsetX - hitbox.width;
            break;
          }else if (velocity.x < 0){
            velocity.x = 0;
            position.x = blocks.x + blocks.width + hitbox.width+ hitbox.offsetX;
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
          if(checkCollision(this , blocks)){
            if (velocity.y > 0){
            velocity.y = 0;
            position.y = blocks.y - hitbox.height - hitbox.offsetY;
            isonground = true;  
            break;
          }
          }
      }
      else{  
        if(checkCollision(this , blocks)){
          if (velocity.y > 0){
            velocity.y = 0;
            position.y = blocks.y - hitbox.height - hitbox.offsetY;
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