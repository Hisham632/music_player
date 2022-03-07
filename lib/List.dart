// show the list of all songs in a driectory then make it so when they click on it they are directed to play page and it plays it

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:music_player/AudioPlayer_Playing.dart';
import 'package:just_audio/just_audio.dart';

class Lists extends StatefulWidget {
  const Lists({Key? key}) : super(key: key);

  @override
  _ListsState createState() => _ListsState();
}

class _ListsState extends State<Lists> {
  String songName='', lastSongPlayed='';//not used

  late List<FileSystemEntity> listOfAllFolderAndFiles;
  final player  = AudioPlayer();

  void initState()
  {
    int songNum=2;

    super.initState();
    Directory dir = Directory('/storage/emulated/0/AudioFiles/');
    listOfAllFolderAndFiles = dir.listSync(recursive: true);
    //print(listOfAllFolderAndFiles);//has all the files from the directory
    //String song = listOfAllFolderAndFiles[songNum].toString().substring(7, listOfAllFolderAndFiles[songNum].toString().length - 1);
    songName=listOfAllFolderAndFiles[songNum].toString().split('/').last.substring(0,listOfAllFolderAndFiles[songNum].toString().split('/').last.length-5);
    //print('line28');
    //print(song);
    print('line30');
    print(songName);
    var duration =  player.setFilePath(listOfAllFolderAndFiles[songNum].toString().substring(7, listOfAllFolderAndFiles[songNum].toString().length - 1));
    print(duration);
  }



  @override
  Widget build(BuildContext context) {






    return Scaffold(
      //appBar: AppBar(),
      body: ListView.builder(
        itemCount: listOfAllFolderAndFiles.length,
          itemBuilder: (context,songNum){
            return Container(
              color: Colors.black,
                  child: songListView(context, songNum),

            );

              //ElevatedButton(onPressed: (){}, child: Text(listOfAllFolderAndFiles[songNum].toString().split('/').last.substring(0,listOfAllFolderAndFiles[songNum].toString().split('/').last.length-5)));

          }
      ),
    );

  }

  songListView(context,songNum)
   {


    return ListTile(//use the special textFont
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
//next thing make it so it goes to the playing tab and plays the clicked song