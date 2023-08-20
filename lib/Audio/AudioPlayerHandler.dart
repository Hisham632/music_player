import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';

import '../TextScroll.dart';
import '../like_button_icons.dart';
import '../my_icons_icons.dart';


class AudioPlayerManager extends StatefulWidget {
  const AudioPlayerManager({Key? key, required this.path, required this.index}) : super(key: key);
  final String path;
  final int index;

  @override
  State<AudioPlayerManager> createState() => _AudioPlayerManagerState();
}

class _AudioPlayerManagerState extends State<AudioPlayerManager> with TickerProviderStateMixin {
  late final String folderPath;
  late AudioPlayer audioPlayer;
  AnimationController? animationController;
  Map<int,String> pathToIndexMap = {};
  bool shuffle=false;
  bool liked = false;
  double _sliderValue = 0.0;

  @override
  void initState() {
    super.initState();

    print("Inside");

    loadAudioFiles(widget.path);
  }

  void initPlayer() async {


    // player = AudioCache(fixedPlayer: audioPlayer);


    // audioPlayer.onDurationChanged.listen((Duration duration) {
    //   // print('duration $duration');
    //   setState(() {
    //     fileDuration=duration;
    //   });
    // });
    //
    // audioPlayer.onAudioPositionChanged.listen((Duration position2) {
    //   //print('Current position: $position');
    //   setState(() {
    //     position=position2;
    //   });
    // });

    // print("TESTING HERELLL");
    // print(widget.path);
    // Directory dir = Directory(widget.path);
    // listOfAllFolderAndFiles = dir.listSync(recursive: true);
    // //print(listOfAllFolderAndFiles);//has all the files from the directory
    // // print('Number is:'+widget.number.toString());
    // songNumber=widget.number;
    //
    // AudioPlayer.players.forEach((key, value) {
    //   value.stop();
    // });

    // if(songNumber!=-1)
    // {
    //   play(songNumber,'');
    // }
  }
  void dispose() {
    // audioPlayer.dispose();

    animationController?.dispose();
    audioPlayer.dispose();

    super.dispose();
  }
  void loadAudioFiles(path) async {

     audioPlayer = AudioPlayer();

    List<AudioSource> audioFilesPlaylist = [];
    print("Inside");


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

    animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 500),
        reverseDuration: Duration(milliseconds: 500));


    Directory dir = Directory(path);
    final String folderPath = dir.path;


    // Fetch audio files from the directory
    List<File> audioFiles =Directory(folderPath)
        .listSync(recursive: true)
        .whereType<File>().toList();

    for (int i = 0; i < audioFiles.length; i++) {
      var element = audioFiles[i];
      AudioSource source = AudioSource.uri(Uri.file(element.path));
      print(element.path);
      audioFilesPlaylist.add(source);
      pathToIndexMap[i] = element.path;  // Map the path to its index
    }
     print("DONE33");


    //     .forEach((element) {
    //   AudioSource source = AudioSource.uri(Uri.file(element.path));
    //   print("element.path");
    //
    //   print(element.path);
    //   audioFilesPlaylist.add(source);
    // });

    // Create a concatenating audio source with the audio files
    final playlist = ConcatenatingAudioSource(
      children: audioFilesPlaylist,
      shuffleOrder: DefaultShuffleOrder(),
    );



    try {
      await audioPlayer.setAudioSource(playlist);
    } catch (e) {
      // catch load errors: 404, invalid url etc.
      print("AudioHandler error occurred ${e.toString()}");
    }
     audioPlayer.positionStream.listen((position) {
       setState(() {
         _sliderValue = position.inSeconds.toDouble();
       });
     });

    await audioPlayer.seek(Duration.zero, index: widget.index);

    play();
  }

  void play() async {
    await audioPlayer.play();
  }

  void pause() async {
    await audioPlayer.pause();
  }

  void next() async {
    if(audioPlayer.hasNext){
      await audioPlayer.seekToNext();

    }
    else{
      await audioPlayer.seek(Duration.zero, index: 0);
    }

  }

  void previous() async {
    if(audioPlayer.hasPrevious){
      await audioPlayer.seekToPrevious();

    }
    else{
      print("await sequence");

      print(await audioPlayer.sequence);
      await audioPlayer.seek(Duration.zero, index: 0);
    }  }

  void shuffleSongs() async {
    bool shuffleEnabled = audioPlayer.shuffleModeEnabled;
    await audioPlayer.setShuffleModeEnabled(!shuffleEnabled);
    await audioPlayer.shuffle();
  }
  songName() async {
    print("INDEX3");
    print(audioPlayer.currentIndex);
    print(widget.index);
    String songName2;
    int? currentIndex=widget.index;
    while(audioPlayer.currentIndex==null){
      await Future.delayed(const Duration(seconds: 2));

    }
      currentIndex=audioPlayer.currentIndex;
      String? songPath=pathToIndexMap[currentIndex];
      print(songPath);
      songName2=songPath.toString().split('/').last.substring(0,pathToIndexMap[currentIndex].toString().split('/').last.length-5);



    // String imageSaveName=songName.replaceAll(RegExp(r'[^\p{Alphabetic}\p{Mark}\p{Decimal_Number}\p{Connector_Punctuation}\p{Join_Control}\s]', unicode: true),'');

    return songName2;

    // audioFilesPlaylist
    // await audioPlayer.sequence.
  }

  // @override
  // Widget build(BuildContext context) {
  //
  //   String imageSaveName=songName().replaceAll(RegExp(r'[^\p{Alphabetic}\p{Mark}\p{Decimal_Number}\p{Connector_Punctuation}\p{Join_Control}\s]', unicode: true),'');
  //
  //   return Scaffold(resizeToAvoidBottomInset: false,
  //     appBar: AppBar(
  //         title: Text('Clean',textAlign: TextAlign.center,style: TextStyle(color: Colors.black),)),
  //
  //     body: Column(
  //       children: [
  //         IconButton(
  //           iconSize: 32,
  //           icon: const Icon(MyIcons.chevron_down_1),
  //           color: const Color(0xFF212121),
  //           //632
  //
  //           alignment: Alignment.topLeft,
  //
  //           onPressed: () {
  //             print("PRESSED");
  //
  //             print(audioPlayer.currentIndex);
  //             play();
  //           },
  //         ),
  //         IconButton(
  //           iconSize: 55,
  //           icon: const Icon(MyIcons.chevron_down_1),
  //           color: const Color(0xFF212121),
  //           //632
  //
  //           alignment: Alignment.topLeft,
  //
  //           onPressed: () {
  //             print("Pause");
  //
  //             print(audioPlayer.currentIndex);
  //             pause();
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  //
  // }
  timeStamp(){
    if(audioPlayer.position.inSeconds.remainder(60)>=10||(audioPlayer.position.inSeconds.remainder(60).toDouble()/10==0&&audioPlayer.position.inSeconds.remainder(60).toDouble()!=0)){

      return audioPlayer.position.inSeconds.remainder(60);
    }
    else{
      return "0"+audioPlayer.position.inSeconds.remainder(60).toString();
    }
  }
  fileTimeStamp(){
    int? remainderSeconds = audioPlayer.duration?.inSeconds.remainder(60);

    if (remainderSeconds == null) {
      return "00"; // or some default value
    }

    if (remainderSeconds >= 10||(remainderSeconds.toDouble()/10==0&&remainderSeconds.toDouble()!=0)) {
      return remainderSeconds.toString();
    } else {
      return "0" + remainderSeconds.toString();
    }
  }

