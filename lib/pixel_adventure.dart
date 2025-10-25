import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:flame/game.dart';
//import 'package:just_audio/just_audio.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
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
  bool playsound = false;
  double soundVolume = 1.0;
  bool _isLoading = false;
  bool _soundsLoaded = false;
  bool play = false;
  int lives = 3;
  bool menu_screen = true;

  bool _jumpSoundPlaying = false;
  bool _collectSoundPlaying = false;
  bool _bounceSoundPlaying = false;
  bool _appearSoundPlaying = false;
  bool _levelCompleteSoundPlaying = false;
  
  
  List<String> levelNames = [ 'Menu', 'Credits', 'GameOver', 'Level-01', 'Level-02', 'Level-03'];
  int currentLevelIndex = 0;

  bool isBGMPlaying = true;
  String currentBGM = '';

  @override
  FutureOr<void> onLoad() async{
    //debugMode = true;
    //locate all images into the cache
    print('Starting game load...');
    await images.loadAllImages();

    await FlameAudio.audioCache.loadAll([
      'jump.wav',
      'collect.wav',
      'bounced.wav',
      'appear.wav',
      'levelComplete.wav',
      'bgm_menu.mp3',
    ]);
    
    if (showControls){
    print('Adding controls...');
    addjoystick();
    if(play) add(JumpButton());
    }

    print('Starting game load...');
    _loadLevel();

    playBGM('bgm_menu.mp3');
    print('Game load complete');
    return super.onLoad();
  }


  @override
  void update(double dt) {

    if (showControls && play){
    updatejoystick();
    }
    if(lives <= 0){
      currentLevelIndex = 2;
      _loadLevel();
      lives = 3;
    }
    super.update(dt);
  }

  @override
  void onRemove() {
    _disposeAllResources();
    super.onRemove();
  }

  void playBGM(String bgmName) {
    if (!playsound || currentBGM == bgmName) return;
    
    // Stop current BGM if playing
    stopBGM();
    
    // Play new BGM
    FlameAudio.bgm.play(bgmName, volume: soundVolume);
    currentBGM = bgmName;
    isBGMPlaying = true;
    
    print('Now playing: $bgmName');
  }
  
  void stopBGM() {
    if (isBGMPlaying) {
      FlameAudio.bgm.stop();
      isBGMPlaying = false;
      currentBGM = '';
    }
  }

  void _disposeAllResources() {
    print('Disposing game resources...');
    
    // Clear all components
    removeWhere((component) => true);
    
    // Clear images cache
    images.clearCache();
    
    // Stop all audio
    FlameAudio.bgm.stop();
    
    // Reset game state
    _resetGameState();
  }

  void _resetGameState() {
    play = false;
    playsound = false;
    currentLevelIndex = 0;
    _isLoading = false;
    resetAllSoundStates();
  }

  void exitGame() {
    print('Exiting game and clearing RAM...');
    
    // Properly dispose before exiting
    _disposeAllResources();
    
    // Exit the app
    SystemNavigator.pop();
  }

  void playJumpSound() {
  if (!playsound || _jumpSoundPlaying) return;
  
  _jumpSoundPlaying = true;
  FlameAudio.play('jump.wav').then((_) {
    _jumpSoundPlaying = false;
  });
}

  void playCollectSound() {
  if (!playsound || _collectSoundPlaying) return;
  
  _collectSoundPlaying = true;
  FlameAudio.play('collect.wav').then((_) {
    _collectSoundPlaying = false;
  });
}

  void playBounceSound() {
  if (!playsound || _bounceSoundPlaying) return;
  
  _bounceSoundPlaying = true;
  FlameAudio.play('bounced.wav').then((_) {
    _bounceSoundPlaying = false;
  });
}

  void playAppearSound() {
  if (!playsound || _appearSoundPlaying) return;
  
  _appearSoundPlaying = true;
  FlameAudio.play('appear.wav').then((_) {
    _appearSoundPlaying = false;
  });
}

  void playLevelCompleteSound() {
  if (!playsound || _levelCompleteSoundPlaying) return;
  
  _levelCompleteSoundPlaying = true;
  FlameAudio.play('levelComplete.wav').then((_) {
    _levelCompleteSoundPlaying = false;
  });
}

  void resetAllSoundStates() {
  _jumpSoundPlaying = false;
  _collectSoundPlaying = false;
  _bounceSoundPlaying = false;
  _appearSoundPlaying = false;
  _levelCompleteSoundPlaying = false;
}

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
    if(play)add(joystick);
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
    resetAllSoundStates();

    removeWhere((component) => component is Level || component is Player);
    if(currentLevelIndex < levelNames.length - 1){
      currentLevelIndex ++;
    }
    else{
      currentLevelIndex = 3;
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

    if (showControls && play){
    print('Adding controls...');
    addjoystick();
    if(play) add(JumpButton());
    }
  });
   
  } 


}     