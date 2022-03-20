import 'package:flutter/material.dart';
import 'package:music_player/AudioPlayer_Playing.dart';
import 'package:music_player/List.dart';
import 'package:music_player/Grids.dart';

void main() {
  runApp( MaterialApp(
    initialRoute:'/Playlists' ,
    routes: {
      '/':(context)=> AudioPlay(number: 2),
      '/listing':(context)=> Lists(folderName:'test'),
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
add the list divider thing
do th avg background color where based on those 4 it switches
add time stamps below slider
also make it when u click from list it starts the song

make it look nice
add a like button
*/
