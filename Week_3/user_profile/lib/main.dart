import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Profile',

      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'User Profile'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

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
  

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Colors.grey[900],
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title, style: TextStyle(color: Colors.white),),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 25.0,
                backgroundImage: NetworkImage('https://avatars.githubusercontent.com/u/101043671?v=4'),
              ),
              SizedBox(width: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Prodigygenes',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    'Flutter Developer || Artist',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ],
          ),
          ),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                child: Column(
                  children: [
                    Text('1.1B', style: TextStyle(fontSize: 18.0, color: Colors.white),),
                    Text('Followers', style: TextStyle(fontSize: 12.0, color: Colors.grey[400]),),
                  ],
                  )
              ),
              Center(
                child: Column(
                  children: [
                    Text('1M', style: TextStyle(fontSize: 18.0, color: Colors.white),),
                    Text('Following', style: TextStyle(fontSize: 12.0, color: Colors.grey[400]),),
                  ],
                  )
              ),
            ]
          ),
          SizedBox(height: 30.0),
          Container(
            width: 350,
            padding: EdgeInsets.all(20),
            color: Colors.grey[900],
            child: Text(
              'Passionate Flutter developer with a knack for creating beautiful and functional mobile applications. Experienced in building cross-platform apps with a focus on performance and user experience. Always eager to learn new technologies and improve my skills. And another side of me is a digital artist who loves to create digital art, writing novels as a chance to build my own fantasy world and create my own characters to live in them.',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 20.0),
          GridView(
            shrinkWrap: true,
            padding: EdgeInsets.all(10.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0,
            ),
            children: [
              Image.network('https://picsum.photos/250?image=9'), 
              Image.network('https://picsum.photos/250?image=10'),
              Image.network('https://picsum.photos/250?image=11'),
              Image.network('https://picsum.photos/250?image=12'),
              Image.network('https://picsum.photos/250?image=13'),
              Image.network('https://picsum.photos/250?image=14'),
              
            ]
          )
        

        ],

      ),
      
    );
  }
}
