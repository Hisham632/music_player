import 'package:flutter/material.dart';
import 'package:music_player/AudioPlayer_Playing.dart';
import 'package:music_player/List.dart';
import 'package:music_player/Grids.dart';
import 'package:music_player/youtubeTest.dart';

/*
MetaData

way to save which song is playing

 */

void main() {
  runApp(
      MaterialApp(
    theme: ThemeData(
      brightness:  Brightness.dark
    ),
    initialRoute:'/Playlists' ,
    routes: {
      //'/':(context)=> AudioPlay(number: -1),
      '/listing':(context)=> Lists(folderName:" Directory: '/storage/emulated/0/AudioFiles/君の名は。 (Kimi no Na wa.) (Your Name.) (Full Original Soundtrack)'"),
      '/Playlists':(context)=> Playlists(),
      '/youtube':(context)=>  MyHomePage(title: 'Flutter Demo Home Page'),

    },
  ));
}




/*
Music Player App:
Features:
  miniplayer
  background (might have queue option)
  like button
  YoutubeDownloader
  Make UI perfect

  then add PlaylistOption and playNext and queue



What to do next:
  BackGround playing and Fix bug
  Then Youtube downloading


Bugs:
Fix the all songs list to skip album names in index

Tasks:
make a bottom bar to play and pause and that it saves which song we're on
  In the appBar add a leading thing
  Look at discord for model picture

  Main Playing Page:
    do th avg background color where based on those 4 it switches
    add a like button
    previous and next button and fix play button
    make the background color the avg color of the pic

































avg color Code
 decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFFe63946), Colors.black.withOpacity(0.6)],
                stops: [0.0, 0.4],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                tileMode: TileMode.repeated)),




For Miniplayer implementation :
  Make the Stack with AudioPlayer()
  add the state and riverpod
  make it so when we drag the miniplayer above a certain height it goes to the AudioPlayer page
  The Miniplayer has the pause, next and previous buttons and the details of the song playing



*/