import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player/youtubeTest.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:music_player/List.dart';
import 'package:music_player/AudioPlayer_Playing.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:path/path.dart' as path;
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:awesome_notifications/android_foreground_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:anim_search_bar/anim_search_bar.dart';

enum Menu { itemOne, itemTwo, itemThree, itemFour }

class Playlists extends StatefulWidget {
  const Playlists({Key? key}) : super(key: key);
  static bool subscribedActionStream = false;

  @override
  _PlaylistsState createState() => _PlaylistsState();
}



class _PlaylistsState extends State<Playlists> with TickerProviderStateMixin{
  late List<FileSystemEntity> listOfAllFolderAndFiles;
   List<FileSystemEntity> PlaylistsFolders=[];
  late TabController tabController;
  late List<FileSystemEntity> listAllSongs;
  String searchTitle=' ';


  void initState() {
    super.initState();

    initPlayerPermission();
    tabController=TabController(length: 2, vsync: this);
    getPlaylists();
    getAllSongsList();

  }
  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
    AwesomeNotifications().dismiss(0);


  }

  void initPlayerPermission() async {
     AwesomeNotifications().requestPermissionToSendNotifications();

    final status = await Permission.storage.status;
      const statusManageStorage = Permission.manageExternalStorage;
      if (status.isDenied ||
      !status.isGranted ||
      !await statusManageStorage.isGranted) {
          await [
          Permission.storage,
          Permission.mediaLibrary,
          Permission.requestInstallPackages,
          Permission.manageExternalStorage,
          ].request();
      }
  }

  void getPlaylists()
  {
    //getExternalStorageDirectory() ;

    Directory dir = Directory('/storage/emulated/0/AudioFiles/');
    listOfAllFolderAndFiles = dir.listSync(recursive: false);
   // print(listOfAllFolderAndFiles[0]);//has all the files from the directory
   // print(listOfAllFolderAndFiles[0].toString().substring(0,9));//Gets the "Directory"

    for(int count=0;count<listOfAllFolderAndFiles.length;count++) {

      if(listOfAllFolderAndFiles[count].toString().substring(0,9)=='Directory'){
          PlaylistsFolders.add(listOfAllFolderAndFiles[count]);
          //print(PlaylistsFolders);
      }
    }
  }


  void getAllSongsList(){

    Directory dir = Directory('/storage/emulated/0/AudioFiles/');
    listAllSongs = dir.listSync(recursive: true);
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);

    TextEditingController textControllerSearch = TextEditingController();

    // tabController.addListener(() {
    //   if(tabController.indexIsChanging){
    //     setState(() {
    //
    //     });
    //   }
    // });

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: Drawer(
          backgroundColor: const Color(0xFF111213),
         // shape: ,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
            SizedBox(height: 30,)
            ,
          ListTile(
            leading: Icon(Icons.home),
            title: const Text('Home'),
            textColor: Color(0xFF4c7dad),
            iconColor: Color(0xFF4c7dad),
            hoverColor: Color(0xFF4c7dad),
            onTap: (){
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => Playlists(),
                ), (route) => false
              );
            },
          ),
              ListTile(
                leading: Icon(Icons.download),
                title: Text('Youtube Downloader'),
                textColor: Color(0xFF4c7dad),
                iconColor: Color(0xFF4c7dad),
                hoverColor: Color(0xFF4c7dad),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyHomePage(title: ''),
                    ),
                  );
                },
              ),

            ],
          ),
        ),

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

        backgroundColor: const Color(0xFF212224),
        body:NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
                 SliverAppBar(
                   elevation: 10,
                   actions: [


                     (currentTab())?InkWell(

              onTap: ()=>{
                print("THE ATTACK TITAN")

              },
              child: AnimSearchBar(
              width: mediaQueryData.size.width*.99,

              textController: textControllerSearch,

              color: Color(0xFF111213),
              searchIconColor: Colors.white,
              style: TextStyle(fontSize:22,color: Colors.white,fontWeight: FontWeight.bold,fontFamily:'Proxima Nova'),
              autoFocus: true,
              boxShadow: true,
              closeSearchOnSuffixTap: true,
              suffixIcon: const Icon(Icons.close,
                color: Colors.white,
                size: 20,
              ),
              prefixIcon: Icon(
                Icons.search,
                size: 24,
              ),
              textFieldIconColor: Colors.white,
              textFieldColor: Colors.grey[900],
              animationDurationInMilli: 160,




              onSuffixTap: () {
                setState(() {
                  textControllerSearch.addListener(() {

                    print(textControllerSearch.text);

                  });

                  textControllerSearch.clear();

                });

                print("CLIKED555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555");
              setState(() {
                textControllerSearch.clear();
              });}, onSubmitted: (String ) {

                setState(() {
                  searchTitle=textControllerSearch.text;
                });
                print("clicked44444444444444444444444444444444444444444444444444444444444444444");
                textControllerSearch.clear();

              },),
            ):Text(''),

                     // IconButton(
                     //     onPressed: ()=>{
                     //
                     // },
                     //     icon:Icon(Icons.search)),
                   ],
                   title: Center(child:Text('Playlists',  textAlign: TextAlign.justify,style: TextStyle(fontSize: 30,color: Colors.white,fontWeight: FontWeight.bold,fontFamily:'Proxima Nova'),)),
                   backgroundColor: Color(0xFF111213),
                   pinned: true,
                   floating: true,

                   bottom: TabBar(
                     labelColor: const Color(0xFFFFFFFF),
                     controller: tabController,
                     isScrollable: true,
                     // indicatorColor: const Color(0xFF242222),
                     // indicatorSize: TabBarIndicatorSize.label,
                     // indicatorWeight: 5,
                     // indicator: BoxDecoration(
                     //     borderRadius: BorderRadius.circular(100), // Creates border
                     //     color: const Color(0xFF242222) // Can also add an image
                     // ),
                     tabs: [
                       Tab(icon:Icon(Icons.whatshot_outlined,color: Color(0xFFfc0811),),text:"Playlists"),
                       Tab(icon:Icon(Icons.view_list,color: Color(0xFFfc0811)),text: "Songs",),
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


      ),
    ),
    );

  }

  currentTab(){
    return true;
    
    if(tabController.index==0){
      return false;
    }
    else{
      return true;
    }

    return tabController.index;
  }

  playlistGrid()
  {
    return GridView.builder(

      itemCount: PlaylistsFolders.length,
      itemBuilder: (context,count)
      {

        var sName= PlaylistsFolders[count].toString().split('/').last.substring(0,PlaylistsFolders[count].toString().split('/').last.length-1);
        var imageSaveName=sName.replaceAll(RegExp(r'[^\p{Alphabetic}\p{Mark}\p{Decimal_Number}\p{Connector_Punctuation}\p{Join_Control}\s]', unicode: true),'');

        return Card(// maybe make it a card
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 15,
          color: Colors.grey[850]?.withOpacity(0.5),
          child:InkWell(
            splashColor: Colors.red.withAlpha(30),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Lists(folderName:PlaylistsFolders[count].toString()),// make list take a parameter for the folder
                ),
              );
            },

            child:Column(
                mainAxisSize:MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                Container(decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(File('/storage/emulated/0/Android/data/com.example.music_player/files/pictures/$imageSaveName.jpg')),
                    fit: BoxFit.fitWidth,
                  ),
                  borderRadius:  BorderRadius.all(Radius.circular(15.0)),
                ),
                  alignment: Alignment.center,
                  height: 148,
                ),
                // Image(
                //   height: 160,
                //   image: AssetImage(images[count]),
                //   fit: BoxFit.fitWidth,
                // ),
                SizedBox(height: 0,),
                Text(

                    PlaylistsFolders[count].toString().split('/').last.substring(0,PlaylistsFolders[count].toString().split('/').last.length-1),
                    style: TextStyle(fontSize: 21,color: Color(0xFFfffcfc),fontWeight: FontWeight.bold,fontFamily:'Proxima Nova'),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center
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



  getAllSongs(){

    // here wed have the filtered list, we'd need to create it from listAllSongs and put it in a setState
    //have it same format so we dont gotta change the code below


    late List<FileSystemEntity> listAllSongsSearch;

    listAllSongsSearch=listAllSongs
        .where((user) =>
        user.toString().toLowerCase().contains(searchTitle.toLowerCase()))
        .toList();

    print("LINE 338");
    print(listAllSongsSearch);
    //Solution: Possibly path is dif then wat it sent to AudioPlayer, so try to listAllSongsSearch path

    return ListView.separated(//later add that divider
        separatorBuilder: (context, index) => const Divider(
          color: Color(0xFF000000),
          height: 0,
          thickness: 2,
        ),

        itemCount: listAllSongsSearch.length,
        itemBuilder: (context,songNum){

          var sName=listAllSongsSearch[songNum].toString().split('/').last.substring(0,listAllSongsSearch[songNum].toString().split('/').last.length-1);
          var imageSaveName=sName.replaceAll(RegExp(r'[^\p{Alphabetic}\p{Mark}\p{Decimal_Number}\p{Connector_Punctuation}\p{Join_Control}\s]', unicode: true),'');

          return Container(
              color: Colors.black,
              child: FutureBuilder(
                  future: songMetaData(songNum),
                  builder: (context, snapshot){
                    if((listAllSongsSearch[songNum].toString().substring(listAllSongsSearch[songNum].toString().length-9,listAllSongsSearch[songNum].toString().length)).contains(".")){
                      return songListView(context, songNum);
                     }
                     else{
                       return Card(
                         color: Colors.grey[900]?.withOpacity(0.35),
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
                             listAllSongsSearch[songNum].toString().split('/').last.substring(0,listAllSongsSearch[songNum].toString().split('/').last.length-1),
                             style: TextStyle(fontSize: 20,color: Color(0xFFFFFFFF),fontWeight: FontWeight.bold,fontFamily:'Proxima Nova'),
                             overflow: TextOverflow.ellipsis,

                           ),

                           dense: true,
                           contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 1.0),
                           selected: true,
                         ),
                       );
                     }
                  }

              ),
          );

          //ElevatedButton(onPressed: (){}, child: Text(listOfAllFolderAndFiles[songNum].toString().split('/').last.substring(0,listOfAllFolderAndFiles[songNum].toString().split('/').last.length-5)));

        }
    );
  }



  songListView(context,songNum){

    late List<FileSystemEntity> listAllSongsSearch;

    listAllSongsSearch=listAllSongs
        .where((user) =>
        user.toString().toLowerCase().contains(searchTitle.toLowerCase()))
        .toList();

    var sName=listAllSongsSearch[songNum].toString().split('/').last.substring(0,listAllSongsSearch[songNum].toString().split('/').last.length-6);
    var imageSaveName=sName.replaceAll(RegExp(r'[^\p{Alphabetic}\p{Mark}\p{Decimal_Number}\p{Connector_Punctuation}\p{Join_Control}\s]', unicode: true),'');

    return Card(
      color: Colors.grey[600]?.withOpacity(0.3),//Here632
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
          listAllSongsSearch[songNum].toString().split('/').last.substring(0,listAllSongsSearch[songNum].toString().split('/').last.length-6),
          style: const TextStyle(fontSize: 18,color: Color(0xFFFFFFFF),fontWeight: FontWeight.bold,fontFamily:'Proxima Nova'),
          overflow: TextOverflow.ellipsis,

        ),

        dense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 1.0),
        selected: true,
        subtitle: Text('YourGate • 5:47  ',style: TextStyle(fontFamily:'Proxima Nova',color:  Colors.grey[400]),),

        trailing: PopupMenuButton<Menu>(
          // Callback that sets the selected popup menu item.
            onSelected: (Menu item) {
              setState(() {
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[

              const PopupMenuItem<Menu>(
                value: Menu.itemOne,
                child: Text('Item 1'),
              ),
              const PopupMenuItem<Menu>(
                value: Menu.itemTwo,
                child: Text('Item 3'),
              ),

            ]
          ,color: Colors.grey,
          icon: Icon(Icons.more_vert,color: Colors.grey[400],),
        ),
        onTap: (){
          Duration time= const Duration();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AudioPlay(number:songNum,path:'/storage/emulated/0/AudioFiles/', currentPosition: time,),
            ),
          );


        },

      ),
    );
  }


  Future songMetaData(songNum) async{
    return null;
  }


}
