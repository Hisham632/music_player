import 'package:flutter/material.dart';
import 'package:music_player/AudioPlayer_Playing.dart';
import 'package:music_player/List.dart';
import 'package:music_player/Grids.dart';
import 'package:music_player/youtubeTest.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

/*
Notification like Youtube in LockScreen:
  https://pub.dev/packages/just_audio_background
  I found it relatively easy on Google
  https://www.youtube.com/watch?v=DIqB8qEZW1U hate to bringing up YouTube video but this might help you

  When searching for this kind of thing better start by looking up what its name
  https://developer.android.com/guide/topics/media/media-controls#supporting_playback_resumption
  That is the API you looking for

Bluetooth:
  Isn't headset button just counted as keyboard button on Android?
  You could use ![RawKeyboardListener] or ![RawKeyboard.addListener] if that is the case
  https://api.flutter.dev/flutter/widgets/RawKeyboardListener-class.html
  https://api.flutter.dev/flutter/services/RawKeyboard/addListener.html
  you can debug the keypress



Do the equal width for the stuff next and previous buttons, width% for slider
*/

void main() async {

  AwesomeNotifications().requestPermissionToSendNotifications();

  AwesomeNotifications().initialize(

      'resource://drawable/res_ic_play',
      [
        NotificationChannel(
          channelGroupKey: 'media_player_tests',
          icon: null,
          channelKey: 'media_player',
          channelName: 'Media player controller',
          channelDescription: 'Media player controller',
          defaultPrivacy: NotificationPrivacy.Public,
          enableVibration: false,
          enableLights: true,
          playSound: false,
          locked: true,
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.black,
          importance: NotificationImportance.High,
          channelShowBadge: true,


        ),
      ],
      channelGroups: [
        NotificationChannelGroup(
            channelGroupkey: 'media_player_tests',
            channelGroupName: 'Media Player tests')

      ],
      debug: true);

  AwesomeNotifications().actionStream.listen((receivedAction) {
    // print(receivedAction.buttonKeyPressed);


    AudioPlay.processMediaControls(receivedAction);

    // if (!AwesomeStringUtils.isNullOrEmpty(
    //     receivedAction.buttonKeyPressed) &&
    //     receivedAction.buttonKeyPressed.startsWith('MEDIA_')) {
    // }
    // else
    //   {
    //     print("Line140");
    //     String targetPage=AudioPlay(number:songNumber, path:widget.path) as String;
    //     loadSingletonPage(targetPage: targetPage, receivedAction: receivedAction);
    //
    //   }
  });


  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(brightness: Brightness.dark),
    initialRoute: '/Playlists',
    routes: {
      //'/':(context)=> AudioPlay(number: -1),
      //   '/listing':(context)=> Lists(folderName:" Directory: '/storage/emulated/0/AudioFiles/君の名は。 (Kimi no Na wa.) (Your Name.) (Full Original Soundtrack)'"),
      '/Playlists': (context) => Playlists(),
      // '/youtube':(context)=>  MyHomePage(title: 'Flutter Demo Home Page'),
    },
  ));
}





/*
https://stackoverflow.com/questions/72451301/flutter-how-to-sort-file-list-by-creation-time

For Miniplayer implementation :
  Make the Stack with AudioPlayer()
  add the state and riverpod
  make it so when we drag the miniplayer above a certain height it goes to the AudioPlayer page
  The Miniplayer has the pause, next and previous buttons and the details of the song playing
*/