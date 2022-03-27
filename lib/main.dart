import 'package:flutter/material.dart';
import 'package:music_player/AudioPlayer_Playing.dart';
import 'package:music_player/List.dart';
import 'package:music_player/Grids.dart';

void main() {
  runApp( MaterialApp(
    theme: ThemeData(
      brightness:  Brightness.dark
    ),
    initialRoute:'/Playlists' ,
    routes: {
      //'/':(context)=> AudioPlay(number: -1),
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
make a bottom bar to play and pause and that it saves which song we're on

In the appBar add a leading thing
Look at discord for model thing
backgroundPlaying
do th avg background color where based on those 4 it switches
make it look nice
add a like button

Bugs:
Fix the all songs list to skip album names in index





miniplayer
background (might have queue option)
like button
YoutubeDownloader
Make UI perfect

then add PlaylistOption and playNext and queue










avg color
 decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFFe63946), Colors.black.withOpacity(0.6)],
                stops: [0.0, 0.4],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                tileMode: TileMode.repeated)),






*/
