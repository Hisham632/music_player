import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:music_player/TextScroll.dart';
import 'package:music_player/Grids.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player/like_button_icons.dart';
import 'package:music_player/my_icons_icons.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart' as path2;
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:music_player/notification.dart';
import 'package:music_player/List.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';


class AudioPlay extends StatefulWidget {
  final int number;
  final String path;


  static void processMediaControls(actionReceived) {
    switch (actionReceived.buttonKeyPressed) {

      case 'MEDIA_CLOSE':
        _AudioPlayState.stop();
        break;

      case 'MEDIA_PLAY':
        print("38"+_AudioPlayState.isPlaying.toString());

            if(_AudioPlayState.isPlaying){
              _AudioPlayState.pause();
            }
            else
            {
              _AudioPlayState.play(_AudioPlayState.songNumber);
            }
        notificationDetail.updateNotificationMediaPlayer(0,_AudioPlayState.isPlaying, _AudioPlayState.songName);


        break;

    case 'MEDIA_PAUSE':
      print("52"+_AudioPlayState.isPlaying.toString());

      if(_AudioPlayState.isPlaying){
        _AudioPlayState.pause();
      }
      else
      {
        _AudioPlayState.play(_AudioPlayState.songNumber);
      }
       notificationDetail.updateNotificationMediaPlayer(0,_AudioPlayState.isPlaying, _AudioPlayState.songName);

      break;

      case 'MEDIA_PREV':
        _AudioPlayState.previous();
        break;

      case 'MEDIA_NEXT':
        _AudioPlayState.next();
        break;

      default:
        break;
    }
  }


  const AudioPlay({Key? key,
    required this.number,required this.path,

  }) : super(key: key);

  @override
  _AudioPlayState createState() => _AudioPlayState();
}



class _AudioPlayState extends State<AudioPlay> with TickerProviderStateMixin {

  int count2=0;
  int countTimes=0;


  static late AudioPlayer audioPlayer;
  late AudioCache player=player = AudioCache();
  Duration fileDuration= Duration();
  Duration position= Duration();
  static bool isPlaying=true;
  static late List<FileSystemEntity> listOfAllFolderAndFiles;
  static String songName='', lastSongPlayed='';//not used
  bool liked = false;
  static bool shuffle=false;
  late List<FileSystemEntity> tempPathOld;

  late AnimationController animationController;
  static int songNumber=1;

  void initPlayer() async {
    //final manifestJson = await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    //final Map<String, dynamic> manifestMap = json.decode(manifestJson);

    audioPlayer = AudioPlayer();
    player = AudioCache(fixedPlayer: audioPlayer);
    animationController=AnimationController(vsync: this,duration: Duration(milliseconds: 500),reverseDuration: Duration(milliseconds: 500) );

    audioPlayer.onDurationChanged.listen((Duration duration) {
     // print('duration $duration');
      setState(() {
        fileDuration=duration;
      });
    });

    audioPlayer.onAudioPositionChanged.listen((Duration position) {
        //print('Current position: $position');
        setState(() {
          this.position=position;
    });
  });
    AwesomeNotifications().requestPermissionToSendNotifications();

    // AwesomeNotifications().createdStream.listen((notification) {
    //
    //   print("CREated NOti");
    //
    //   animationController=AnimationController(vsync: this,duration: Duration(milliseconds: 500),reverseDuration: Duration(milliseconds: 500));
    //
    // });

    final status = await Permission.storage.status;
    const statusManageStorage = Permission.manageExternalStorage;
    if (status.isDenied ||
        !status.isGranted ||
        !await statusManageStorage.isGranted) {
      await [
        Permission.storage,
        Permission.mediaLibrary,
        Permission.requestInstallPackages,
        Permission.manageExternalStorage,
      ].request();
    }

    Directory dir = Directory(widget.path);
    listOfAllFolderAndFiles = dir.listSync(recursive: true);
    //print(listOfAllFolderAndFiles);//has all the files from the directory
   // print('Number is:'+widget.number.toString());
    songNumber=widget.number;
    AudioPlayer.players.forEach((key, value) {
      value.stop();
    });

    if(songNumber!=-1)
      {
        play(songNumber);
      }
    notificationDetail.updateNotificationMediaPlayer(0,isPlaying, songName);

    // if (!Playlists.subscribedActionStream) {
    //   notificationDetail.updateNotificationMediaPlayer(0,isPlaying, songName);
    //
    //   print("Listening "+ Playlists.subscribedActionStream.toString());
    //
    //   AwesomeNotifications().actionStream.listen((receivedAction) {
    //
    //
    //   // if (!AwesomeStringUtils.isNullOrEmpty(
    //   //     receivedAction.buttonKeyPressed) &&
    //   //     receivedAction.buttonKeyPressed.startsWith('MEDIA_')) {
    //      processMediaControls(receivedAction);
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
    //   Playlists.subscribedActionStream = true;
    // }else{
    //   await AwesomeNotifications().actionStream.single;
    //
    //   print("222Listening222 "+ Playlists.subscribedActionStream.toString());
    //   notificationDetail.updateNotificationMediaPlayer(0,isPlaying, songName);
    //
    //
    //
    // }
  }


