import 'package:flutter/material.dart';
import 'package:music_player/AudioPlayer_Playing.dart';
import 'package:music_player/List.dart';

void main() {
  runApp( MaterialApp(
    initialRoute:'/listing' ,
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

What to do next:
Leave the code for the metadata just return null for now
add the list divider thing
make it nice
create the album/playlist page where each folder becomes a grid and when u click it opens a new page as a list

do th avg background color where based on those 4 it switches
add time stamps below slider
*/
