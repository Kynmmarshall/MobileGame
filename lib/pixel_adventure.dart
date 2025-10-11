import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:flame/game.dart';
import 'package:flutter/painting.dart';
import 'package:game/components/player.dart';
import 'package:game/components/level.dart';

class PixelAdventure extends FlameGame 
with HasKeyboardHandlerComponents, DragCallbacks , HasCollisionDetection{
  @override
  Color backgroundColor() => const Color.fromARGB(255, 34, 32, 53);
  late CameraComponent cam;
  Player player = Player(character: 'Ninja Frog');
  late JoystickComponent joystick;
  bool showjoystick = true;
  
  List<String> levelNames = ['level-01', 'level-02'];
  int currentLevelIndex = 0;

  @override
  FutureOr<void> onLoad() async{
  
    //locate all images into the cache
    await images.loadAllImages();

    _loadLevel();

    if (showjoystick){
    addjoystick();}
    return super.onLoad();
  }
  @override
  void update(double dt) {
    if (showjoystick){
    updatejoystick();}
    super.update(dt);
  }
  void addjoystick() {
    joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: Sprite(
        images.fromCache('Joystick components/knob.png'),
        ),
        ),
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache('Joystick components/joystick.png')
        ),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );
    add(joystick);
  }
  
  void updatejoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
       player.horizontalMovement = 1;
        break;
      default:
       player.horizontalMovement = 0;
    }
  }
  
  void loadNextLevel() {
    if(currentLevelIndex < levelNames.length - 2){
      currentLevelIndex ++;
      _loadLevel();
    }
    else{
      //No more levels
    }
  }

  void _loadLevel() {
  Future.delayed(const Duration(seconds: 1,),(){
    Level world = Level(
    player: player,
    levelName: levelNames[currentLevelIndex], 
  );

    cam = CameraComponent.withFixedResolution(
      world: world,
       width: 640, 
       height: 360);
    cam.viewfinder.anchor= Anchor.topLeft;
    addAll([cam,world]); 
  });
   
  } 
}     