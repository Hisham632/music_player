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

  late AnimationController animationController;
  int songNumber=1;

  void initPlayer() async {
    //final manifestJson = await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    //final Map<String, dynamic> manifestMap = json.decode(manifestJson);
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
    songName=listOfAllFolderAndFiles[songNum].toString().split('/').last.substring(0,listOfAllFolderAndFiles[songNum].toString().split('/').last.length-5);
    //lastSongPlayed=song;
    //lastSongPlayed=songNum;//might need to do in a list since might go back multiple times
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
    //ig just +1 to songNum
    songNumber+=1;
    if(listOfAllFolderAndFiles.length<songNumber)
      {
        songNumber=1;
      }
    play(songNumber);

    //audioPlayer.onPlayerCompletion
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
    return Scaffold(
        backgroundColor: Colors.indigo[600],

      // appBar: AppBar(
      //     title: Text('Clean',textAlign: TextAlign.center,style: TextStyle(color: Colors.black),)),
       body: Container(
        decoration: BoxDecoration(//HERE IS backgroundColor
            gradient: LinearGradient(
                colors: [Color(0xFFe63946), Colors.black.withOpacity(0.6)],
                stops: [0.0, 0.7],
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
                  icon: Icon(MyIcons.chevron_down_1),
                  color: Colors.lightGreen[400],

                  alignment: Alignment.topLeft,

                  onPressed: ()
                  {
                    //previous();
                  },
                ),
              ],
            ),
            SizedBox(height: 10,),
          Center(
            child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('Images/Soundtrack_album_cover.jpg'),
                    fit: BoxFit.fill,
                  ),
                  borderRadius:  BorderRadius.all(Radius.circular(15.0)),
                ),
              alignment: Alignment.center,
              width: 350,
              height: 380,
            ),
          ),SizedBox(height: 20,),

            Container(
              child: ScrollingText(
                text: songName,
                textStyle: TextStyle(fontSize: 32,color: Colors.red[900],fontWeight: FontWeight.bold,fontFamily:'lato'),
              ),
              height: 60,
              width: 380,
            )
         ,SizedBox(height: 20,),
            Row(
              children: [

                Text(" ${position.inMinutes}:${timeStamp()}",style: TextStyle(color: Colors.deepPurple,fontSize: 16,fontWeight: FontWeight.bold,fontFamily:'lato' ),),
                SizedBox(
                  width: 335,
                  child: Slider(
                      min: 0,
                      max: fileDuration.inSeconds.toDouble(),
                      value: position.inSeconds.toDouble(),
                      activeColor: Colors.deepPurple,
                      inactiveColor: Colors.blueGrey,
                      onChanged: (double value){
                        setState(() {
                          audioPlayer.seek(new Duration(seconds: value.toInt()));
                        });
                      }
                  ),
                ),
                Text("${fileDuration.inMinutes}:${fileTimeStamp()}",style: TextStyle(color: Colors.deepPurple,fontSize: 16,fontWeight: FontWeight.bold,fontFamily:'lato' ),),

              ],
            ),


         SizedBox(height: 30,),

            Row(//buttons row
              children: [
                SizedBox(width: 15,),

                IconButton(
                    iconSize: 30,
                    icon: Icon(LikeButton.heart),
                    color: Colors.deepPurple[900],

                    onPressed: ()
                    {


                    },
                  ),
                SizedBox(width: 15,),
                IconButton(
                    iconSize: 50,
                    icon: Icon(Icons.skip_previous_rounded),
                    color: Colors.green,

                    onPressed: ()
                    {
                      previous();
                    },
                  ),
                SizedBox(width: 20),

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
                              backgroundColor: Colors.indigo[400],

                              child: IconButton(
                                  iconSize: 200,
                                  icon: AnimatedIcon(
                                    icon: AnimatedIcons.pause_play,
                                    progress: animationController,
                                    color: Colors.deepOrange,
                                    size: 55,
                                  ),

                                  onPressed: () async
                                  {
                                    audioPlayer.onPlayerStateChanged.listen((PlayerState s) {

                                     // print(' player state: $s');
                                      if(s==PlayerState.PLAYING){
                                        if(countTimes==0)
                                        {
                                          countTimes++;
                                          isPlaying=true;
                                          animationController.reverse();
                                          pause();
                                        }
                                        else
                                          {
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
                SizedBox(width: 38,),

           IconButton(
                      iconSize: 50,
                      icon: Icon(Icons.skip_next_rounded),
                      color: Colors.green,

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
