import 'dart:io';
import 'package:flutter/material.dart';
import 'package:music_player/youtubeTest.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:music_player/List.dart';
import 'package:music_player/AudioPlayer_Playing.dart';
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

  String DevicePATH='/storage/emulated/0/Android/data/com.example.music_player/AudioFiles/';
  String EmulatorPATH='/storage/emulated/0/AudioFiles/';


  @override
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

    Directory dir = Directory(EmulatorPATH);
    listOfAllFolderAndFiles = dir.listSync(recursive: false);
   // print(listOfAllFolderAndFiles[0].toString().substring(0,9));//Gets the "Directory"

    for(int count=0;count<listOfAllFolderAndFiles.length;count++) {
      if(listOfAllFolderAndFiles[count].toString().substring(0,9)=='Directory'){
          PlaylistsFolders.add(listOfAllFolderAndFiles[count]);
      }
    }
  }


  void getAllSongsList(){

    Directory dir = Directory(EmulatorPATH);
    listAllSongs = dir.listSync(recursive: true);
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);

    TextEditingController textControllerSearch = TextEditingController();

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

              setState(() {
                textControllerSearch.clear();
              });}, onSubmitted: (String ) {

                setState(() {
                  searchTitle=textControllerSearch.text;
                });
                textControllerSearch.clear();

              },),
            ):Text(''),

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
    late List<FileSystemEntity> listAllSongsSearch;

    listAllSongsSearch=listAllSongs
        .where((user) =>
        user.toString().toLowerCase().contains(searchTitle.toLowerCase()))
        .toList();

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

    // print("SONG LIST PATHS:::");
    // print(listAllSongsSearch);

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

          List<FileSystemEntity> listOfAllFolderAndFiles2;
          String song2 = listAllSongsSearch[songNum].toString().substring(7, listAllSongsSearch[songNum].toString().length - 1);
          String folderPath2 = song2.substring(0, song2.lastIndexOf('/'));

          Directory dir = Directory(folderPath2);
          listOfAllFolderAndFiles2 = dir.listSync(recursive: true);

          List<String> newSongs=[];
          listOfAllFolderAndFiles2.forEach((element) {
            // print(element);
            // print(element.toString()==listAllSongsSearch[songNum].toString());
            newSongs.add(element.toString());

          });
          // print("NEW SONGS");
          // print(newSongs.indexOf(listAllSongsSearch[songNum].toString()));
          String song = listOfAllFolderAndFiles2[songNum].toString().substring(7, listOfAllFolderAndFiles2[songNum].toString().length - 1);
          String folderPath = song.substring(0, song.lastIndexOf('/'));

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AudioPlay(number:newSongs.indexOf(listAllSongsSearch[songNum].toString()),path:folderPath, currentPosition: time,),
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
