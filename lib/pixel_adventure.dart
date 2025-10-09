import 'dart:async';

import 'package:flame/collisions.dart';
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
  Color backgroundColor() => const Color(0xFF211F30);
  late final CameraComponent cam;
  Player player = Player(character: 'Ninja Frog');
  late JoystickComponent joystick;
  bool showjoystick = true;
  
  @override
  FutureOr<void> onLoad() async{
  
    //locate all images into the cache
    await images.loadAllImages();
    @override
  final world = Level(
    player: player,
    levelName: 'Level-02', 
  );

    cam= CameraComponent.withFixedResolution(world: world, width: 640, height: 360);
    cam.viewfinder.anchor= Anchor.topLeft;
    addAll([cam,world]);  
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
}     