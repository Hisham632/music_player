import 'package:flutter/material.dart';
import 'package:music_player/AudioPlayer_Playing.dart';
import 'package:music_player/List.dart';

void main() {
  runApp( MaterialApp(
    initialRoute:'/test' ,
    routes: {
      '/':(context)=> AudioPlay(number: 2),
      '/listing':(context)=> Lists(),

    },
  ));
}





/*
Music Player App:
1.Draw UI template for main
2. create player page (where we actually play the music)
3.a page where we select the song played, list of songs displayed in a list

4.Playlist page where we can add songs from the list to a playlist
 */
