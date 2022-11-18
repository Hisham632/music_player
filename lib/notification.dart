
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';


/*
We need to pass the song name and from that we can get the icon

noti works now, we just gotta link the buttons making sure they work and as well when to delete and show the notification
 */

class notificationDetail{

  static Future<void> cancelNotification(int id) async {
    await AwesomeNotifications().cancel(id);
  }

  static void updateNotificationMediaPlayer(int id, bool isPlaying, String songNmae) {
    var imageSaveName=songNmae.replaceAll(RegExp(r'[^\p{Alphabetic}\p{Mark}\p{Decimal_Number}\p{Connector_Punctuation}\p{Join_Control}\s]', unicode: true),'');

    //FileImage(File('/storage/emulated/0/Android/data/com.example.music_player/files/pictures/$imageSaveName.jpg'))
  print("IN NOTIFICATION "+isPlaying.toString());

    if (isPlaying == null) {
      cancelNotification(id);
      return;
    }
    print("creating Noti");
    AwesomeNotifications().createNotification(

        content: NotificationContent(
            id: id,
            channelKey: 'media_player',
            category: NotificationCategory.Transport,
            title: songNmae,
            //body: songNmae,
            notificationLayout: NotificationLayout.MediaPlayer,
           // icon:'file://storage/emulated/0/Android/data/com.example.music_player/files/pictures/$imageSaveName.jpg',
            bigPicture:'file://storage/emulated/0/Android/data/com.example.music_player/files/pictures/$imageSaveName.jpg',//pic here

            largeIcon:'file://storage/emulated/0/Android/data/com.example.music_player/files/pictures/$imageSaveName.jpg',//pic here
            color: Colors.purple.shade700,
            autoDismissible: false,
            showWhen: false),

        actionButtons: [

          NotificationActionButton(
              key: 'MEDIA_PREV',
              icon: 'resource://drawable/res_ic_prev',
              label: 'Previous',
              autoDismissible: false,
              showInCompactView: true,
              buttonType: ActionButtonType.KeepOnTop),

              // NotificationActionButton(
              // key: 'MEDIA_PAUSE',
              // icon: 'resource://drawable/res_ic_pause',
              // label: 'Pause',
              // autoDismissible: false,
              // showInCompactView: true,
              // buttonType: ActionButtonType.KeepOnTop)
              // :
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
  }
}

/*
Dismiss noti
 */