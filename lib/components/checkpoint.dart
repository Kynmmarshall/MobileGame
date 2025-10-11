import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:game/pixel_adventure.dart';

class Checkpoint extends SpriteAnimation with HasGameReference<PixelAdventure>{

  Checkpoint({
    position,
    size,
  }):super(
    position : position,
    size : size,
  );
}