@override
Widget build(BuildContext context) {
  MediaQueryData mediaQueryData = MediaQuery.of(context);
  print(    'NEW POSITION:  '+'');




  return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: AppBar(
      //     title: Text('Clean',textAlign: TextAlign.center,style: TextStyle(color: Colors.black),)),

      body: FutureBuilder(
          future: songName(),

          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            print("line279");
            print(snapshot.data);

            print(animationController);
            if(snapshot.data!=null && animationController!=null){
              var imageSaveName = snapshot.data.toString().replaceAll(
                  RegExp(
                      r'[^\p{Alphabetic}\p{Mark}\p{Decimal_Number}\p{Connector_Punctuation}\p{Join_Control}\s]',
                      unicode: true),
                  '');


              return Container(
                height: mediaQueryData.size.height,
                width: mediaQueryData.size.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: FileImage(File(
                            '/storage/emulated/0/Android/data/com.example.music_player/files/pictures/$imageSaveName.jpg')),
                        fit: BoxFit.cover,
                        opacity: 0.1), //HERE IS backgroundColor

                    gradient: const LinearGradient(
                        colors: [Color(0xFF616161), Color(0xFF212121)],
                        stops: [0.05, 0.62],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        tileMode: TileMode.repeated)),
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 0,//10
                        ),
                        IconButton(
                          iconSize: 32,
                          icon: const Icon(MyIcons.chevron_down_1),
                          color: const Color(0xFF212121),
                          //632

                          alignment: Alignment.topLeft,

                          onPressed: () {
                            //previous();
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 0,//20
                    ),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(File(
                                '/storage/emulated/0/Android/data/com.example.music_player/files/pictures/$imageSaveName.jpg')),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                        alignment: Alignment.center,
                        width: 350,
                        height: 380,
                      ),
                    ),
                    SizedBox(
                      height: 0,//23
                    ),
                    Container(
                      child: songNameLenght(snapshot.data.toString()),
                      height: 45,
                      width: 380,
                    ),
                    SizedBox(
                      height: 0,//30
                    ),
                    Row(
                      children: [
                        SizedBox(
                            width: 40,
                            child: Center(
                              child: Text(
                                " ${audioPlayer.position.inMinutes}:${timeStamp()}",
                                style: const TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Proxima Nova'),
                              ),
                            )),
                        SizedBox(
                          width: 305,
                          child: Slider(
                              min: 0,
                              max: (audioPlayer.duration?.inSeconds ?? 0).toDouble(),
                              value: _sliderValue,
                              activeColor: const Color(0xFFFFFFFF),
                              //0xFF35325e
                              inactiveColor: Colors.grey[800],
                              onChanged: (double value) {
                                setState(() {
                                  _sliderValue = value;
                                });
                                  audioPlayer.seek(Duration(seconds: value.toInt()));
                              }),
                        ),
                        Text(
                          "${audioPlayer.duration?.inMinutes}:${fileTimeStamp()}",
                          style: const TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Proxima Nova'),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      //buttons row
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        IconButton(
                          iconSize: 30,
                          icon: Icon(LikeButton.heart),
                          color: liked ? Colors.red[800] : Colors.white70,
                          onPressed: () {
                            String song = pathToIndexMap[audioPlayer.currentIndex]
                                .toString()
                                .substring(
                                7,
                                pathToIndexMap[audioPlayer.currentIndex]
                                    .toString()
                                    .length -
                                    1);

                            if (Directory(
                                "/storage/emulated/0/Android/data/com.example.music_player/AudioFiles/Liked/" +
                                    songName() +
                                    ".webm")
                                .existsSync()) {
                            } else {
                              File(song).copySync(
                                  "/storage/emulated/0/Android/data/com.example.music_player/AudioFiles/Liked/" +
                                      songName() +
                                      ".webm");
                            }

                            setState(() {
                              liked = !liked;
                            });
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        IconButton(
                          iconSize: 50,
                          icon: Icon(Icons.skip_previous_rounded),
                          color: Colors.white,
                          onPressed: () {
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
                          child: Material(
                            // Replace this child with your own
                            elevation: 8.0,
                            shape: CircleBorder(),
                            child: CircleAvatar(
                              backgroundColor: Color(0xFFFFFFFF),
                              child: IconButton(
                                iconSize: 200,
                                icon: AnimatedIcon(
                                  icon: AnimatedIcons.pause_play,
                                  progress: animationController!,
                                  color: Color(0xFF000000),
                                  size: 55,
                                ),
                                onPressed: () async {
                                  if(audioPlayer.playerState.playing){
                                    pause();

                                    animationController?.forward();

                                  }else{
                                    play();
                                    animationController?.reverse();

                                  }

                                  // audioPlayer.sta onPlayerStateChanged
                                  //     .listen((PlayerState s) {
                                  //   // print(' player state: $s');
                                  //   if (s == PlayerState.PLAYING) {
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
                                  // print(s.toString()+" 500 "+isPlaying.toString());

                                  // isPlaying=false;
                                  //   animationController.reverse();
                                  //
                                  //   // }
                                  //
                                  //   // print("PAUSING EMER");
                                  // // } else {
                                  //   animationController.forward();
                                  //
                                  //     // isPlaying=true;
                                  //   }
                                  //   // print(isPlaying);
                                  // });

                                  // print("528 "+isPlaying.toString());

                                  // if (!isPlaying) {
                                  //   play(songNumber, '');
                                  //   // isPlaying=true;
                                  //
                                  // } else if (isPlaying) {
                                  //   // print("PAUSING EMER2");
                                  //   pause();
                                  //   // isPlaying=false;
                                  //
                                  // }
                                },
                              ),
                              radius: 35.0,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        IconButton(
                          iconSize: 50,
                          icon: Icon(Icons.skip_next_rounded),
                          color: Color(0xFFFFFFFF),
                          onPressed: () {
                            next();
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        IconButton(
                          iconSize: 35,
                          icon: Icon(Icons.shuffle_outlined),
                          color: shuffle ? Colors.red[800] : Color(0xFFFFFFFF),
                          onPressed: () {
                            if (shuffle) {
                              shuffleSongs();
                              shuffle = false;
                            } else {
                              shuffleSongs();
                              shuffle = true;
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
            else{
              return Container(//maybe add except sliderCOntroller
                color: Color(0xFF212121),
                child: Center(child: CircularProgressIndicator(                color: Colors.blue,
                ),),
              );
            }

        }
      ));
}

songNameLenght(String songName) {
  if (songName.toString().length > 20) {
    return ScrollingText(
      text: songName.toString(),
      textStyle: const TextStyle(
          fontSize: 32,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontFamily: 'Proxima Nova'),
    );
  } else {
    return Text(
      songName.toString(),
      style: const TextStyle(
          fontSize: 32,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontFamily: 'Proxima Nova'),
      textAlign: TextAlign.center,
    );
  }
}
}
