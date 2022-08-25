//
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:flutter/material.dart';
//
// class notificationDetail{
//
//   static Future<void> cancelNotification(int id) async {
//     await AwesomeNotifications().cancel(id);
//   }
//
//   static void updateNotificationMediaPlayer(int id, bool playing, String songNmae) {
//     if (playing == null) {
//       cancelNotification(id);
//       return;
//     }
//
//     AwesomeNotifications().createNotification(
//         content: NotificationContent(
//             id: id,
//             channelKey: 'media_player',
//             category: NotificationCategory.Transport,
//             title: songNmae,
//             body: songNmae,
//             notificationLayout: NotificationLayout.MediaPlayer,
//             largeIcon: mediaNow.diskImagePath,
//             color: Colors.purple.shade700,
//             autoDismissible: false,
//             showWhen: false),
//
//         actionButtons: [
//
//           NotificationActionButton(
//               key: 'MEDIA_PREV',
//               icon: 'resource://drawable/res_ic_prev',
//               label: 'Previous',
//               autoDismissible: false,
//               showInCompactView: false,
//               buttonType: ActionButtonType.KeepOnTop),
//
//           MediaPlayerCentral.isPlaying
//               ? NotificationActionButton(
//               key: 'MEDIA_PAUSE',
//               icon: 'resource://drawable/res_ic_pause',
//               label: 'Pause',
//               autoDismissible: false,
//               showInCompactView: true,
//               buttonType: ActionButtonType.KeepOnTop)
//               : NotificationActionButton(
//               key: 'MEDIA_PLAY',
//               icon: 'resource://drawable/res_ic_play',
//               label: 'Play',
//               autoDismissible: false,
//               showInCompactView: true,
//               buttonType: ActionButtonType.KeepOnTop),
//
//
//           NotificationActionButton(
//               key: 'MEDIA_NEXT',
//               icon: 'resource://drawable/res_ic_next',
//               label: 'Previous',
//               showInCompactView: true,
//               buttonType: ActionButtonType.KeepOnTop),
//
//
//
//           NotificationActionButton(
//               key: 'MEDIA_CLOSE',
//               icon: 'resource://drawable/res_ic_close',
//               label: 'Close',
//               autoDismissible: true,
//               showInCompactView: true,
//               buttonType: ActionButtonType.KeepOnTop)
//         ]);
//   }
// }