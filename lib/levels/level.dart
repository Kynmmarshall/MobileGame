import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:game/actors/player.dart';

class Level extends World{

  final String levelName;
  Level({required this.levelName});

  late TiledComponent level;

  @override
  FutureOr<void> onLoad() async{
    level= await TiledComponent.load("$levelName.tmx", Vector2.all(16));
    
    add(level);
    
    final SpawnPointLayer=level.tileMap.getLayer<ObjectGroup>("SpawnPoints");
    
    for (final SpawnPoint in SpawnPointLayer!.objects){
      switch (SpawnPoint.class_){
        case 'Player':
          final player = Player(Character: 'Ninja Frog', position: Vector2(SpawnPoint.x,SpawnPoint.y ));
          add(player);
          break;
          default:
      }
    }
    return super.onLoad();
  }
}