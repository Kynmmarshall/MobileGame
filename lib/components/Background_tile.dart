import 'dart:async';

import 'package:flame/components.dart';

class BackgroundTile extends SpriteComponent with HasGameReference{
  final String color;
  BackgroundTile({
    this.color = 'Gray', 
  position}):super(
    position: position);

  @override
  FutureOr<void> onLoad() {
    size = Vector2.all(64);
    sprite = Sprite(game.images.fromCache(('Backgroubd/$color.png                       ')));
    return super.onLoad();
  }
}