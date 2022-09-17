import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import 'Grids.dart';


enum Choice {  Video,Playlist }
class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final textController = TextEditingController();
  Choice? vidDownloadChoice = Choice.Video;

  String vidImage="";
   String vidTitle="";
  String author="";
   int vidLenght=0;
   int downloadProgress=0;
   int vidNum=0;
  String playlistTitle="";

  void initPlayerPermission() async {
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
        Permission.accessMediaLocation,

      ].request();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Youtube Downloader"),
      ),
        backgroundColor: Color(0xFF06152e),
        drawer: Drawer(
          // shape: ,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.black,
                ), child: null,
              ),
              ListTile(
                leading: Icon(Icons.whatshot),
                title: Text('Main'),
                textColor: Colors.deepOrange,
                iconColor: Colors.deepOrange,
                hoverColor: Colors.deepPurple,
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Playlists(),
                    ),
                  );
                  //print('clicked '+listOfAllFolderAndFiles[songNum].toString().split('/').last.substring(0,listOfAllFolderAndFiles[songNum].toString().split('/').last.length-5));

                },
              ),
              ListTile(
                leading: Icon(Icons.whatshot),
                title: Text('Youtube Downloader'),
                textColor: Colors.deepOrange,
                iconColor: Colors.deepOrange,
                hoverColor: Colors.deepPurple,
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyHomePage(title: ''),
                    ),
                  );
                },
              ),

            ],
          ),
        ),
      body: Column(//row
        children:[

      //Text("Type:",style: TextStyle(color: Colors.blue,fontSize: 18,fontWeight: FontWeight.bold,fontFamily:'lato' ),textAlign: TextAlign.left,),
          SizedBox(height: 10),

          RadioListTile<Choice>(
                title: Text('Video'),
                value: Choice.Video,
            groupValue: vidDownloadChoice,

            onChanged: (Choice? value) {
                  setState(() {
                  vidDownloadChoice=value;
                });
                  },
              ),
          RadioListTile<Choice>(
            title: Text('Playlist'),
            value: Choice.Playlist,
            groupValue: vidDownloadChoice,

            onChanged: (Choice? value) {
              setState(() {
                vidDownloadChoice=value;
              });
            },
          ),
          SizedBox(height: 50),


          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: textController,
                decoration: const InputDecoration(//add more
                    hintText: 'Enter Youtube Link', alignLabelWithHint: true,
                    border:OutlineInputBorder(),
                    fillColor: Colors.deepOrange

                ),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.green, fontSize: 16),

            ),
          ),
          ElevatedButton(

              child: const Text('Download', style: TextStyle(fontSize: 18, color: Color(0xFF3a1566)),),
              onPressed: () async {

                var youtubeDownload = YoutubeExplode();

                if(vidDownloadChoice==Choice.Video)
                {
                  var id = VideoId(textController.text.toString());
                  var video = await youtubeDownload.videos.get(id);
                  //print("HERE "+video.thumbnails.highResUrl);

                  setState(() {
                    vidTitle=video.title;
                    author=video.author;
                    vidImage=video.thumbnails.highResUrl;
                    vidLenght=video.duration!.inSeconds;

                  });
                  await Permission.storage.request();

                  var manifest = await youtubeDownload.videos.streamsClient.getManifest(id);
                  var audio = manifest.audioOnly.withHighestBitrate();

                  initPlayerPermission();

                 // Directory directory2 = await getExternalStorageDirectory() as Directory;
                  //print("TEEMP");
                 // print(directory2);

                  Directory dir = Directory('/storage/emulated/0/AudioFiles/');
                  var filePath = path.join(dir.uri.toFilePath(),'${video.title}.${audio.container.name}');

                  print(filePath);

                  if(Directory(filePath).existsSync()){
                    print("EXists");

                  }
                  else
                    {
                      print("NOT exist");

                      try{
                        File(filePath).createSync(recursive: true);
                      }catch(e){
                        print("Error: "+e.toString());
                      }
                    }



                  var file=File(filePath);
                  var fileStream = file.openWrite();
                  var audioStream = await youtubeDownload.videos.streamsClient.get(audio);

                  var len = audio.size.totalBytes;
                  var count = 0, progress;

                  await for (final data in audioStream)
                  {
                    count += data.length;

                    progress = ((count / len) * 100).ceil();

                   // print("Progress: $progress");
                    setState(() {
                      downloadProgress=progress;
                    });

                    fileStream.add(data);
                  }
                  await fileStream.flush();
                  await fileStream.close();


                }
                else if(vidDownloadChoice==Choice.Playlist)
                {

                  // Get playlist metadata.
                  var playlist = await youtubeDownload.playlists.get(textController.text.toString());

                  var title = playlist.title;
                  //print(title);
                  await Permission.storage.request();
                  Directory dir = Directory('/storage/emulated/0/AudioFiles/$title/');
                 // Directory directory2 = await getExternalStorageDirectory() as Directory;


                  setState(() {
                    playlistTitle=title;
                    author=playlist.author;
                    vidImage=playlist.thumbnails.highResUrl;
                    vidNum=playlist.videoCount!;
                  });


                  await for (var video in youtubeDownload.playlists.getVideos(playlist.id)) {

                    setState(() {
                      vidTitle=video.title;
                    });

                   // print("HERE "+video.title);
                    var manifest = await youtubeDownload.videos.streamsClient.getManifest(video.id);
                    var audio = manifest.audioOnly.withHighestBitrate();
                    var filePath = path.join(dir.uri.toFilePath(),'${video.title}.${audio.container.name}');

                    //var filePath;
                    if(Directory(filePath).existsSync()){
                      print("EXists");

                    }
                    else
                    {
                      print("NOT exist");

                      try{
                        File(filePath).createSync(recursive: true);
                      }catch(e){
                        print("Error: "+e.toString());
                      }
                    }

                   // if ((await directory2.exists())){

                    // }else{
                    //   directory2.create();
                    //   filePath = path.join(directory2.uri.toFilePath(),'/$title/${video.title}.${audio.container.name}');
                    //
                    // }
                   // print("GOING IN");

                    var file = File(filePath);
                    var fileStream = file.openWrite();
                    var audioStream = await youtubeDownload.videos.streamsClient.get(audio);

                    var len = audio.size.totalBytes;
                    var count = 0, progress;

                    await for (final data in audioStream)
                    {
                      count += data.length;

                      progress = ((count / len) * 100).ceil();

                     // print("Progress: $progress");
                      setState(() {
                        downloadProgress=progress;
                      });

                      fileStream.add(data);
                    }
                    await fileStream.flush();
                    await fileStream.close();

                  }



                }

              }),

          const SizedBox(height: 15),





        ],
      ),
    );



  }
}
