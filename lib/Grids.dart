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

    return MaterialApp(
      home: DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.amberAccent,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 5,
            indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(50), // Creates border
                color: Colors.blue // Can also add an image
            ),
            tabs: [
              Tab(text:"Playlists"),
              Tab(text: "Songs",)
            ],
          ),
          //title: Text('Choose'),


        ),
        backgroundColor: Colors.white10,
        body: GridView.builder(
          itemCount: PlaylistsFolders.length,
          itemBuilder: (context,count)
          {
            return Card(// maybe make it a card
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 15,
              color: Colors.red[700],
              child:InkWell(
                splashColor: Colors.red.withAlpha(30),
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
                      mainAxisSize:MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: [
                        Ink.image(
                          height: 160,
                          image: AssetImage('Images/img.png'),
                          fit: BoxFit.fitWidth,
                        ),
                        Text(
                            PlaylistsFolders[count].toString().split('/').last.substring(0,PlaylistsFolders[count].toString().split('/').last.length-5),
                            style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold,fontFamily:'lato'),
                            overflow: TextOverflow.ellipsis
                        ),

                      ],
                    ),
                ),


            );
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 5.0,
          ),

        ),

      ),
    ),
    );

  }


}
