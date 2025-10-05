import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:flame/game.dart';
import 'package:flutter/painting.dart';
import 'package:game/actors/player.dart';
import 'package:game/levels/level.dart';

class PixelAdventure extends FlameGame with HasKeyboardHandlerComponents, DragCallbacks {
  @override
  Color backgroundColor() => const Color(0xFF211F30);
  late final CameraComponent cam;
  late JoystickComponent joystick;


  @override
  final world = Level(
    levelName: 'Level-02', 
  player: Player(character: 'Ninja Frog')
  );

  @override
  FutureOr<void> onLoad() async{
    
    //loac all images into the cache
    await images.loadAllImages();
    cam= CameraComponent.withFixedResolution(world: world, width: 640, height: 360);
    cam.viewfinder.anchor= Anchor.topLeft;
    addAll([cam,world]);  

    addjoystick();

    return super.onLoad();
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
  } 
}     