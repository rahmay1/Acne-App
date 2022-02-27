import 'package:acne_detector/stats/statsPage.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:io';
import '../color/color.dart';
import 'package:acne_detector/camera/camera.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras = [];
File? imagePicked;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the prch below to Colors.green and then invoke
        // "hot reload" (press "r"imarySwat in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        brightness: Brightness.light,
        primarySwatch: CompanyColors.myColor,
        primaryColor: CompanyColors.myColor,
        primaryColorDark: CompanyColors.myColor[900],
        primaryColorLight: CompanyColors.myColor[50],
        hoverColor: CompanyColors.myColor[700],
        fontFamily: 'Ariel',
      ),
      home: const MyHomePage(title: 'Acne Types'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<void> _initCamera() async {
    // Fetch the available cameras before initializing the app.
    try {
      WidgetsFlutterBinding.ensureInitialized();
      cameras = await availableCameras();
    } on CameraException catch (e) {
      print('Error in fetching the cameras: $e');
    }
  }

  void _onItemTapped(int index) {
    if (index == 1){
      _initCamera().then((i) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CameraScreen()),);
      });
    }
    if (index == 2){
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const StatsPage(title: 'stats')));
    }
    // setState(() {
    //   _selectedIndex = index;
    // });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0), // here the desired height
        child: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.

          title: Center(child: Text(widget.title)),
        ),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: new SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {},
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Blackhead",
                    style: TextStyle(
                      color: black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    primary: tabsBeige,
                    fixedSize: const Size(320, 80),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {},
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Whitehead",
                    style: TextStyle(
                      color: black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    primary: tabsBeige,
                    fixedSize: const Size(320, 80),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {},
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Cyst",
                    style: TextStyle(
                      color: black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    primary: tabsBeige,
                    fixedSize: const Size(320, 80),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {},
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Papule",
                    style: TextStyle(
                      color: black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    primary: tabsBeige,
                    fixedSize: const Size(320, 80),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {},
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Nodule",
                    style: TextStyle(
                      color: black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    primary: tabsBeige,
                    fixedSize: const Size(320, 80),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {},
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Pustule",
                    style: TextStyle(
                      color: black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    primary: tabsBeige,
                    fixedSize: const Size(320, 80),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.query_stats),
            label: 'Stats',
          ),
        ],
        onTap: _onItemTapped,
      ),

      // Center(
      //   child: SvgPicture.asset(
      //     'assets/Ellipse 117.svg'
      //   ),
      //
      // ),

      //   floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     _incrementCounter();
      //   },
      //   tooltip: 'Increment',
      //   child: SvgPicture.network(
      //     dogUrl,
      //     semanticsLabel: 'Feed button',
      //     placeholderBuilder: (context) => Icon(Icons.error),
      //   ),
      // ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );

  }
}
