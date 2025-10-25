import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:game/components/player.dart';
import 'package:game/pixel_adventure.dart';

enum State { idle, run, hit}
class Enemies extends SpriteAnimationGroupComponent 
with HasGameReference<PixelAdventure>, CollisionCallbacks{
  
  final String enemy;
  final double offsetNeg;
  final double offsetPos;
  Enemies({
    this.enemy = 'Chicken',
    super.position,
    super.size,
    this.offsetNeg = 0,
    this.offsetPos = 0,
});

  static const stepTime = 0.05;
  static const runSpeed = 80;
  static const tileSize = 16;
  static const double _bounceHeight = 300;

  late final Player player;

  Vector2 velocity = Vector2.zero();
  double rangeNeg = 0;
  double rangePos = 0;
  double moveDirection = 1;
  double targetDirection = -1;
  bool gotStumped = false;


  @override
  FutureOr<void> onLoad() {
    //debugMode = true;
    player = game.player;
    add(
      RectangleHitbox(
        position: Vector2(4, 6),
        size: Vector2(24, 26),
      )
    );
    print('Loading enemy: $enemy');
    _loadAllAnimations(); 
    _calculateRange();
    print('Enemy loaded at position: $position, range: $rangeNeg to $rangePos');
    return super.onLoad();
  }

  @override
  void update(double dt) {
   if (!gotStumped) {_updateState();
    _movement(dt);}
    super.update(dt);
  }

  
  late final SpriteAnimation _idleAnimation, _runAnimation, _hitAnimation; 


  void _loadAllAnimations() {
    _idleAnimation = _CreateaAnimation('Idle', 13);
    _runAnimation = _CreateaAnimation('Run', 14); 
    _hitAnimation = _CreateaAnimation('Hit', 5)..loop = false;

     animations ={
      State.idle : _idleAnimation,
      State.hit : _hitAnimation,
      State.run : _runAnimation
    };
    current = State.idle;
    print('Animations loaded for $enemy');
  }

  SpriteAnimation _CreateaAnimation(String animation, int amount){
    return SpriteAnimation.fromFrameData( game.images.fromCache('Enemies/$enemy/$animation (32x34).png'), SpriteAnimationData.sequenced(
      amount: amount, 
      stepTime: stepTime, 
      textureSize: Vector2(32, 34),
      ),
      );
 }
 

  void _calculateRange(){
    rangeNeg = position.x - offsetNeg * tileSize;
    rangePos = position.x + offsetPos * tileSize;
  }

  void _movement(dt) {
    //set default velocity to Zero
    velocity.x = 0;

    double playerOffset = (player.scale.x > 0)? 0 : -player.width;
    double enemyOffset = (scale.x > 0)? 0 : -width;
    

    if(playerInrange()){
      // determines where player is then follow him
      targetDirection = (player.x + playerOffset < position.x + enemyOffset)? -1 : 1; 
      velocity.x = targetDirection * runSpeed;
    }
    moveDirection = lerpDouble(moveDirection, targetDirection, 0.1) ?? 1;
    
    position.x += velocity.x * dt;
  }


  // method to check if player is in the chicken area or not
  bool playerInrange(){
    double playerOffset = (player.scale.x > 0)? 0 : -player.width;
    
     return player.x + playerOffset >= rangeNeg && 
           player.x + playerOffset <= rangePos &&
          player.y + player.height > position.y &&
          player.y < position.y + height;
  }
  
  // determines whether player must run or stay idle
  void _updateState() {
    current = (velocity.x != 0 ) ? State.run : State.idle;
  
    if ((moveDirection > 0 && scale.x > 0) || (moveDirection < 0 && scale.x < 0)){
      flipHorizontallyAroundCenter();
    }
  }

  void collidedWithPlayer()  async{
    if(player.velocity.y > 0 && player.y + player.height > position.y){
      if(game.playsound){
        game.playBounceSound();
      }
      gotStumped = true;
      current = State.hit;
      player.velocity.y = -_bounceHeight;
      
      await animationTicker ?.completed;
      removeFromParent();
    }else{
      player.collidedWithEnemy();
      game.lives-=1;
    }
  }

}