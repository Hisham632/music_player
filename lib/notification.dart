
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:music_player/AudioPlayer_Playing.dart';



class notificationDetail{

  static Future<void> cancelNotification(int id) async {
    await AwesomeNotifications().cancel(id);
  }

  static void updateNotificationMediaPlayer(int id, bool isPlaying, String songNmae) {


    var imageSaveName=songNmae.replaceAll(RegExp(r'[^\p{Alphabetic}\p{Mark}\p{Decimal_Number}\p{Connector_Punctuation}\p{Join_Control}\s]', unicode: true),'');

    //FileImage(File('/storage/emulated/0/Android/data/com.example.music_player/files/pictures/$imageSaveName.jpg'))
 // print("IN NOTIFICATION "+isPlaying.toString());

    if (isPlaying == null) {
      cancelNotification(id);
      return;
    }
    //print("creating Noti");
    AwesomeNotifications().createNotification(


        content: NotificationContent(


            id: id,
            channelKey: 'media_player',
            category: NotificationCategory.Transport,
            title: songNmae,
            body: "YourGate",
            backgroundColor: Colors.purple.shade700,
            notificationLayout: NotificationLayout.MediaPlayer,
            //icon:'file://storage/emulated/0/Android/data/com.example.music_player/files/pictures/$imageSaveName.jpg',
            bigPicture:'file://storage/emulated/0/Android/data/com.example.music_player/files/pictures/$imageSaveName.jpg',//pic here
            roundedLargeIcon: false,
            progress: 50,
            largeIcon:'file://storage/emulated/0/Android/data/com.example.music_player/files/pictures/$imageSaveName.jpg',//pic here
            color: Colors.purple.shade700,
            autoDismissible: false,
            showWhen: false,
            displayOnBackground: true,
            displayOnForeground: true,
            summary: songNmae,



        ),

        actionButtons: [


          NotificationActionButton(
              key: 'MEDIA_PREV',
              icon: 'resource://drawable/res_ic_prev',
              label: 'Previous',
              autoDismissible: false,
              showInCompactView: true,
              buttonType: ActionButtonType.KeepOnTop),

          isPlaying?NotificationActionButton(
              key: 'MEDIA_PAUSE',
              icon: 'resource://drawable/res_ic_pause',
              label: 'Pause',
              autoDismissible: false,
              showInCompactView: true,
              buttonType: ActionButtonType.KeepOnTop)
              :
              NotificationActionButton(
              key: 'MEDIA_PLAY',
              icon: 'resource://drawable/res_ic_play',
              label: 'Play',
              autoDismissible: false,
              showInCompactView: true,
              buttonType: ActionButtonType.KeepOnTop),


          NotificationActionButton(
              key: 'MEDIA_NEXT',
              icon: 'resource://drawable/res_ic_next',
              label: 'Previous',
              showInCompactView: true,
              buttonType: ActionButtonType.KeepOnTop),



          NotificationActionButton(
              key: 'MEDIA_CLOSE',
              icon: 'resource://drawable/res_ic_close',
              label: 'Close',
              autoDismissible: true,
              showInCompactView: false,
              buttonType: ActionButtonType.KeepOnTop)
        ]);

    // AwesomeNotifications().actionStream.listen((receivedAction) {
    //
    //
    //   //
    //   // if (!AwesomeStringUtils.isNullOrEmpty(
    //   //     receivedAction.buttonKeyPressed) &&
    //   //     receivedAction.buttonKeyPressed.startsWith('MEDIA_')) {
    //   // }
    //   // else
    //   //   {
    //   //     print("Line140");
    //   //     String targetPage=AudioPlay(number:songNumber, path:widget.path) as String;
    //   //     loadSingletonPage(targetPage: targetPage, receivedAction: receivedAction);
    //   //
    //   //   }
    //
    //
    //
    // });
  }

}

