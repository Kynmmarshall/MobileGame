import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/services.dart';
import 'package:game/pixel_adventure.dart';

class CollisionBlock extends PositionComponent 
with HasGameReference<PixelAdventure>{
  bool isPlatform;
  String? type;
  CollisionBlock({
    position, 
    size,
    this.isPlatform = false,
    this.type,
    }) : super(
      position: position, 
      size: size); //{debugMode = true;}

  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox());
    return super.onLoad();
  }
  
  
  }    