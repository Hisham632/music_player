import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player/youtubeTest.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:music_player/List.dart';
import 'package:music_player/AudioPlayer_Playing.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:path/path.dart' as path;
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
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


  void initState() {
    super.initState();

    initPlayerPermi();
    tabController=TabController(length: 2, vsync: this);
    getPlaylists();
    getAllSongsList();
  }
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void initPlayerPermi()
  async {
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
/*
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
                  builder: (context) => const AudioPlay(number: -1, path:'/storage/emulated/0/Download/' ,)));
        },
        child: Row(
          children: [
            Flexible(
                child: Image.asset('Images/gatePic.jpg')),
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



*/
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: Drawer(
         // shape: ,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.black,
                ), child: null,
              ),
          ListTile(
            leading: Icon(Icons.whatshot),
            title: Text('Main'),
            textColor: Colors.deepOrange,
            iconColor: Colors.deepOrange,
            hoverColor: Colors.deepPurple,
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Playlists(),
                ),
              );
              //print('clicked '+listOfAllFolderAndFiles[songNum].toString().split('/').last.substring(0,listOfAllFolderAndFiles[songNum].toString().split('/').last.length-5));

            },
          ),
              ListTile(
                leading: Icon(Icons.whatshot),
                title: Text('Youtube Downloader'),
                textColor: Colors.deepOrange,
                iconColor: Colors.deepOrange,
                hoverColor: Colors.deepPurple,
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
                       Tab(icon:Icon(Icons.visibility_outlined,color: Colors.deepPurple,),text: "Songs",),
                       //Tab(icon: Icon(Icons.ac_unit_sharp, color: Colors.deepPurple,),text: "YoutubeDownloader",)
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
                  image: AssetImage('Images/gatePic.jpg'),
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
                    if((listAllSongs[songNum].toString().substring(listAllSongs[songNum].toString().length-9,listAllSongs[songNum].toString().length)).contains(".")){
                      return songListView(context, songNum);
                     }
                     else{
                       return Card(
                         color: Colors.indigo[800],
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(10.0),
                         ),
                         elevation:5,
                         child: ListTile(//use the special textFont ALSO later add that divider
                           leading: ClipRRect(
                             borderRadius: BorderRadius.all(Radius.circular(10.0)),
                             child: Image.asset('Images/gatePic.jpg'),
                           ),
                           title: Text(
                             listAllSongs[songNum].toString().split('/').last.substring(0,listAllSongs[songNum].toString().split('/').last.length-5),
                             style: TextStyle(fontSize: 18,color: Colors.deepOrange,fontWeight: FontWeight.bold,fontFamily:'lato'),
                           ),

                           dense: true,
                           contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 1.0),
                           selected: true,



                         ),
                       );;
                     }


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
      color: Colors.purple[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation:5,
      child: ListTile(//use the special textFont ALSO later add that divider
        leading: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          child: Image.asset('Images/gatePic.jpg'),
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
              builder: (context) => AudioPlay(number:songNum,path:'/storage/emulated/0/AudioFiles/',),
            ),
          );
          print('CLICKED 1111111111111111111111111111111111111111111111111  '+listAllSongs[songNum].toString());
          print((listAllSongs[songNum].toString().substring(listAllSongs[songNum].toString().length-9,listAllSongs[songNum].toString().length)).contains("."));
        },

      ),
    );
  }


  Future songMetaData(songNum) async{
    return null;
  }




}

downloader(){
  final textController = TextEditingController();

    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Insert the video id or url',
            ),
            TextField(controller: textController),
            ElevatedButton(
                child: const Text('Download'),
                onPressed: () async {
                  // Here you should validate the given input or else an error
                  // will be thrown.
                  var yt = YoutubeExplode();
                  var id = VideoId("https://www.youtube.com/watch?v=2JpkMXinO1M&ab_channel=AnimelunaII");
                  var video = await yt.videos.get(id);
                  print(video.title);

                  // Display info about this video.


                  // Request permission to write in an external directory.
                  // (In this case downloads)
                  await Permission.storage.request();

                  // Get the streams manifest and the audio track.
                  var manifest = await yt.videos.streamsClient.getManifest(id);
                  var audio = manifest.audioOnly.last;

                  // Build the directory.
                  Directory dir = Directory('/storage/emulated/0/Download/');
                  var filePath = path.join(dir.uri.toFilePath(),
                      '${video.title}.${audio.container.name}');

                  // Open the file to write.
                  var file = File(filePath);
                  var fileStream = file.openWrite();

                  // Pipe all the content of the stream into our file.
                 // var audioStream = await yt.videos.streamsClient.get(audio).pipe(fileStream);
                   var audioStream = await yt.videos.streamsClient.get(audio);

                  var len = audio.size.totalBytes;
                  var count = 0;
                  var progress;
                  // Pipe all the content of the stream into our file.
                  await for (final data in audioStream) {
                  // Keep track of the current downloaded data.
                  count += data.length;

                  // Calculate the current progress.
                  progress = ((count / len) * 100).ceil();

                  print("Progress: $progress");


                  fileStream.add(data);
                  }

                  if(progress==100)
                    {
                      print("Download Complete");
                    }



                  await fileStream.flush();
                  await fileStream.close();


                }),
          ],
        ),
      );
  }






/*
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
}*/

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
