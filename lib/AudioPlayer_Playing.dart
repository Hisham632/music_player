import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:music_player/TextScroll.dart';

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


class AudioPlay extends StatefulWidget {
  final int number;
  final String path;



  const AudioPlay({Key? key,
    required this.number,required this.path

  }) : super(key: key);

  @override
  _AudioPlayState createState() => _AudioPlayState();
}



class _AudioPlayState extends State<AudioPlay> with TickerProviderStateMixin {

  int countTimes=0;



  late AudioPlayer audioPlayer;
  late AudioCache player=player = AudioCache();
  Duration fileDuration= Duration();
  Duration position= Duration();
  bool isPlaying=false;
  late List<FileSystemEntity> listOfAllFolderAndFiles;
  String songName='', lastSongPlayed='';//not used
  bool liked = false;
  late List<FileSystemEntity> tempPathOld;

  late AnimationController animationController;
  int songNumber=1;

  void initPlayer() async {
    //final manifestJson = await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    //final Map<String, dynamic> manifestMap = json.decode(manifestJson);
    AwesomeNotifications().requestPermissionToSendNotifications();
    // AwesomeNotifications().actionStream.listen((isPlaying) {
    //
    //
    //   notificationDetail.updateNotificationMediaPlayer(100,true, songName);
    //
    //
    // });
    notificationDetail.updateNotificationMediaPlayer(10,true, songName);

    audioPlayer = AudioPlayer();
    player = AudioCache(fixedPlayer: audioPlayer);
    animationController=AnimationController(vsync: this,duration: Duration(milliseconds: 500),reverseDuration: Duration(milliseconds: 500) );


    //player.load('assets/misfit.mp3');
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

  }

  void initState()
  {
    super.initState();
    initPlayer();
  }


  play(songNum) async {
    //player.play(song);
    String song = listOfAllFolderAndFiles[songNum].toString().substring(7, listOfAllFolderAndFiles[songNum].toString().length - 1);
    songName=listOfAllFolderAndFiles[songNum].toString().split('/').last.substring(0,listOfAllFolderAndFiles[songNum].toString().split('/').last.length-6);
    //lastSongPlayed=song;
    //lastSongPlayed=songNum;//might need to do in a list since might go back multiple times
    // if(Lists.playNextNum!=-1) {
    //   listOfAllFolderAndFiles = tempPathOld; //Putting back to og Path
    //   Lists.playNextNum==-1;
    // }
    audioPlayer.play(song, isLocal: true);

    audioPlayer.onPlayerCompletion.listen((event) {// when the song ends call the next()
      next();
    });


    }

  pause(){
    audioPlayer.pause();
  }
  stop(){
    audioPlayer.stop();
  }

  resume(){
    audioPlayer.resume();
  }

  next(){

    //if(Lists.playNextNum==-1){
      //ig just +1 to songNum
      songNumber+=1;
      if(listOfAllFolderAndFiles.length<songNumber)
      {
        songNumber=1;
      }
      play(songNumber);

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
previous(){
   // play(lastSongPlayed);
  songNumber-=1;

  if(songNumber<1)
  {
    songNumber=listOfAllFolderAndFiles.length;
  }
  play(songNumber);

}

timeStamp()
{
  if(position.inSeconds.remainder(60)>10)
    {
      return position.inSeconds.remainder(60);
    }
  else {
    return "0"+position.inSeconds.remainder(60).toString();
  }
}
fileTimeStamp()
{
    if(fileDuration.inSeconds.remainder(60)>10)
    {
      return fileDuration.inSeconds.remainder(60);
    }
    else {
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

      // appBar: AppBar(
      //     title: Text('Clean',textAlign: TextAlign.center,style: TextStyle(color: Colors.black),)),
       body: Container(
         height: mediaQueryData.size.height,
         width: mediaQueryData.size.width,
        decoration:  BoxDecoration(

            image: DecorationImage(image: FileImage(File('/storage/emulated/0/Android/data/com.example.music_player/files/pictures/$imageSaveName.jpg')), fit: BoxFit.cover, opacity: 0.1),//HERE IS backgroundColor

            gradient: LinearGradient(
                colors: [Color(0xFF616161), Color(0xFF212121)],
                stops: [0.05, 0.62],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                tileMode: TileMode.repeated)),

        child: Column(
          children: [
           // SizedBox(height: 40,),

            Row(
              children: [
                SizedBox(width: 10,),
                IconButton(
                  iconSize: 32,
                  icon: Icon(MyIcons.chevron_down_1),
                  color: Color(0xFF212121),//632

                  alignment: Alignment.topLeft,

                  onPressed: ()
                  {
                    //previous();
                  },
                ),
              ],
            ),
           // SizedBox(height: 20,),
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
          ),//SizedBox(height: 23,),

            Container(
              child: songNameLenght(),
              height: 45,
              width: 380,
            )
         ,//SizedBox(height: 30,),
            Row(
              children: [

                Text(" ${position.inMinutes}:${timeStamp()}",style: TextStyle(color: Color(0xFFFFFFFF),fontSize: 16,fontWeight: FontWeight.bold,fontFamily:'Proxima Nova' ),),
                SizedBox(
                  width: 305,
                  child: Slider(
                      min: 0,
                      max: fileDuration.inSeconds.toDouble(),
                      value: position.inSeconds.toDouble(),
                      activeColor: Color(0xFFFFFFFF),//0xFF35325e
                      inactiveColor: Colors.grey[800],
                      onChanged: (double value){
                        setState(() {
                          audioPlayer.seek(new Duration(seconds: value.toInt()));
                        });
                      }
                  ),
                ),
                Text("${fileDuration.inMinutes}:${fileTimeStamp()}",style: TextStyle(color: Color(0xFFFFFFFF),fontSize: 16,fontWeight: FontWeight.bold,fontFamily:'Proxima Nova' ),),

              ],
            ),


       // SizedBox(height: 15,),

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
                      print("{RESSSED");
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
                                        if(countTimes==0)
                                        {
                                          notificationDetail.updateNotificationMediaPlayer(10,true, songName);

                                          countTimes++;
                                          isPlaying=true;
                                          animationController.reverse();
                                          pause();
                                        }
                                        else
                                          {
                                            notificationDetail.updateNotificationMediaPlayer(10,true, songName);

                                            isPlaying=true;
                                            animationController.reverse();
                                          }




                                       // print("PAUSING EMER");
                                      }
                                      else {
                                        animationController.forward();

                                        isPlaying=false;
                                      }
                                     // print(isPlaying);
                                    });

                                    if(!isPlaying)
                                    {
                                      play(songNumber);
                                    }
                                    else if(isPlaying)
                                    {
                                     // print("PAUSING EMER2");
                                      pause();
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
                  icon: Icon(Icons.loop),
                  color: Color(0xFFFFFFFF),

                  onPressed: ()
                  {
                    next();

                  },
                ),

              ],
            ),

        ],
        ),
      )

      );


  }

  songNameLenght()
  {
    if(songName.length>20)
    {
      return ScrollingText(
        text: songName,
        textStyle: TextStyle(fontSize: 32,color: Colors.white,fontWeight: FontWeight.bold,fontFamily:'Proxima Nova'),
      );
    }
    else {
      return Text(songName, style: TextStyle(fontSize: 32,color: Colors.white,fontWeight: FontWeight.bold,fontFamily:'Proxima Nova'),textAlign:  TextAlign.center,);
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
