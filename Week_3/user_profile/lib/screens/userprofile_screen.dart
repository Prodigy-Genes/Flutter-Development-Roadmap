import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:user_profile/screens/signup_screen.dart';

class UserprofileScreen extends StatefulWidget {
  final String? username;
  final String email;
  final String? gender;
  const UserprofileScreen({super.key, this.username, required this.email, this.gender});

  @override
  State<UserprofileScreen> createState() => _UserprofileScreenState();
}

class _UserprofileScreenState extends State<UserprofileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, 
      
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (value) {
              if(value == 'settings'){
                debugPrint("Going to settings");
              } 
              else if (value == 'logout') {
                debugPrint("Logging out");
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUp()));
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
                      // Used a cached network image for better performance
                      image: CachedNetworkImageProvider('https://picsum.photos/800/400?image=16'), 
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
                      // Used a cached network image for better performance
                      backgroundImage: CachedNetworkImageProvider(
                        'https://avatars.githubusercontent.com/u/101043671?v=4'),
                    ),
                  ),
                ),
              ],
            ),

            // USER PROFILE 
            SizedBox(height: 60), // Space for the overlapping avatar
            Text(
              widget.username!,
              style: GoogleFonts.baloo2(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              widget.email,
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[400], letterSpacing: 1.2),
            ),
            SizedBox(height: 5),
            Text(
              'Flutter Developer || Artist',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[400], letterSpacing: 1.2),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Gender: ", style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[400])),
            widget.gender == "M"
            ?Text("Male",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[400], letterSpacing: 1.2),
            )
            :Text("Female",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[400], letterSpacing: 1.2),
            ),
              ],
            ),
            SizedBox(height: 20),
            
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    debugPrint("Follow button pressed");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 28, 88, 40),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Text('Follow', style: TextStyle(color: Colors.white)),
                ),
                SizedBox(width: 15),
                OutlinedButton(
                  onPressed: () {
                    debugPrint("Message button pressed");
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    side: BorderSide(color: Color.fromARGB(255, 255, 222, 59)),
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
                  borderRadius: BorderRadius.circular(10), 
                  // Used a cached network image for better performance
                  child: CachedNetworkImage(
                    imageUrl: 'https://picsum.photos/300?image=${index + 20}',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),

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
