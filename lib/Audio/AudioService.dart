

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class MyAudioHandler extends BaseAudioHandler {
  final AudioPlayer _player = AudioPlayer();

  // Map to store song paths and their respective indexes
  Map<int, String> pathToIndexMap = {};

  // ... (Other initializations and methods)

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> skipToNext() => next();

  @override
  Future<void> skipToPrevious() => previous();

  // Your loadAudioFiles function
  void loadAudioFiles(path) async {
    // ... (Your existing code here)
  }

  // Your play function
  void play() async {
    await _player.play();
  }

  // Your pause function
  void pause() async {
    await _player.pause();
  }

  // Your next function
  void next() async {
    if(_player.hasNext) {
      await _player.seekToNext();
    } else {
      await _player.seek(Duration.zero, index: 0);
    }
  }

  // Your previous function
  void previous() async {
    if(_player.hasPrevious) {
      await _player.seekToPrevious();
    } else {
      await _player.seek(Duration.zero, index: 0);
    }
  }

// ... (Any other functions you have)
}
