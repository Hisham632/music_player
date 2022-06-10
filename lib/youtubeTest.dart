import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Youtube Downloader"),
      ),
        backgroundColor: Colors.indigo[800],
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

              child: const Text('Download', style: TextStyle(fontSize: 18, color: Colors.purple),),
              onPressed: () async {

                var youtubeDownload = YoutubeExplode();

                if(vidDownloadChoice==Choice.Video)
                {
                  var id = VideoId("https://www.youtube.com/watch?v=2JpkMXinO1M&ab_channel=AnimelunaII");
                  var video = await youtubeDownload.videos.get(id);
                  print("HERE "+video.thumbnails.highResUrl);

                  setState(() {
                    vidTitle=video.title;
                    author=video.author;
                    vidImage=video.thumbnails.highResUrl;
                    vidLenght=video.duration!.inSeconds;

                  });
                  await Permission.storage.request();

                  var manifest = await youtubeDownload.videos.streamsClient.getManifest(id);
                  var audio = manifest.audioOnly.withHighestBitrate();

                  Directory dir = Directory('/storage/emulated/0/AudioFiles/');
                  var filePath = path.join(dir.uri.toFilePath(),'${video.title}.${audio.container.name}');
                  var file = File(filePath);
                  var fileStream = file.openWrite();
                  var audioStream = await youtubeDownload.videos.streamsClient.get(audio);

                  var len = audio.size.totalBytes;
                  var count = 0, progress;

                  await for (final data in audioStream)
                  {
                    count += data.length;

                    progress = ((count / len) * 100).ceil();

                    print("Progress: $progress");
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
                  var playlist = await youtubeDownload.playlists.get('https://www.youtube.com/playlist?list=PLuvVjLDbzSdFKzS_SxKKB75qdqErTnMBC');

                  var title = playlist.title;
                  print(title);
                  await Permission.storage.request();
                  Directory dir = Directory('/storage/emulated/0/AudioFiles/$title/');

                  setState(() {
                    vidTitle=title;
                    author=playlist.author;
                    vidImage=playlist.thumbnails.highResUrl;
                    vidNum=playlist.videoCount!;
                  });


                  await for (var video in youtubeDownload.playlists.getVideos(playlist.id)) {

                    print("HERE "+video.title);
                    var manifest = await youtubeDownload.videos.streamsClient.getManifest(video.id);
                    var audio = manifest.audioOnly.withHighestBitrate();

                    var filePath;
                    if ((await dir.exists())){
                      filePath = path.join(dir.uri.toFilePath(),'${video.title}.${audio.container.name}');

                    }else{
                      dir.create();
                      filePath = path.join(dir.uri.toFilePath(),'${video.title}.${audio.container.name}');

                    }

                    var file = File(filePath);
                    var fileStream = file.openWrite();
                    var audioStream = await youtubeDownload.videos.streamsClient.get(audio);

                    var len = audio.size.totalBytes;
                    var count = 0, progress;

                    await for (final data in audioStream)
                    {
                      count += data.length;

                      progress = ((count / len) * 100).ceil();

                      print("Progress: $progress");
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

      Row(
        children: [
          Expanded(
              flex: 1,
              child:  Image.network(vidImage.toString(),width: 200,height: 200,),
          ),
          Expanded(flex:1,
              child: Text(vidTitle+" Lenght: "+vidLenght.toString()+" "+author+"   "+downloadProgress.toString()+"%")
          ),

        ],
      ),



        ],
      ),
    );



  }
}
