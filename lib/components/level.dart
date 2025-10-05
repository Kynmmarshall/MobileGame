import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:game/components/player.dart';

class Level extends World{

  final String levelName;
  final Player player;
  Level({required this.levelName, required this.player});

  late TiledComponent level;

  @override
  FutureOr<void> onLoad() async{
    level= await TiledComponent.load("$levelName.tmx", Vector2.all(16));
    
    add(level);
    
    final SpawnPointLayer=level.tileMap.getLayer<ObjectGroup>("SpawnPoints");
    
    for (final SpawnPoint in SpawnPointLayer!.objects){
      switch (SpawnPoint.class_){
        case 'Player':
          add(player);
          player.position = Vector2(SpawnPoint.x,SpawnPoint.y);
          break;
          default: 
      }
    }
    return super.onLoad();
  }
}