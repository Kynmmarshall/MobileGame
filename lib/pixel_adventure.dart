import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:flame/game.dart';
//import 'package:just_audio/just_audio.dart';
import 'package:flame_audio/flame_audio.dart' hide AudioPlayer;
import 'package:flutter/painting.dart';
import 'package:game/components/jump_button.dart';
import 'package:game/components/player.dart';
import 'package:game/components/level.dart';

class PixelAdventure extends FlameGame 
with HasKeyboardHandlerComponents, DragCallbacks , HasCollisionDetection, TapCallbacks{
  @override
  Color backgroundColor() => const Color.fromARGB(255, 34, 32, 53);
  late CameraComponent cam;
  Player player = Player(character: 'Ninja Frog');
  late JoystickComponent joystick;
  bool showControls = true;
  bool playsound = true;
  double soundVolume = 1.0;
  bool _isLoading = false;
  bool _soundsLoaded = false;
 // final AudioPlayer collectPlayer = AudioPlayer();
  
  List<String> levelNames = ['Level-01', 'Level-02', 'Level-03'];
  int currentLevelIndex = 0;

  @override
  FutureOr<void> onLoad() async{
    
    //locate all images into the cache
    print('Starting game load...');
    await images.loadAllImages();

    await _loadAllSounds();

    await FlameAudio.audioCache.loadAll([
      'jump.wav',
      'collect.wav',
      'bounced.wav',
      'appear.wav',
      'levelComplete.wav',
    ]);
    
    if (showControls){
    print('Adding controls...');
    addjoystick();
    add(JumpButton());
    }

    print('Starting game load...');
    _loadLevel();


    print('Game load complete');
    return super.onLoad();
  }

  DateTime _lastCollectSound = DateTime.now();

  Future<void> _loadAllSounds() async {
  if (_soundsLoaded) return;
  
  // Pre-load all sound assets
  //await collectPlayer.setAsset('assets/audio/collect.wav');
  
  _soundsLoaded = true;
  print('All sounds pre-loaded successfully');
}

  @override
  void update(double dt) {

    if (showControls){
    updatejoystick();}
    super.update(dt);
  }

  void playJumpSound() {
  if (playsound) FlameAudio.play('jump.wav');
}

void playCollectSound() {
  if (!playsound) return;
  
  final now = DateTime.now();
  // Only play collect sound every 100ms
  if (now.difference(_lastCollectSound).inMilliseconds > 100) {
    FlameAudio.play('collect.wav');
    _lastCollectSound = now;
  }
}

void playBounceSound() {
  if (playsound) FlameAudio.play('bounced.wav');
}

void playAppearSound() {
  if (playsound) FlameAudio.play('appear.wav');
}

void playLevelCompleteSound() {
  if (playsound) FlameAudio.play('levelComplete.wav');
}

//   void clearSoundBuffer() {
//   collectPlayer.stop();
//   // stop all other audio players
//   collectPlayer.seek(Duration.zero);
// }


  void addjoystick() {
    joystick = JoystickComponent(
      priority : 10000000000,
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
      margin: const EdgeInsets.only(left: 32, bottom: 16),
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
    if (_isLoading) return; // Prevent multiple simultaneous loads
  
    _isLoading = true;
    // clearSoundBuffer();

    removeWhere((component) => component is Level || component is Player);
    if(currentLevelIndex < levelNames.length - 1){
      currentLevelIndex ++;
    }
    else{
      currentLevelIndex = 0;
    }
    Future.delayed(const Duration(milliseconds: 200), () {
      _loadLevel();
      _isLoading = false;
    });
    
  }

  void _loadLevel() {

    bool previousSoundState = playsound;
    playsound = false;
  Future.delayed(const Duration(seconds: 1,),(){
    print('Loading level: ${levelNames[currentLevelIndex]}');
    Level world = Level(
    player: player,
    levelName: levelNames[currentLevelIndex], 
  );
    cam = CameraComponent.withFixedResolution(
      world: world,
       width: 640, 
       height: 360);
    cam.viewfinder.anchor= Anchor.topLeft;
    if (children.contains(cam)) {
    remove(cam);
  }
    addAll([cam,world]); 

    Future.delayed(const Duration(seconds: 1), () {
        playsound = previousSoundState;
      });

    if (showControls){
    print('Adding controls...');
    addjoystick();
    add(JumpButton());
    }
  });
   
  } 


}     