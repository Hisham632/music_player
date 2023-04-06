// show the list of all songs in a driectory then make it so when they click on it they are directed to play page and it plays it

import 'dart:io';
import 'dart:typed_data';
import 'package:multi_split_view/multi_split_view.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:on_audio_edit/on_audio_edit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:music_player/AudioPlayer_Playing.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:id3/id3.dart';
import 'package:dart_tags/dart_tags.dart';
import 'package:on_audio_edit/on_audio_edit.dart';
enum Menu { itemOne, itemTwo, itemThree, itemFour }

class Lists extends StatefulWidget {
  final String folderName;


  static List playNextQueue=[];

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



@override
  initState(){
     int songNum=2;

    super.initState();
    //Directory dir = Directory('/storage/emulated/0/AudioFiles/');
    Directory dir = Directory(widget.folderName.substring(13, widget.folderName.length - 1));// later make sure the folder is not empty

    listOfAllFolderAndFiles = dir.listSync(recursive: true);
   // print(listOfAllFolderAndFiles);//has all the files from the directory
   // print(listOfAllFolderAndFiles.length);//has all the files from the directory

    //String song = listOfAllFolderAndFiles[songNum].toString().substring(7, listOfAllFolderAndFiles[songNum].toString().length - 1);
    songName=listOfAllFolderAndFiles[songNum].toString().split('/').last.substring(0,listOfAllFolderAndFiles[songNum].toString().split('/').last.length-5);

   }



  Future songMetaData() async{
    //we could a list

    //String song = listOfAllFolderAndFiles[songNum].toString().substring(7, listOfAllFolderAndFiles[songNum].toString().length - 1);
    //print('line 71 '+song);

    // final metadata = await MetadataRetriever.fromFile(File('/storage/emulated/0/AudioFiles/Attack.webm'),).then(
    //       (metadata) {
    //     print(metadata.trackName);
    //   },
    // );

   // // List metaInfo=[metadata.trackName, metadata.trackDuration, metadata.albumName, metadata.albumArtistName, metadata.year, metadata.albumArt];
   //
   //  String? trackName = metadata.trackName;
   //  String? albumName = metadata.albumName;
   //  String? albumArtistName = metadata.albumArtistName;
   //  int? year = metadata.year;
   //  Uint8List? albumArt = metadata.albumArt;
   //  int? trackDuration = metadata.trackDuration;
   //
   //  //List<musicFileInfo> fileMeta=[];
   //  print('Line84');
   //  print(trackName);

    // final OnAudioEdit _audioEdit = OnAudioEdit();
    // AudioModel song = await _audioEdit.readAudio('/storage/emulated/0/AudioFiles/君の名は。 (Kimi no Na wa.) (Your Name.) (Full Original Soundtrack)/Autumn festival.mp4');
    // print('Line888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888');
    //
    // print("Line 88 SONG NAME METADATA: "+ song.title);

    // final file = File('/storage/emulated/0/AudioFiles/君の名は。 (Kimi no Na wa.) (Your Name.) (Full Original Soundtrack)/Autumn festival.mp4');
    // TagProcessor().getTagsFromByteArray(file.readAsBytes()).then((l) {
    //   print('FILE: LINE93');
    //   l.forEach(print);
    //   print('\n');
    // });


    return null;

  }


