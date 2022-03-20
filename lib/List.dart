// show the list of all songs in a driectory then make it so when they click on it they are directed to play page and it plays it

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:music_player/AudioPlayer_Playing.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:id3/id3.dart';
import 'package:dart_tags/dart_tags.dart';
import 'package:flutter_video_info/flutter_video_info.dart';

class Lists extends StatefulWidget {
  final String folderName;

  const Lists({Key? key,
    required this.folderName,


  }) : super(key: key);

  @override
  _ListsState createState() => _ListsState();
}

class _ListsState extends State<Lists> {
  String songName='', lastSongPlayed='';//not used

  late List<FileSystemEntity> listOfAllFolderAndFiles;
  final player  = AudioPlayer();

  //late Future<String> dataValue;

initState()
   {
     int songNum=2;

    super.initState();
    //Directory dir = Directory('/storage/emulated/0/AudioFiles/');
    Directory dir = Directory(widget.folderName.substring(13, widget.folderName.length - 1));// later make sure the folder is not empty

    listOfAllFolderAndFiles = dir.listSync(recursive: true);
    print(listOfAllFolderAndFiles);//has all the files from the directory
    print(listOfAllFolderAndFiles.length);//has all the files from the directory

    String song = listOfAllFolderAndFiles[songNum].toString().substring(7, listOfAllFolderAndFiles[songNum].toString().length - 1);
    songName=listOfAllFolderAndFiles[songNum].toString().split('/').last.substring(0,listOfAllFolderAndFiles[songNum].toString().split('/').last.length-5);
    //print('line28');
    //print(song);
    print('line30');
   // print(songName);
   // var duration =  player.setFilePath(listOfAllFolderAndFiles[songNum].toString().substring(7, listOfAllFolderAndFiles[songNum].toString().length - 1));
    //print(duration);

   }



  Future songMetaData(songNum) async{
    //we could a list

    String song = listOfAllFolderAndFiles[songNum].toString().substring(7, listOfAllFolderAndFiles[songNum].toString().length - 1);
    print('line 71 '+song);

    final metadata = await MetadataRetriever.fromFile(File('/storage/emulated/0/Download/Grand Escape (feat. Toko Miura).mp3'));

    List metaInfo=[metadata.trackName, metadata.trackDuration, metadata.albumName, metadata.albumArtistName, metadata.year, metadata.albumArt];

   /* String? trackName = metadata.trackName;
    String? albumName = metadata.albumName;
    String? albumArtistName = metadata.albumArtistName;
    int? year = metadata.year;
    Uint8List? albumArt = metadata.albumArt;
    int? trackDuration = metadata.trackDuration;

    //List<musicFileInfo> fileMeta=[];*/
    print('Line84');
    print(metadata.trackName);

    return null;

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      //appBar: AppBar(),
      body: ListView.builder(//later add that divider
        itemCount: listOfAllFolderAndFiles.length,
          itemBuilder: (context,songNum){
            return Container(
              color: Colors.black,
                  child: FutureBuilder(
                    future: songMetaData(songNum),
                    builder: (context, snapshot){
                      return songListView(context, songNum);

                    }
                  )

            );

              //ElevatedButton(onPressed: (){}, child: Text(listOfAllFolderAndFiles[songNum].toString().split('/').last.substring(0,listOfAllFolderAndFiles[songNum].toString().split('/').last.length-5)));

          }
      ),
    );

  }

  songListView(context,songNum)
   {

     //print('EachTime '+ songNum.toString());

    return ListTile(//use the special textFont ALSO later add that divider
      leading: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        child: Image.asset('Images/img.png'),
      ),
      title: Text(
        listOfAllFolderAndFiles[songNum].toString().split('/').last.substring(0,listOfAllFolderAndFiles[songNum].toString().split('/').last.length-5),
        style: TextStyle(fontSize: 18,color: Colors.deepOrange,fontWeight: FontWeight.bold,fontFamily:'lato'),
      ),

      dense: true,
      contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 1.0),
      selected: true,
      subtitle: Text('Logic • 3:03  ',style: GoogleFonts.lato(),),
      trailing: Icon(Icons.sort),
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AudioPlay(number:songNum),
          ),
        );
        print('clicked '+listOfAllFolderAndFiles[songNum].toString().split('/').last.substring(0,listOfAllFolderAndFiles[songNum].toString().split('/').last.length-5));
      },

    );
  }


}





/*
class musicFileInfo
{
  final String trackName;
  final String albumName;
  final String albumArtistName;
  final int year;
  final Uint8List albumArt;

  musicFileInfo(this.trackName, this.albumName, this.albumArtistName,this.year, this.albumArt);
}*/
//next thing sync up each vid time and artist name and the pic, then use the divider(maybe add whiteLine)