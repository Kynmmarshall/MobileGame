import 'dart:async';
import 'package:flame/components.dart';
import 'package:game/pixel_adventure.dart';

class Heart extends SpriteAnimationComponent with HasGameReference<PixelAdventure>{
  final double stepTime = 0.2;
  Heart({
  position,
    size,
}):super(
    position: position ,
    size: size ,
  );

  @override
  FutureOr<void> onLoad() {
    _changeImages();    
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _changeImages();
    super.update(dt);
  }
  
  void _changeImages() {
    switch (game.lives){
      case 1:
        animation = _createAnimation(1 , 3);
        break;
      case 2:
        animation = _createAnimation(2 , 3);
        break;
      case 3:
        animation = _createAnimation(3 , 3);
        break;
      default:
        animation = _createAnimation(0 , 1);
    }
  }
  
  SpriteAnimation _createAnimation(int i, int amount) {
    return SpriteAnimation.fromFrameData( game.images.fromCache('Items/Heart/$i.png'), SpriteAnimationData.sequenced(
      amount: amount, 
      stepTime: stepTime, 
      textureSize: Vector2(144, 48),
      ),
      ); 
  }
}