import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/services.dart';
import 'package:game/pixel_adventure.dart';

class CollisionBlock extends PositionComponent 
with HasGameReference<PixelAdventure>, TapCallbacks {
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
  
  @override
  void onTapDown(TapDownEvent event) {
    switch(type){
      case 'Play':
        _startGame();
        break;
      case 'Exit':
        game.exitGame();
      case 'Home':
        game.menu_screen = true;
        game.play = false;
        game.currentLevelIndex = -1;
        game.loadNextLevel();
      case 'Credits':
        game.currentLevelIndex = 0;
        game.loadNextLevel();
      default:
    }
    super.onTapDown(event);
  }

  void _startGame() {
    if (game.play) return;
    game.play = true;
    game.menu_screen = false;
    game.currentLevelIndex = 1;
    game.loadNextLevel();
    print("Play button tapped - starting game");
  }

  
  }    