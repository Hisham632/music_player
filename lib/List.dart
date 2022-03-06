// show the list of all songs in a driectory then make it so when they click on it they are directed to play page and it plays it

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class Lists extends StatefulWidget {
  const Lists({Key? key}) : super(key: key);

  @override
  _ListsState createState() => _ListsState();
}

class _ListsState extends State<Lists> {
  String songName='', lastSongPlayed='';//not used

  late List<FileSystemEntity> listOfAllFolderAndFiles;

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
  }



  @override
  Widget build(BuildContext context) {






    return Scaffold(
      body: ListView.builder(
        itemCount: listOfAllFolderAndFiles.length,
          itemBuilder: (context,songNum){
            return GestureDetector(
              onTap: () {print('pressed');},
                  child: ListTile(//use the special textFont
                    title: Text(listOfAllFolderAndFiles[songNum].toString().split('/').last.substring(0,listOfAllFolderAndFiles[songNum].toString().split('/').last.length-5)),

                  ),

            );

              //ElevatedButton(onPressed: (){}, child: Text(listOfAllFolderAndFiles[songNum].toString().split('/').last.substring(0,listOfAllFolderAndFiles[songNum].toString().split('/').last.length-5)));

          }
      ),
    );

  }
}
