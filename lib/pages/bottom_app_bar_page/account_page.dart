import 'package:app/pages/detailed_page/edit_profile_page.dart';
import 'package:app/tabs/image_view.dart';
import 'package:app/tabs/loved_view.dart';
import 'package:app/tabs/video_view.dart';
import 'package:app/themes/theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({super.key});

  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  //user
  final currentUser = FirebaseAuth.instance.currentUser!;
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  //tabs
  // final List<Widget> tabs = const [
    
  // ];
  //tab bar views
  final List<Widget> tabBarViews = [
    // image post view
    ImageView(),
    // video post view
    VideoView(),
    // loved post or video view
    LovedView(),
  ];
  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 65,
          // centerTitle: true,
          title: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            'My profile',
            style: TextStyle(
                fontSize: 25, color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          ),
          elevation: 0,
          automaticallyImplyLeading: false, // mất nút quay về
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.grey,
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection("users").doc(currentUser.uid).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.data() != null) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;
                return ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //following
                        Column(
                          children: [
                            Text('364', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                            Text('Following', style: TextStyle(color: Colors.grey, fontSize: 14),),
                          ],
                        ),
                        //profile details
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: ClipOval(
                            child: Container(
                              height: 100,
                              width: 100,
                              child: userData['avatar'] != null ? Image.network(userData['avatar'], fit: BoxFit.cover,) : Image.network('https://cdn-icons-png.flaticon.com/512/3177/3177440.png', fit: BoxFit.cover,),
                            ),
                          ),
                        ),
                        //followers
                        Column(
                          children: [
                            Text('21,2k', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                            Text('Followers', style: TextStyle(color: Colors.grey, fontSize: 14),),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 15,),
                    //name
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(userData['first name'] + ' ' + userData['last name'], style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),),
                        Text(" | ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),),
                        Text(userData['job'], style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),),
                      ],
                    ),
                    const SizedBox(height: 5,),
                    //bio ·
                    Text(userData['bio'].replaceAll(',', ' ·'), style: TextStyle(color: Colors.grey, fontSize: 16), textAlign: TextAlign.center, ),
                    const SizedBox(height: 5,),
                    //email
                    Text(userData['email'], style: TextStyle(color: Colors.blue[500], fontWeight: FontWeight.bold, fontSize: 16), textAlign: TextAlign.center,),
                    //buttons
                    const SizedBox(height: 15,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        children: [
                          //edit profile
                          
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context, MaterialPageRoute(
                                      builder: (context) => const EditProfile(),
                                    )
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Edit profile",
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.green[300] : Colors.green[500]),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(width: 20,),
                          // contact
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              child: const Center(
                                child: Text(
                                  "Share account",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15,),
                    //tab bar
                    TabBar(
                      onTap: _onItemTapped,
                      automaticIndicatorColorAdjustment: true,
                      indicatorColor: Colors.blue,
                      indicatorSize: TabBarIndicatorSize.tab,
                      tabs: [
                        Tab(
                          icon: Icon(Icons.collections, color: _selectedIndex == 0 ? Colors.blue : Color(0xFFCED5EB),),
                        ),
                        Tab(
                          icon: Icon(Icons.video_collection, color: _selectedIndex == 1 ? Colors.blue : Color(0xFFCED5EB),),
                        ),
                        Tab(
                          icon: Icon(Icons.favorite, color: _selectedIndex == 2 ? Colors.blue : Color(0xFFCED5EB),),
                        ),
                      ],
                    ),
                    //tab bar view
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: TabBarView(
                        children: tabBarViews,
                      ),
                    ),
                  ],
                );
            } else if(snapshot.hasError) {
              return Center(
                child: Text("Error${snapshot.error}"),
              );
            }
            return const Center(child: CircularProgressIndicator(),);
          },
        ),
      ),
    );
  }
}