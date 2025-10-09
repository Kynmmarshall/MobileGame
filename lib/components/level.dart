import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:game/components/Background_tile.dart';
import 'package:game/components/collision_block.dart';
import 'package:game/components/fruit.dart';
import 'package:game/components/player.dart';
import 'package:game/pixel_adventure.dart';

class Level extends World with HasGameReference<PixelAdventure>{

  final String levelName;
  final Player player;
  Level({required this.levelName, required this.player});

  late TiledComponent level;
  List<CollisionBlock> collisionBlocks = [];

  @override
  FutureOr<void> onLoad() async{
    level= await TiledComponent.load("$levelName.tmx", Vector2.all(16));
    add(level);

   _scrollingBackground();
   _spawningObject();
   _addCollisions();
    
    return super.onLoad();
  }
  
  void _scrollingBackground() {
    final backgroundLayer = level.tileMap.getLayer("Background");
    
    const tileSize = 64;
    final numTilesY = (game.size.y / tileSize).ceil();
    final numTilesX = (game.size.x / tileSize).ceil();
    
    if (backgroundLayer != null){
        final backgroundColor = backgroundLayer.properties.getValue('BackgroundColor');

        for (double y = 0; y < game.size.y / numTilesY ; y++){
          for (double x = 0; x < numTilesX  ; x++){
            final backgroundTile = BackgroundTile(
          color: backgroundColor ?? 'Gray',
          position: Vector2(x * tileSize, y * tileSize - tileSize),
        );
        add(backgroundTile);
        }
        }

        
    }

  }
  
  void _spawningObject() {
    final SpawnPointLayer=level.tileMap.getLayer<ObjectGroup>("SpawnPoints");
    
    if (SpawnPointLayer != null)
    {
      for (final SpawnPoint in SpawnPointLayer.objects){
      switch (SpawnPoint.class_){
        case 'Player':
          add(player);
          player.position = Vector2(SpawnPoint.x,SpawnPoint.y);
          break;
        case 'Fruits':
          final fruits = Fruit(
          fruit: SpawnPoint.name,
          position: Vector2(SpawnPoint.x,SpawnPoint.y),
          size: Vector2(SpawnPoint.width,SpawnPoint.height),
          );
          add(fruits);
          break;
        default: 
      
      }
    }
    }

  }
  
  void _addCollisions() {
    final collisionsLayers = level.tileMap.getLayer<ObjectGroup>('Collisions');
    if (collisionsLayers != null)
    {
      for (final collision in collisionsLayers.objects){
      switch (collision.class_){
        case 'Platform':
          final platform = CollisionBlock(
            position: Vector2(collision.x, collision.y),
            size: Vector2(collision.width, collision.height),
            isPlatform: true,
          );
          collisionBlocks.add(platform);
          add(platform);
          break;
          default: 
          final block = CollisionBlock(
            position: Vector2(collision.x, collision.y),
            size: Vector2(collision.width, collision.height),
          );
          collisionBlocks.add(block);
          add(block);
      }
    }
    }
    player.collisionBlocks = collisionBlocks;
  }
}