import 'package:app/components/circle_image.dart';
import 'package:app/components/search.dart';
import 'package:app/pages/detailed_page/chat_page.dart';
import 'package:app/services/auth/auth_service.dart';
import 'package:app/services/chat/chat_service.dart';
import 'package:app/themes/theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyMessagePage extends StatefulWidget {
  const MyMessagePage({super.key});

  @override
  State<MyMessagePage> createState() => _MyMessagePageState();
}

class _MyMessagePageState extends State<MyMessagePage> {
  final user = FirebaseAuth.instance.currentUser!;
  //chat & auth service
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  // update color
  late bool isDarkMode;
  @override
  Widget build(BuildContext context) {
    isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        // centerTitle: true,
        title: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var userData = snapshot.data!.data() as Map<String, dynamic>;
              return Container(
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: ListTile(
                    leading: ClipOval(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: Image.network(userData['avatar'], fit: BoxFit.cover,),
                      ),
                    ),
                    title: Text(
                      userData['first name'] + ' ' + userData['last name'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      user.email!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: isDarkMode ? Colors.grey[500] : Colors.grey[700],
                      ),
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error${snapshot.error}"),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        elevation: 0,
        automaticallyImplyLeading: false, // mất nút quay về
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        //share and
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0,),
            child: Row(children: [
              const Icon(
                Icons.notifications,
                color: Colors.lightBlueAccent,
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 30.0,),
            child: Row(children: [
              const Icon(
                Icons.share,
                color: Colors.blue,
              ),
            ]),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            //search
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
              child: Search(
                prefixIcon: Icon(Icons.search),
              ),
            ),
            //list users
            Container(
              height: 100,
              // color: const Color.fromRGBO(76, 175, 80, 1),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 7.0,),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return MyCircle();
                  },
                ),
              ),
            ),
            
            _buildUserList(),
          ],
        ),
      ), 
    );
  }

  //build a list of users except for the current logged in user
  Widget _buildUserList() {
    return Expanded(
      child: StreamBuilder(
          stream: _chatService.getUserStream(),
          builder: (context, snapshot) {
            //error
            if (snapshot.hasError) {
              return const Text('Error');
            }
      
            //loading...
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading...');
            }
      
            //return list view
            return ListView(
              children: snapshot.data!
                  .map<Widget>(
                      (userData) => _buildUserListItem(userData, context))
                  .toList(),
            );
          }),
    );
  }

  //build individual list tile for user
  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    //display all users except current user
    if (userData["email"] != _authService.getCurrentUser()!.email) {
      return Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: ListTile(
                onTap: () {
                  //tapped on a user -> go to chat page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        receiverEmail: userData["email"],
                        receiverID: userData["uid"],
                      ),
                    ),
                  );
                },
                leading: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: ClipOval(
                    child: SizedBox(
                      width: 45,
                      height: 45,
                      child: Image.network(userData['avatar'], fit: BoxFit.cover,),
                    ),
                  ),
                ),
                title: Text(
                  userData['first name']+' '+userData['last name'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  userData['email'],
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: isDarkMode ? Colors.grey[500] : Colors.grey[700],
                  ),
                ),
                trailing: Text('1 minute ago'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 20.0),
            child: Container(
              height: 0,
              child: Divider(
                thickness: 0.7,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      );
      // return UserTile(

      //   onTap: () {
      //     //tapped on a user -> go to chat page
      //     Navigator.push(
      //       context, MaterialPageRoute(builder: (context) => ChatPage(
      //         receiverEmail: userData["email"],
      //         receiverID: userData["uid"],
      //       ),
      //       ),
      //     );
      //   },
      // );
    } else {
      return Container();
    }
  }
}
