import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:game/actors/player.dart';

class Level extends World{

  late TiledComponent level;

  @override
  FutureOr<void> onLoad() async{
    level= await TiledComponent.load("Level-01.tmx", Vector2.all(16));
    
    add(level);
    add(Player(Character: 'Ninja Frog'));
    return super.onLoad();
  }
}