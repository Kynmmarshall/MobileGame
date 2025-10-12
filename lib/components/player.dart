import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:game/components/checkpoint.dart';
import 'package:game/components/collision_block.dart';
import 'package:game/components/customHitBox.dart';
import 'package:game/components/fruit.dart';
import 'package:game/components/saw.dart';
import 'package:game/components/utils.dart';
import 'package:game/pixel_adventure.dart';

enum PlayerState {idle, running, jumping, falling, hit, appearing, disappearing}

class Player extends SpriteAnimationGroupComponent with 
HasGameReference<PixelAdventure>, KeyboardHandler , CollisionCallbacks{

String character;
Player({ 
  position, 
  this.character = "Ninja Frog",
  }): super(position: position);

late final SpriteAnimation idleAnimation, runningAnimation, fallingAnimation, hitAnimation, jumpingAnimation, appearingAnimation, disappearingAnimation;

final double stepTime=0.05;
final double _gravity = 15;
final double _jumpForce = 360;
final double _terminalVelocity = 300;


//PlayerDirection playerDirection = PlayerDirection.none;
double horizontalMovement = 0;
double moveSpeed = 100;
Vector2 velocity = Vector2(0, 0);
Vector2 startingPosition = Vector2.zero();
List<CollisionBlock> collisionBlocks = [];

customHitBox hitbox =customHitBox(
  offsetX: 10, 
  offsetY: 4,
   width: 14, 
   height: 28);

double fixedDeltaTime = 1/60;
double accumulatedTime = 0;

bool isonground = false;
bool hasjumped = false;
bool isfacingright = true;
bool gotHit = false;
bool isstart = true;
bool reachedCheckpoint = false;


// Loads Assets to the game (inbuilt function that can be modified)
  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    //debugMode = true;
    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: Vector2(hitbox.width, hitbox.height)
    ));
    return super.onLoad();
  } 

  //Updates the values of variables in the program (Inbuilt function would use it to midify player position)
  @override
  void update(double dt) {
    accumulatedTime +=dt;

    while(accumulatedTime>=fixedDeltaTime){
      if(!gotHit && !reachedCheckpoint){
    _updatePlayerState();
    _updatePosition(fixedDeltaTime);
    _checkHorizontalCollision();
    _applyGravity(fixedDeltaTime);
    _checkVerticalCollision();}
    accumulatedTime-=fixedDeltaTime;
    }
    
    if (isstart){
      startingPosition = Vector2(position.x, position.y) ;
      isstart = false;}
    super.update(dt);
  }

 @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
          keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
          keysPressed.contains(LogicalKeyboardKey.arrowRight);
    if (isLeftKeyPressed) {
    horizontalMovement = -1; // move left
  } else if (isRightKeyPressed) {
    horizontalMovement = 1;  // move right
  }
    hasjumped = keysPressed.contains(LogicalKeyboardKey.space); 
    //print(horizontalMovement);
    return super.onKeyEvent(event, keysPressed);
  } 

  void _loadAllAnimations() {
    idleAnimation= _CreateaAnimation('Idle', 11);
    runningAnimation= _CreateaAnimation('Run', 12);
    jumpingAnimation= _CreateaAnimation('Jump', 1);
    fallingAnimation= _CreateaAnimation('Fall', 1);
    hitAnimation= _CreateaAnimation('Hit', 7);
    appearingAnimation= _specialAnimation('Appearing', 7);
    disappearingAnimation= _specialAnimation('Disappearing', 7);
    

 // list of all animations 
 animations = {
  PlayerState.idle: idleAnimation,
  PlayerState.running: runningAnimation,
  PlayerState.jumping: jumpingAnimation,
  PlayerState.falling: fallingAnimation,
  PlayerState.hit: hitAnimation,
  PlayerState.appearing: appearingAnimation,
  PlayerState.disappearing: disappearingAnimation,
  };
  
  //set current animation
 current = PlayerState.idle;
  
 }

 @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if(!reachedCheckpoint)
    {if(other is Fruit) other.collidedWithPlayer();
    if(other is Saw) _respawn();
    if(other is Checkpoint && !reachedCheckpoint) _reachedChekpoint();}
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
 
 SpriteAnimation _specialAnimation(String name, int amount) {
    return SpriteAnimation.fromFrameData( game.images.fromCache('Main Characters/$name (96x96).png'), SpriteAnimationData.sequenced(
      amount: amount, 
      stepTime: stepTime, 
      textureSize: Vector2(96, 96),
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
  
  void _respawn() {
    gotHit = true;
    const animationsduration= const Duration(milliseconds: 400);
    current = PlayerState.hit;

    Future.delayed(animationsduration,
    () {
    scale.x = 1;
    position = startingPosition - Vector2.all(32);
    current = PlayerState.appearing;
    Future.delayed(animationsduration,
    () {
        velocity = Vector2.zero();
        position = startingPosition;
        _updatePlayerState();
        gotHit = false;
        Future.delayed(animationsduration,
    () {});
        });
  });
    
  }
  
  void _reachedChekpoint() {
    reachedCheckpoint = true;
    if(scale.x > 0){
    position = position - Vector2.all(32);}
    else if(scale.x < 0){
      position = position - Vector2(32,-32);
    }
    current = PlayerState.disappearing;
    Future.delayed(const Duration(milliseconds: 400),
    () {
      reachedCheckpoint = false;
      position = Vector2.all(-640);
      Future.delayed(const Duration(seconds: 3),
    () {scale.x = 1;
        game.loadNextLevel();
    });
    });
  }
  
  
  
  
}