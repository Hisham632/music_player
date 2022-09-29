import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:image_downloader/image_downloader.dart';

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
  String playListImage="";

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
        title: Text("Youtube Downloader",style: TextStyle(fontFamily:"Proxima Nova")),
      ),
        backgroundColor: Color(0xFF111213),
        drawer: Drawer(
          backgroundColor:  Color(0xFF111213),
          // shape: ,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              SizedBox(height: 30,)
              ,
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                textColor: Color(0xFF4c7dad),
                iconColor: Color(0xFF4c7dad),
                hoverColor: Color(0xFF4c7dad),
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
                leading: Icon(Icons.download),
                title: Text('Youtube Downloader'),
                textColor: Color(0xFF4c7dad),
                iconColor: Color(0xFF4c7dad),
                hoverColor: Color(0xFF4c7dad),
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
                title: Text('Video',style: TextStyle(fontFamily:"Proxima Nova")),
                value: Choice.Video,
            groupValue: vidDownloadChoice,

            onChanged: (Choice? value) {
                  setState(() {
                  vidDownloadChoice=value;
                });
                  },
              ),
          RadioListTile<Choice>(
            title: Text('Playlist',style: TextStyle(fontFamily:"Proxima Nova")),
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

              child: const Text('Download', style: TextStyle(fontSize: 18, color: Color(0xFF212121)),),
              onPressed: () async {

                var youtubeDownload = YoutubeExplode();

                if(vidDownloadChoice==Choice.Video)
                {
                  var id = VideoId(textController.text.toString());
                  var video = await youtubeDownload.videos.get(id);

                  setState(() {
                    vidTitle=video.title.replaceAll("/", '').replaceAll(':', '').replaceAll('.', '').replaceAll('[', '(').replaceAll(']',')').replaceAll("\"",'').replaceAll('*','').replaceAll('"','').replaceAll('<','').replaceAll('>','').replaceAll('|','');
                    author=video.author;
                    vidImage=video.thumbnails.maxResUrl;
                    vidLenght=video.duration!.inSeconds;

                  });
                  await Permission.storage.request();

                  var manifest = await youtubeDownload.videos.streamsClient.getManifest(id);
                  var audio = manifest.audioOnly.withHighestBitrate();

                  initPlayerPermission();

                  Directory directory2 = await getExternalStorageDirectory() as Directory;
                  //print("TEEMP");
                 // print(directory2);
                  print("LINE182");
                  print(vidTitle);
                  Directory dir = Directory('/storage/emulated/0/Android/data/com.example.music_player/AudioFiles/Songs/');
                  var filePath = path.join(dir.uri.toFilePath(),'$vidTitle.${audio.container.name}');

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
                  var imageSaveName=vidTitle.replaceAll(RegExp(r'[^\p{Alphabetic}\p{Mark}\p{Decimal_Number}\p{Connector_Punctuation}\p{Join_Control}\s]', unicode: true),'');

                  try{
                    print(imageSaveName);


                    await ImageDownloader.downloadImage(vidImage.toString(),
                      destination: AndroidDestinationType.custom(directory: '')
                        ..inExternalFilesDir()
                        ..subDirectory("pictures/$imageSaveName.jpg"),
                    ).timeout(const Duration(seconds: 15),onTimeout: () => throw TimeoutException('Cant connect in 15 seconds.'));
                  }
                  catch(e){
                    var nameFix="itachi";

                    File imageFile= File('/storage/emulated/0/Android/data/com.example.music_player/files/pictures/$nameFix.jpg');
                    imageFile.copySync('/storage/emulated/0/Android/data/com.example.music_player/files/pictures/$imageSaveName.jpg');

                  }

                }
                else if(vidDownloadChoice==Choice.Playlist)
                {

                  // Get playlist metadata.( r'[^\p{Alphabetic}\p{Mark}\p{Decimal_Number}\p{Connector_Punctuation}\p{Join_Control}\s]+-()', unicode: true)
                  var playlist = await youtubeDownload.playlists.get(textController.text.toString());

                  var title = playlist.title.replaceAll("/", '').replaceAll(':', '').replaceAll('.', '').replaceAll('[', '(').replaceAll(']',')').replaceAll("\"",'').replaceAll('*','').replaceAll('"','').replaceAll('<','').replaceAll('>','').replaceAll('|','');
                  //print(title);
                  await Permission.storage.request();
                  Directory dir = Directory('/storage/emulated/0/Android/data/com.example.music_player/AudioFiles/$title/');
                 // Directory directory2 = await getExternalStorageDirectory() as Directory;


                  setState(() {
                    playlistTitle=title;
                    author=playlist.author;

                    playListImage=playlist.thumbnails.maxResUrl;
                    vidNum=playlist.videoCount!;
                  });

                  var imageSaveName=playlistTitle.replaceAll(RegExp(r'[^\p{Alphabetic}\p{Mark}\p{Decimal_Number}\p{Connector_Punctuation}\p{Join_Control}\s]', unicode: true),'');


                  var somePlaylistVideos = await youtubeDownload.playlists.getVideos(playlist.id).take(1).toList();
                  print(somePlaylistVideos[0].title);


                  try{


                    await ImageDownloader.downloadImage(somePlaylistVideos[0].thumbnails.maxResUrl,
                        destination: AndroidDestinationType.custom(directory: '')
                          ..inExternalFilesDir()
                          ..subDirectory("pictures/$imageSaveName.jpg")


                    ).timeout(const Duration(seconds: 10),onTimeout: () => throw TimeoutException('Can\'t connect in 10 seconds.'));

                  }
                  catch(e){

                    var nameFix="itachi.jpg";

                    File imageFile= File('/storage/emulated/0/Android/data/com.example.music_player/files/pictures/$nameFix');
                    imageFile.copySync('/storage/emulated/0/Android/data/com.example.music_player/files/pictures/$imageSaveName.jpg');

                  }

                  await for (var video in youtubeDownload.playlists.getVideos(playlist.id)) {

                    setState(() {


                      vidTitle=video.title.replaceAll("/", '').replaceAll(':', '').replaceAll('.', '').replaceAll('[', '(').replaceAll(']',')').replaceAll("\"",'').replaceAll('*','').replaceAll('"','').replaceAll('<','').replaceAll('>','').replaceAll('|','');
                      vidImage=video.thumbnails.maxResUrl;

                    });

                   // print("HERE "+video.title);
                    var manifest = await youtubeDownload.videos.streamsClient.getManifest(video.id);
                    var audio = manifest.audioOnly.withHighestBitrate();
                    var filePath = path.join(dir.uri.toFilePath(),'${video.title}.${audio.container.name}');

                    //var filePath;
                    if(Directory(filePath).existsSync()){
                      print("Exists");

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

                    var imageSaveName2=vidTitle.replaceAll(RegExp(r'[^\p{Alphabetic}\p{Mark}\p{Decimal_Number}\p{Connector_Punctuation}\p{Join_Control}\s]', unicode: true),'');


                    try{


                      File imageFile= File('/storage/emulated/0/Android/data/com.example.music_player/files/pictures/$imageSaveName.jpg');
                      imageFile.copySync('/storage/emulated/0/Android/data/com.example.music_player/files/pictures/$imageSaveName2.jpg');

                    }
                    catch(e){

                      var nameFix="itachi.jpg";

                      File imageFile= File('/storage/emulated/0/Android/data/com.example.music_player/files/pictures/$nameFix');
                      imageFile.copySync('/storage/emulated/0/Android/data/com.example.music_player/files/pictures/$imageSaveName2.jpg');

                    }

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
                  child: Column(
                    children: [
                      Text(vidTitle, style: TextStyle(color: Colors.red[900],fontSize: 18,fontWeight: FontWeight.bold,fontFamily:'Proxima Nova' ),),
                      Text("Duration: "+(vidLenght/60).toString()+":"+(vidLenght%60).toString(), style: TextStyle(color: Colors.red[900],fontSize: 14,fontWeight: FontWeight.bold,fontFamily:'Proxima Nova' ),),
                      Text("Author: "+author, style: TextStyle(color: Colors.red[900],fontSize: 18,fontWeight: FontWeight.bold,fontFamily:'Proxima Nova' )),
                      Text(downloadProgress.toString()+"%", style: TextStyle(color: Colors.red[900],fontSize: 18,fontWeight: FontWeight.bold,fontFamily:'Proxima Nova' )),
                      Text("Number of videos in"+playlistTitle+" is "+vidNum.toString(), style: TextStyle(color: Colors.red[900],fontSize: 18,fontWeight: FontWeight.bold,fontFamily:'Proxima Nova' )),

                    ],
                  )
              ),

            ],
          ),



        ],
      ),
    );



  }
}
/*
  Row(
        children: [
          Expanded(
              flex: 1,
              child:  Image.network(vidImage.toString(),width: 200,height: 200,),
          ),
          Expanded(flex:1,
              child: Column(
                children: [
                  Text(vidTitle, style: TextStyle(color: Colors.red[900],fontSize: 18,fontWeight: FontWeight.bold,fontFamily:'lato' ),),
                  Text("Duration: "+(vidLenght/60).toString()+":"+(vidLenght%60).toString(), style: TextStyle(color: Colors.red[900],fontSize: 14,fontWeight: FontWeight.bold,fontFamily:'lato' ),),
                  Text("Author: "+author, style: TextStyle(color: Colors.red[900],fontSize: 18,fontWeight: FontWeight.bold,fontFamily:'lato' )),
                  Text(downloadProgress.toString()+"%", style: TextStyle(color: Colors.red[900],fontSize: 18,fontWeight: FontWeight.bold,fontFamily:'lato' )),
                  Text("Number of videos in"+playlistTitle+" is "+vidNum.toString(), style: TextStyle(color: Colors.red[900],fontSize: 18,fontWeight: FontWeight.bold,fontFamily:'lato' )),

                ],
              )
          ),

        ],
      ),

 */