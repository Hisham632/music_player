import 'package:flutter/material.dart';
import 'package:music_player/AudioPlayer_Playing.dart';
import 'package:music_player/List.dart';
import 'package:music_player/Grids.dart';

void main() {
  runApp( MaterialApp(
    initialRoute:'/Playlists' ,
    routes: {
      '/':(context)=> AudioPlay(number: -1),
      '/listing':(context)=> Lists(folderName:" Directory: '/storage/emulated/0/AudioFiles/君の名は。 (Kimi no Na wa.) (Your Name.) (Full Original Soundtrack)'"),
      '/Playlists':(context)=> Playlists(),

    },
  ));
}





/*
Music Player App:
1.Draw UI template for main
2. create player page (where we actually play the music)
3.a page where we select the song played, list of songs displayed in a list

4.Playlist page where we can add songs from the list to a playlist


What to do next:
Tabs

later make headbar to go from albums/playlists to all song page and another to donwload songs
do th avg background color where based on those 4 it switches
make it look nice
add a like button

backgroundPlaying
*/
