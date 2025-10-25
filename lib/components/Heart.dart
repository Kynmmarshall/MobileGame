import 'dart:async';
import 'package:flame/components.dart';
import 'package:game/pixel_adventure.dart';

class Heart extends SpriteComponent with HasGameReference<PixelAdventure>{
  
  Heart({
  position,
    size,
}):super(
    position: position ,
    size: size ,
  );

  @override
  FutureOr<void> onLoad() {
   // priority = 100000000;
    sprite = Sprite(game.images.fromCache('Items/Heart/3.png'));     
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
        sprite = Sprite(game.images.fromCache('Items/Heart/1.png'));
        break;
      case 2:
        sprite = Sprite(game.images.fromCache('Items/Heart/2.png'));
        break;
      case 3:
        sprite = Sprite(game.images.fromCache('Items/Heart/3.png'));
        break;
      default:
    }
  }
}