import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:music_player/List.dart';

class Playlists extends StatefulWidget {
  const Playlists({Key? key}) : super(key: key);

  @override
  _PlaylistsState createState() => _PlaylistsState();
}



class _PlaylistsState extends State<Playlists> {
  late List<FileSystemEntity> listOfAllFolderAndFiles;
   List<FileSystemEntity> PlaylistsFolders=[];

  void initState()
  {
    super.initState();
    getPlaylists();
  }

  void getPlaylists()
  {
    Directory dir = Directory('/storage/emulated/0/AudioFiles/');
    listOfAllFolderAndFiles = dir.listSync(recursive: false);
    print(listOfAllFolderAndFiles[0]);//has all the files from the directory
    print(listOfAllFolderAndFiles[0].toString().substring(0,9));//Gets the "Directory"

    for(int count=0;count<listOfAllFolderAndFiles.length;count++)
    {
      if(listOfAllFolderAndFiles[count].toString().substring(0,9)=='Directory'){
          PlaylistsFolders.add(listOfAllFolderAndFiles[count]);
          print(PlaylistsFolders);
      }
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      //appBar: AppBar(),
      backgroundColor: Colors.white10,
      body: GridView.builder(
        itemCount: PlaylistsFolders.length,
        itemBuilder: (context,count)
        {
          return Scaffold(// maybe make it a card
            body:GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Lists(folderName:PlaylistsFolders[count].toString()),// make list take a parameter for the folder
                  ),
                );
                print("Clicked "+count.toString());
              },

                child:Column(
                  children: [
                    Expanded(child: Image.asset('Images/img.png'),),
                    AutoSizeText(
                      PlaylistsFolders[count].toString().split('/').last.substring(0,PlaylistsFolders[count].toString().split('/').last.length-5),
                      style: GoogleFonts.lato(),
                      minFontSize: 20,
                      maxLines: 1,
                    ),

                  ],
                ),
            ),

          );
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 15.0,
        ),

      ),

    );

  }


}