  @override
  void initState()
  {
    super.initState();
    initPlayer();
  }



 static play(songNum) async {

   String song = listOfAllFolderAndFiles[songNum].toString().substring(7, listOfAllFolderAndFiles[songNum].toString().length - 1);
   songName=listOfAllFolderAndFiles[songNum].toString().split('/').last.substring(0,listOfAllFolderAndFiles[songNum].toString().split('/').last.length-6);

    audioPlayer.play(song, isLocal: true);
    audioPlayer.onPlayerCompletion.listen((event) {// when the song ends call the next()
      next();
    });
   isPlaying=true;

 }

  static pause(){
    audioPlayer.pause();
    isPlaying=false;

  }
  static stop(){
    audioPlayer.stop();
  }

  resume(){
    audioPlayer.resume();
  }

  static next(){

    if(shuffle){

        Random random = Random();
        songNumber= random.nextInt(listOfAllFolderAndFiles.length) + 1;

        if(listOfAllFolderAndFiles.length<=songNumber){
          songNumber=0;
        }

        play(songNumber);
        notificationDetail.updateNotificationMediaPlayer(0,isPlaying, songName);
      }

    else{
      //if(Lists.playNextNum==-1){
      //ig just +1 to songNum
      songNumber+=1;
      if(listOfAllFolderAndFiles.length<=songNumber)
      {
        songNumber=0;
      }
      play(songNumber);
      notificationDetail.updateNotificationMediaPlayer(0,isPlaying, songName);

      //audioPlayer.onPlayerCompletion
      // }
      // else{
      //   Directory dir = Directory(Lists.playNextPath);
      //   tempPathOld=listOfAllFolderAndFiles;
      //   listOfAllFolderAndFiles = dir.listSync(recursive: true);
      //   play(Lists.playNextNum);
      //
      // }
    }
  }

  static previous(){

    if(shuffle){

      Random random = Random();
        songNumber= random.nextInt(listOfAllFolderAndFiles.length) + 1;

        if(songNumber<0){
          songNumber=listOfAllFolderAndFiles.length-1;
        }

        play(songNumber);
        notificationDetail.updateNotificationMediaPlayer(0,isPlaying, songName);
      }

    else{
      // play(lastSongPlayed);
      songNumber-=1;

      if(songNumber<0){
        songNumber=listOfAllFolderAndFiles.length-1;
      }

      play(songNumber);
      notificationDetail.updateNotificationMediaPlayer(0,isPlaying, songName);
    }
  }

timeStamp(){

  if(position.inSeconds.remainder(60)>10){

      return position.inSeconds.remainder(60);
  }
  else{
    return "0"+position.inSeconds.remainder(60).toString();
  }
}

fileTimeStamp(){

    if(fileDuration.inSeconds.remainder(60)>=10){
      return fileDuration.inSeconds.remainder(60);
    }

    else{
      return "0"+fileDuration.inSeconds.remainder(60).toString();
    }
}

