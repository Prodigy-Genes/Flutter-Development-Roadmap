// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Profile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(backgroundColor: Colors.transparent, elevation: 0),
      ),
      home: const MyHomePage(title: 'User Profile'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true, // Allows the image to go behind the AppBar
      appBar: AppBar(
        leading: Icon(Icons.arrow_back),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (value) {
              if(value == 'settings'){
                print("Going to settings");
              } 
              else if (value == 'logout') {
                print("Logging out");
              }
            } ,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'settings',
                child: ListTile(
                  leading: Icon(Icons.settings, color: Colors.white),
                  title: Text('Settings'),
                  contentPadding: EdgeInsets.zero, // Fix padding inside menu
                ),
              ),

              const PopupMenuDivider(),

              const PopupMenuItem(
                value: "logout",
                child: ListTile(
                leading: Icon(Icons.logout, color: Colors.white,),
                title: Text("Logout"),
                contentPadding: EdgeInsets.zero,
              ))
          ])
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Cover photo and the image in a stack
            Stack(
              clipBehavior: Clip.none, 
              alignment: Alignment.center,
              children: [
                // Cover Photo
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage('https://picsum.photos/800/400?image=16'), 
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    // Added a dark gradient on top so white text is readable
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
                      ),
                    ),
                  ),
                ),
                // Profile Picture positioned to overlap the the cover photo
                Positioned(
                  bottom: -50,
                  child: CircleAvatar(
                    radius: 54,
                    backgroundColor: Colors.black, // Border effect
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage('https://avatars.githubusercontent.com/u/101043671?v=4'),
                    ),
                  ),
                ),
              ],
            ),

            // USER PROFILE 
            SizedBox(height: 60), // Space for the overlapping avatar
            Text(
              'Prodigygenes',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              'Flutter Developer || Artist',
              style: TextStyle(fontSize: 14, color: Colors.grey[400], letterSpacing: 1.2),
            ),
            SizedBox(height: 20),
            
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    print("Follow button pressed");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Text('Follow', style: TextStyle(color: Colors.white)),
                ),
                SizedBox(width: 15),
                OutlinedButton(
                  onPressed: () {
                    print("Message button pressed");
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    side: BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Text('Message', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),

            // STATS 
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatColumn('1.1B', 'Followers'),
                _buildDivider(),
                _buildStatColumn('1M', 'Following'),
                _buildDivider(),
                _buildStatColumn('9', 'Posts'),
              ],
            ),

            // ABOUT CARD AND DETAILS
            SizedBox(height: 30),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey[800]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ABOUT ME", style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text(
                    'Passionate Flutter developer with a knack for creating beautiful and functional mobile applications. Experienced in building cross-platform apps with a focus on performance and user experience.\n\nAlso a digital artist writing novels to build fantasy worlds.',
                    style: TextStyle(color: Colors.white, ),
                  ),
                ],
              ),
            ),

            // GALLERY 
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Align(
                alignment: Alignment.centerLeft, 
                child: Text("POSTS", style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.bold))
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(15),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1, // Square images
              ),
              itemCount: 13,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10), // Rounded corners for images
                  child: Image.network(
                    'https://picsum.photos/300?image=${index + 20}',
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Helper method to create stats 
  Widget _buildStatColumn(String number, String label) {
    return Column(
      children: [
        Text(number, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[500])),
      ],
    );
  }

  // Helper method for the vertical lines between stats
  Widget _buildDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.grey[800],
    );
  }  
}