  @override
  Widget build(BuildContext context) {

    var name=widget.folderName.toString().split('/').last.substring(0,widget.folderName.toString().split('/').last.length-1);
    var playlistName=Text(widget.folderName.toString().split('/').last.substring(0,widget.folderName.toString().split('/').last.length-1),textAlign: TextAlign.left,textWidthBasis: TextWidthBasis.longestLine ,softWrap: true ,style: TextStyle(decoration: TextDecoration.none,fontSize: 25,color: Colors.white,fontWeight: FontWeight.bold,fontFamily:'Proxima Nova'));
    var num=0.0;
    var imageSaveName=name.replaceAll(RegExp(r'[^\p{Alphabetic}\p{Mark}\p{Decimal_Number}\p{Connector_Punctuation}\p{Join_Control}\s]', unicode: true),'');

    if(name.length>20){
        num=0.0;
    }
    else{
      num=30.0*(name.length/10);
    }

    print(name+" "+(name.toString().length).toString());

    MultiSplitView multiSplitView = MultiSplitView(axis: Axis.vertical, children: [

      Container(
        color: const Color(0xFF161617),
        child: Row(
            children: [
              SizedBox(width: 1),

              Container(
              padding: EdgeInsets.all(50),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(File('/storage/emulated/0/Android/data/com.example.music_player/files/pictures/$imageSaveName.jpg')),
                  fit: BoxFit.cover,
                ),
                borderRadius:  BorderRadius.all(Radius.circular(10.0)),

              ),
              alignment: Alignment.centerRight,
              width: 120,
              height: 120,

            ),

              SizedBox(width: num),

              Flexible(
                  child: playlistName,
              )

/*
if we press the shuffle button auto start playing song and send to AudioPage
and continue playing random
change the next() and previosu to have a consdition wheterh or not Shuffllle mode is ON
 */

            ]
        ),
      ),
      ListView.separated(//later add that divider
          separatorBuilder: (context, index) => const Divider(
            color: Color(0xFF000000),
            height: 0,
            thickness: 2,
          ),

          itemCount: listOfAllFolderAndFiles.length,
          itemBuilder: (context,songNum){
            return Container(
                color: Colors.black,
                child: FutureBuilder(
                    future: songMetaData(),
                    builder: (context, snapshot){
                      return songListView(context, songNum);

                    }
                )
            );

          }
      )], controller: MultiSplitViewController(weights: [0.22]));

    return MultiSplitViewTheme(
        child: multiSplitView,
        data: MultiSplitViewThemeData(
            dividerThickness: 0.001,
            dividerPainter: DividerPainters.background(color: Color(0xFF000000))
        )
    );

  }

  songListView(context,songNum){

     var sName= listOfAllFolderAndFiles[songNum].toString().split('/').last.substring(0,listOfAllFolderAndFiles[songNum].toString().split('/').last.length-6);
     var imageSaveName=sName.replaceAll(RegExp(r'[^\p{Alphabetic}\p{Mark}\p{Decimal_Number}\p{Connector_Punctuation}\p{Join_Control}\s]', unicode: true),'');

    return Card(
      color: Colors.grey[600]?.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation:5,
        child: ListTile(//use the special textFont ALSO later add that divider
        leading: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          child: Image.file(File('/storage/emulated/0/Android/data/com.example.music_player/files/pictures/$imageSaveName.jpg')),
        ),
        title: Text(
          listOfAllFolderAndFiles[songNum].toString().split('/').last.substring(0,listOfAllFolderAndFiles[songNum].toString().split('/').last.length-6),
          style: TextStyle(fontSize: 18,color: Color(0xFFFFFFFF),fontWeight: FontWeight.bold,fontFamily:'Proxima Nova'),
          overflow: TextOverflow.ellipsis,

        ),

        dense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 1.0),
        selected: true,
        subtitle: Text('YourGate • 5:47  ',style: TextStyle(color: Colors.grey[400]),),
        trailing: PopupMenuButton<Menu>(
          // Callback that sets the selected popup menu item.
            onSelected: (Menu item) {
              print("selected"+item.index.toString());
              print("SongNum: "+songNum.toString()+" Path: "+widget.folderName.substring(13, widget.folderName.length - 1));
              Lists.playNextQueue.add(songNum.toString()+widget.folderName.substring(13, widget.folderName.length - 1));



              setState(() {
                // if(item.index==0){
                //   Lists.playNextNum=songNum;
                //   Lists.playNextPath=widget.folderName.substring(13, widget.folderName.length - 1);
                //
                // }
              });
              ;
            },
          elevation: 10,

            itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
              const PopupMenuItem<Menu>(
                value: Menu.itemOne,
                child: Text('Play Next'),
                height: 30,
                textStyle: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold,fontFamily:'Proxima Nova'),


              ),

            ]
        ,color: Colors.grey[900],
          icon: Icon(Icons.more_vert,color: Colors.grey[400],),
        ),

          onTap: () async {
            Duration time= Duration();
            // print("Search THING  "+widget.folderName.substring(13, widget.folderName.length - 1));


            if(AudioPlay.currentNumSong()==songNum&&AudioPlay.currentPath()==(widget.folderName.substring(13, widget.folderName.length - 1)))
              {
                print("SAME SONG");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AudioPlay(number:songNum, path:widget.folderName.substring(13, widget.folderName.length - 1), currentPosition: AudioPlay.currentTime(),),
                  ),
                );
              }
            else
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AudioPlay(number:songNum, path:widget.folderName.substring(13, widget.folderName.length - 1), currentPosition: time,),
                  ),
                );
              }
          
          

        },

      ),
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