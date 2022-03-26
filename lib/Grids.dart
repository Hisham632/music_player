import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:music_player/List.dart';
import 'package:music_player/AudioPlayer_Playing.dart';

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
  Size phoneSize= MediaQuery.of(context).size;
  return AnimatedContainer(
    duration: const Duration(microseconds: 500),
      color: Colors.blue,
    width: phoneSize.width,
    height: 50,
    child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          child: Image.asset('Images/img.png'),
        ),
        Text('SongName', style: TextStyle(fontSize: 18,color: Colors.blueAccent[400],fontWeight: FontWeight.bold,fontFamily:'lato'),),
        IconButton(onPressed: (){}, icon: Icon(Icons.play_arrow,color: Colors.orange,))
        
      ],
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
            miniPlayer(music),
            BottomNavigationBar(
              currentIndex: currentTabIndex,
              onTap: (currentIndex) {
                print("Current Index is $currentIndex");
                currentTabIndex = currentIndex;
                setState(() {}); // re-render
              },
              selectedLabelStyle: TextStyle(color: Colors.white),
              selectedItemColor: Colors.white,
              backgroundColor: Colors.black45,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home, color: Colors.white), label: 'Home'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search, color: Colors.white),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.library_books, color: Colors.white),
                    label: 'Your Library')
              ],
            )
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