  // _updatePalette() async {
  // var bgColors = [];
  // for(String image in images) {
  //   PaletteGenerator palette = await PaletteGenerator.fromImageProvider(
  //     AssetImage(image),
  //     size: Size(200, 100),
  //   );
  //   palette.darkMutedColor != null ? bgColors.add(palette.darkMutedColor) : bgColors.add(PaletteColor(Colors.red,3));
  // }
  // setState(() {});
  // }



  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    var imageSaveName=songName.replaceAll(RegExp(r'[^\p{Alphabetic}\p{Mark}\p{Decimal_Number}\p{Connector_Punctuation}\p{Join_Control}\s]', unicode: true),'');

    return Scaffold(
        resizeToAvoidBottomInset : false,
      // appBar: AppBar(
      //     title: Text('Clean',textAlign: TextAlign.center,style: TextStyle(color: Colors.black),)),

       body: Container(
         height: mediaQueryData.size.height,
         width: mediaQueryData.size.width,
        decoration:  BoxDecoration(

            image: DecorationImage(image: FileImage(File('/storage/emulated/0/files/pictures/$imageSaveName.jpg')), fit: BoxFit.cover, opacity: 0.1),//HERE IS backgroundColor

            gradient: const LinearGradient(
                colors: [Color(0xFF616161), Color(0xFF212121)],
                stops: [0.05, 0.62],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                tileMode: TileMode.repeated)),

        child: Column(
          children: [
            SizedBox(height: 40,),

            Row(
              children: [
                SizedBox(width: 10,),
                IconButton(
                  iconSize: 32,
                  icon: const Icon(MyIcons.chevron_down_1),
                  color: const Color(0xFF212121),//632

                  alignment: Alignment.topLeft,

                  onPressed: ()
                  {
                    //previous();
                  },
                ),
              ],
            ),

            SizedBox(height: 20,),
          Center(
            child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(File('/storage/emulated/0/Android/data/com.example.music_player/files/pictures/$imageSaveName.jpg')),
                    fit: BoxFit.cover,

                  ),
                  borderRadius:  BorderRadius.all(Radius.circular(15.0)),
                ),
              alignment: Alignment.center,
              width: 350,
              height: 380,
            ),
          ),SizedBox(height: 23,),

            Container(
              child: songNameLenght(),
              height: 45,
              width: 380,
            )
         ,SizedBox(height: 30,),
            Row(
              children: [

                Text(" ${position.inMinutes}:${timeStamp()}",style: const TextStyle(color: Color(0xFFFFFFFF),fontSize: 16,fontWeight: FontWeight.bold,fontFamily:'Proxima Nova' ),),
                SizedBox(
                  width: 305,
                  child: Slider(
                      min: 0,
                      max: fileDuration.inSeconds.toDouble(),
                      value: position.inSeconds.toDouble(),
                      activeColor: const Color(0xFFFFFFFF),//0xFF35325e
                      inactiveColor: Colors.grey[800],
                      onChanged: (double value){
                        setState(() {
                          audioPlayer.seek(Duration(seconds: value.toInt()));
                        });
                      }
                  ),
                ),
                Text("${fileDuration.inMinutes}:${fileTimeStamp()}",style: const TextStyle(color: Color(0xFFFFFFFF),fontSize: 16,fontWeight: FontWeight.bold,fontFamily:'Proxima Nova' ),),

              ],
            ),


        SizedBox(height: 15,),

            Row(//buttons row
              children: [
                SizedBox(width: 10,),

                IconButton(
                    iconSize: 30,
                    icon: Icon(LikeButton.heart),
                    color: liked
                        ? Colors.red[800]
                        : Colors.white70 ,

                    onPressed: ()
                    {
                      String song = listOfAllFolderAndFiles[songNumber].toString().substring(7, listOfAllFolderAndFiles[songNumber].toString().length - 1);

                    if(Directory("/storage/emulated/0/AudioFiles/Liked/"+songName+".webm").existsSync()) {

                    }
                    else
                      {
                        File(song).copySync("/storage/emulated/0/AudioFiles/Liked/"+songName+".webm");

                      }

                      setState(() {
                        liked = !liked;
                      });


                    },
                  ),
                SizedBox(width: 10,),
                IconButton(
                    iconSize: 50,
                    icon: Icon(Icons.skip_previous_rounded),
                    color: Colors.white,

                    onPressed: ()
                    {
                      previous();
                    },
                  ),
                SizedBox(width: 10),

                 AvatarGlow(
                      glowColor: Colors.deepPurple,
                        endRadius: 50.0,
                        duration: Duration(milliseconds: 2000),
                        repeat: true,
                        showTwoGlows: true,
                        repeatPauseDuration: Duration(milliseconds: 100),

                        child: Material(     // Replace this child with your own
                            elevation: 8.0,
                            shape: CircleBorder(),
                            child: CircleAvatar(
                              backgroundColor: Color(0xFFFFFFFF),

                              child: IconButton(
                                  iconSize: 200,
                                  icon: AnimatedIcon(
                                    icon: AnimatedIcons.pause_play,
                                    progress: animationController,
                                    color: Color(0xFF000000),
                                    size: 55,
                                  ),

                                  onPressed: () async
                                  {
                                    audioPlayer.onPlayerStateChanged.listen((PlayerState s) {

                                     // print(' player state: $s');
                                      if(s==PlayerState.PLAYING){
                                        // if(countTimes==0)
                                        // {
                                        //   //notificationDetail.updateNotificationMediaPlayer(10,true, songName);
                                        //
                                        //   countTimes++;
                                        //   isPlaying=true;
                                        //   animationController.reverse();
                                        //   pause();
                                        // }
                                        // else
                                        //   {
                                           // notificationDetail.updateNotificationMediaPlayer(10,true, songName);
                                        print(s.toString()+" 500 "+isPlaying.toString());

                                            // isPlaying=false;
                                            animationController.reverse();

                                         // }

                                       // print("PAUSING EMER");
                                      }
                                      else {
                                        animationController.forward();

                                        // isPlaying=true;
                                      }
                                     // print(isPlaying);
                                    });

                                    print("528 "+isPlaying.toString());

                                    if(!isPlaying)
                                    {
                                      play(songNumber);
                                       // isPlaying=true;

                                    }
                                    else if(isPlaying)
                                    {
                                     // print("PAUSING EMER2");
                                      pause();
                                       // isPlaying=false;

                                    }

                                  },
                                ),

                              radius: 35.0,
                            ),
                        ),

                    ),
                SizedBox(width: 10,),

                IconButton(
                      iconSize: 50,
                      icon: Icon(Icons.skip_next_rounded),
                      color: Color(0xFFFFFFFF),

                      onPressed: ()
                      {
                        next();
                      },
                  ),

                SizedBox(width: 10,),

                IconButton(
                  iconSize: 35,
                  icon: Icon(Icons.shuffle_outlined),
                  color: shuffle?Colors.red[800]:Color(0xFFFFFFFF),

                  onPressed: ()
                  {

                    if(shuffle){
                        shuffle=false;
                      }
                    else{
                      shuffle=true;
                    }

                  },
                ),

              ],
            ),

        ],
        ),
      )

      );


  }

  songNameLenght(){
    if(songName.length>20)
    {
      return ScrollingText(
        text: songName,
        textStyle: const TextStyle(fontSize: 32,color: Colors.white,fontWeight: FontWeight.bold,fontFamily:'Proxima Nova'),
      );
    }
    else {
      return Text(songName, style: const TextStyle(fontSize: 32,color: Colors.white,fontWeight: FontWeight.bold,fontFamily:'Proxima Nova'),textAlign:  TextAlign.center,);
    }
  }
}




















/*  _updatePalette() async { Gets the avg color of img
    bgColors = [];
    for(String image in images) {
      PaletteGenerator palette = await PaletteGenerator.fromImageProvider(
        AssetImage(image),
        size: Size(200, 100),
      );
      palette.darkMutedColor != null ? bgColors.add(palette.darkMutedColor) : bgColors.add(PaletteColor(Colors.red,3));
    }
    setState(() {});
  }




  avg color Code
 decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFFe63946), Colors.black.withOpacity(0.6)],
                stops: [0.0, 0.4],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                tileMode: TileMode.repeated)),

  */
