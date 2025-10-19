import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:game/pixel_adventure.dart';

enum State { idle, run, hit}
class Enemies extends SpriteAnimationGroupComponent with HasGameReference<PixelAdventure>{
  
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

  final double stepTime = 0.05;
  double rangeNeg = 0;
  double rangePos = 0;
  static const tileSize = 16;

  @override
  FutureOr<void> onLoad() {
    debugMode = true;
    _loadAllAnimations(); 
    _calculateRange();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _movement();
    super.update(dt);
  }

  
  late final SpriteAnimation _idleAnimation, _runAnimation, _hitAnimation; 


  void _loadAllAnimations() {
    _idleAnimation = _CreateaAnimation('idle', 13);
    _runAnimation = _CreateaAnimation('run', 14); 
    _hitAnimation = _CreateaAnimation('hit', 15)..loop = false;

     animations ={
      State.idle : _idleAnimation,
      State.hit : _hitAnimation,
      State.run : _runAnimation
    };
    current = State.idle;
  }

  SpriteAnimation _CreateaAnimation(String animation, int amount){
    return SpriteAnimation.fromFrameData( game.images.fromCache('Enemies/$enemy/$animation (32x34).png'), SpriteAnimationData.sequenced(
      amount: amount, 
      stepTime: stepTime, 
      textureSize: Vector2(32, 34),
      ),
      );
 }
 
  void _movement() {}

  void _calculateRange(){
    rangeNeg = position.x - tileSize * offsetNeg;
    rangePos = position.x + tileSize * offsetPos;
  }

}