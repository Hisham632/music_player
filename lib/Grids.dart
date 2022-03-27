import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:music_player/List.dart';
import 'package:music_player/AudioPlayer_Playing.dart';
import 'package:miniplayer/miniplayer.dart';

class Playlists extends StatefulWidget {
  const Playlists({Key? key}) : super(key: key);

  @override
  _PlaylistsState createState() => _PlaylistsState();
}



class _PlaylistsState extends State<Playlists> with TickerProviderStateMixin{
  late List<FileSystemEntity> listOfAllFolderAndFiles;
   List<FileSystemEntity> PlaylistsFolders=[];
  late TabController tabController;
  late List<FileSystemEntity> listAllSongs;


  void initState()
  {
    super.initState();
    tabController=TabController(length: 2, vsync: this);
    getPlaylists();
    getAllSongsList();
  }
  void dispose() {
    tabController.dispose();
    super.dispose();
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


  void getAllSongsList()
  {
    Directory dir = Directory('/storage/emulated/0/AudioFiles/');
    listAllSongs = dir.listSync(recursive: true);
    print('line58');
    print(listAllSongs.length);

  }

miniPlayer()
{
  //Size phoneSize= MediaQuery.of(context).size;
  return AnimatedContainer(
    color: Colors.blueAccent,
    duration: Duration(seconds: 1),
    child: SizedBox(
      height: 85,
      child: Column(
        children: [
        SizedBox(
        height: 1,
        child: SliderTheme(
          child: Slider(
            value: 12,
            max: 100,
            onChanged: null,
          ),
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.orange,
            inactiveTrackColor: Colors.red.withOpacity(0.3),
            trackShape: SpotifyMiniPlayerTrackShape(),
            trackHeight: 2,
            thumbShape: RoundSliderThumbShape(
              enabledThumbRadius: 0,
            ),
          ),
        ),
      ),
      Row(
      children: [
      Flexible(
      flex: 8,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AudioPlay(number: -1)));
        },
        child: Row(
          children: [
            Flexible(
                child: Image.asset('Images/img.png')),
            Flexible(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0),
                child: Text('Song Name'),
              ),
            )
          ],
        ),
      ),
    ),
    Flexible(
        flex: 2,
        child: Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: SizedBox(
            height: 60,
            width: 60,
            child: Icon(Icons.play_arrow),
          ),
        ))
    ],
  )
  ],
  ),
  ),
  );
}




  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: DefaultTabController(
      length: 2,
      child: Scaffold(
      /*  appBar: AppBar(
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


        ),*/
        backgroundColor: Colors.white10,
        body:NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
                 SliverAppBar(
                   title: Center(child:Text('Well Well If It Isnt Us',style: TextStyle(fontSize: 18,color: Colors.blueAccent[400],fontWeight: FontWeight.bold,fontFamily:'lato'),)),
                   backgroundColor: Colors.green,
                   pinned: true,
                   floating: true,
                   bottom: TabBar(
                     labelColor: Colors.brown,
                     controller: tabController,
                     isScrollable: true,
                     indicatorColor: Colors.amberAccent,
                     indicatorSize: TabBarIndicatorSize.label,
                     indicatorWeight: 5,
                     indicator: BoxDecoration(
                         borderRadius: BorderRadius.circular(100), // Creates border
                         color: Colors.teal // Can also add an image
                     ),
                     tabs: [
                       Tab(icon:Icon(Icons.api,color: Colors.deepPurple,),text:"Playlists"),
                       Tab(icon:Icon(Icons.visibility_outlined,color: Colors.deepPurple,),text: "Songs",)
                     ],
                   ),

                 ),
              ];
          },
          body: TabBarView(
            controller: tabController,
            children:[
              playlistGrid(),
              getAllSongs(),

            ],
          ),

        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Miniplayer(
              minHeight: 70,
              maxHeight: 370,
              builder: (height, percentage) {
                return Center(
                  child: Text('$height, $percentage'),
                );
              },
            ),

          ],
        ),

      ),
    ),
    );

  }

  playlistGrid()
  {
    return GridView.builder(
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

    );

  }



  getAllSongs()
  {
    return ListView.separated(//later add that divider
        separatorBuilder: (context, index) => const Divider(
          color: Colors.deepPurple,
          height: 0,
          thickness: 2,
        ),

        itemCount: listAllSongs.length,
        itemBuilder: (context,songNum){
          return Container(
              color: Colors.black,
              child: FutureBuilder(
                  future: songMetaData(songNum),
                  builder: (context, snapshot){
                    return songListView(context, songNum);

                  }

              ),
          );

          //ElevatedButton(onPressed: (){}, child: Text(listOfAllFolderAndFiles[songNum].toString().split('/').last.substring(0,listOfAllFolderAndFiles[songNum].toString().split('/').last.length-5)));

        }
    );
  }



  songListView(context,songNum)
  {

    //print('EachTime '+ songNum.toString());

    return Card(
      color: Colors.deepPurple[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation:5,
      child: ListTile(//use the special textFont ALSO later add that divider
        leading: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          child: Image.asset('Images/img.png'),
        ),
        title: Text(
          listAllSongs[songNum].toString().split('/').last.substring(0,listAllSongs[songNum].toString().split('/').last.length-5),
          style: TextStyle(fontSize: 18,color: Colors.deepOrange,fontWeight: FontWeight.bold,fontFamily:'lato'),
        ),

        dense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 1.0),
        selected: true,
        subtitle: Text('Logic • 3:03  ',style: GoogleFonts.lato(),),
        trailing: Icon(Icons.sort),
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AudioPlay(number:songNum+1),
            ),
          );
          print('clicked '+listAllSongs[songNum].toString().split('/').last.substring(0,listAllSongs[songNum].toString().split('/').last.length-5));
        },

      ),
    );
  }


  Future songMetaData(songNum) async{
    return null;
  }




}






class SpotifyMiniPlayerTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double? trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

/*
GridView.builder(
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
 */
