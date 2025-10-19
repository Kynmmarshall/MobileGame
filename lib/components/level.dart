import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:game/components/Background_tile.dart';
import 'package:game/components/collision_block.dart';
import 'package:game/components/enemies.dart';
import 'package:game/components/fruit.dart';
import 'package:game/components/saw.dart';
import 'package:game/components/checkpoint.dart';
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
    try{
    level= await TiledComponent.load("$levelName.tmx", Vector2.all(16));
    add(level);

   _scrollingBackground();
   _spawningObject();
   _addCollisions();
    } catch (e) {
    print('Error loading level: $e');
    // Add a fallback background or error message
  }
    return super.onLoad();
  }
  
  void _scrollingBackground() {
    final backgroundLayer = level.tileMap.getLayer("Background");
    
    if (backgroundLayer != null){ 
        final backgroundColor = backgroundLayer.properties.getValue('BackgroundColor');
        final backGroundTile = BackgroundTile(
          color: backgroundColor ?? 'Gray',
          position: Vector2(0, 0),
        );
        add(backGroundTile);
      
    }

  }
  
  void _spawningObject() {
    final SpawnPointLayer=level.tileMap.getLayer<ObjectGroup>("SpawnPoints");
    
    if (SpawnPointLayer != null)
    { print('Found SpawnPoints layer with ${SpawnPointLayer.objects.length} objects');
      for (final SpawnPoint in SpawnPointLayer.objects){

      print('Processing: class="${SpawnPoint.class_}", name="${SpawnPoint.name}", type="${SpawnPoint.type}"');
      print('  Position: (${SpawnPoint.x}, ${SpawnPoint.y})');
      print('  Size: ${SpawnPoint.width}x${SpawnPoint.height}');
      print('  Properties: ${SpawnPoint.properties}');
      
      try {
      switch (SpawnPoint.class_){

        case 'Player':
          add(player);
          print('Spawning player');
          player.position = Vector2( SpawnPoint.x, SpawnPoint.y);
          break;

        case 'Fruits':
          final fruits = Fruit(
          fruit: SpawnPoint.name,
          position: Vector2( SpawnPoint.x, SpawnPoint.y),
          size: Vector2( SpawnPoint.width, SpawnPoint.height),
          );
          add(fruits);
          break;

        case 'Saw':
            final isVertical = SpawnPoint.properties.getValue('isvertical') ?? false;
            final offsetNeg = SpawnPoint.properties.getValue('offsetneg') ?? 0.0;
            final offsetPos = SpawnPoint.properties.getValue('offsetpos') ?? 0.0;
  
            final saw = Saw(
              position: Vector2(SpawnPoint.x, SpawnPoint.y),
              size: Vector2(SpawnPoint.width, SpawnPoint.height),
              isvertical: isVertical,
              offsetNeg: offsetNeg,
              offsetPos: offsetPos,
            );
            add(saw);
            break;
        case 'Checkpoint':
          final checkpoint = Checkpoint(
            position: Vector2( SpawnPoint.x ,  SpawnPoint.y),
            size: Vector2( SpawnPoint.width, SpawnPoint.height),
          );
          add(checkpoint);
        case 'Enemies':
          print('Spawning enemy: ${SpawnPoint.name}');
         final offsetNeg = SpawnPoint.properties.getValue('offsetneg') ;
         final offsetPos = SpawnPoint.properties.getValue('offsetpos') ;
          final enemies = Enemies(
           enemy : SpawnPoint.name,
            position: Vector2( SpawnPoint.x ,  SpawnPoint.y),
            size: Vector2( SpawnPoint.width, SpawnPoint.height),
            offsetNeg : offsetNeg,
            offsetPos : offsetPos
          );
          add(enemies);
          print('Enemy added to game world');
        default: 
          print('Unknown spawn point class: ${SpawnPoint.class_}');
      
      }
      } catch (e) {
        print('Error spawning ${SpawnPoint.class_}: $e');
        print('SpawnPoint details - x: ${SpawnPoint.x}, y: ${SpawnPoint.y}, '
              'width: ${SpawnPoint.width}, height: ${SpawnPoint.height}, '
              'name: ${SpawnPoint.name}');
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