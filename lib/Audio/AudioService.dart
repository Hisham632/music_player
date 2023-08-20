//
//
// import 'package:audio_service/audio_service.dart';
// import 'package:just_audio/just_audio.dart';
//
// Future<AudioHandler> initAudioService() async {
//   return await AudioService.init(
//     builder: () => MyAudioHandler(),
//     config: const AudioServiceConfig(
//       androidNotificationChannelId: 'com.mycompany.myapp.audio',
//       androidNotificationChannelName: 'Music Player',
//       androidNotificationOngoing: true,
//       androidStopForegroundOnPause: true,
//     ),
//   );
// }
//
// class MyAudioHandler extends BaseAudioHandler
//     with QueueHandler, // mix in default queue callback implementations
//         SeekHandler { // mix in default seek callback implementations
//
//   final AudioPlayer _audioPlayer = AudioPlayer(
//     handleInterruptions: true,
//     androidApplyAudioAttributes: true,
//     handleAudioSessionActivation: true,
//   );  final audioHandler=  initAudioService();
//
//
//   // The most common callbacks:
//   Future<void> play() async {
//     _player.set;
//     _player.
//     // All 'play' requests from all origins route to here. Implement this
//     // callback to start playing audio appropriate to your app. e.g. music.
//   }
//   Future<void> pause() async {}
//   Future<void> stop() async {}
//   Future<void> seek(Duration position) async {}
//   Future<void> skipToQueueItem(int i) async {}
// }