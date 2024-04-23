import 'package:app/services/auth/auth_page.dart';
import 'package:app/services/auth/auth_service.dart';
import 'package:app/services/gg-fb/firebase_services.dart';
import 'package:app/services/gg-fb/firebase_services2.dart';
import 'package:app/themes/theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MySettingsPage extends StatefulWidget {
  const MySettingsPage({super.key});

  @override
  State<MySettingsPage> createState() => _MySettingsPageState();
}

class _MySettingsPageState extends State<MySettingsPage> {
  final user = FirebaseAuth.instance.currentUser!;
  void logout() async {
    final _auth = AuthService();
    _auth.signOut();
  }
  Future<void> deleteDocumentsByField(String collectionName, String fieldName, dynamic value) async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection(collectionName).where(fieldName, isEqualTo: value).get();
    final List<DocumentSnapshot> documents = snapshot.docs;

    if (documents.isNotEmpty) {
      for (DocumentSnapshot document in documents) {
        await document.reference.delete();
      }

      print('Deleted documents from collection: $collectionName where $fieldName = $value');
    } else {
      print('No documents found in collection: $collectionName where $fieldName = $value');
    }
  }
  // Future<void> deleteMessages() async {
  //   // String otherUserId = !user.uid; // Thay ID của người dùng khác ở đây
  //   String chatRoomId = [user.uid, otherUserId].join('_');
  //   await FirebaseFirestore.instance
  //       .collection('chat_rooms')  // Thay 'chat_room' bằng tên của collection chat room
  //       .doc(chatRoomId)  
  //       .collection('messages')  // Thay 'message' bằng tên của collection message
  //       .where('senderID', isEqualTo: user.uid)
  //       .get()
  //       .then((querySnapshot) {
  //         querySnapshot.docs.forEach((doc) async {
  //           await doc.reference.delete();
  //         });
  //       });
  //   print('Deleted messages successfully');
  // }
  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        // centerTitle: true,
        title: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Text(
          'Settings',
          style: TextStyle(
              fontSize: 25, color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        ),
        elevation: 0,
        automaticallyImplyLeading: false, // mất nút quay về
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 26.0),
            child: Text(
              "Options",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(left: 25, right: 25, bottom: 20, top: 10),
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //dark mode
                const Text("Dark mode", style: TextStyle(fontSize: 17),),
                //switch toggle
                CupertinoSwitch(
                  value: Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
                  onChanged: (value) {
                    Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                  },
                ),
              ]
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(right: 25, left: 25, bottom: 20),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 23),
            child: const Text("Language and region",  style: TextStyle(fontSize: 17),),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(right: 25, left: 25, bottom: 20),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 23),
            child: const Text("Active status",  style: TextStyle(fontSize: 17),),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(right: 25, left: 25, bottom: 20),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 23),
            child: const Text("Activity diary",  style: TextStyle(fontSize: 17),),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(right: 25, left: 25, bottom: 20),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 23),
            child: const Text("Notification",  style: TextStyle(fontSize: 17),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 26.0),
            child: Text(
              "Support",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(right: 25, left: 25, bottom: 20, top: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 23),
            child: const Text("Terms and policies",  style: TextStyle(fontSize: 17),),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(right: 25, left: 25, bottom: 20),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 23),
            child: const Text("Help",  style: TextStyle(fontSize: 17),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 26.0),
            child: Text(
              "Exit",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(right: 25, left: 25, bottom: 20, top: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Log out
                const Text("Log out",  style: TextStyle(fontSize: 17),),
                // button
                IconButton(
                  onPressed: () async {
                    logout();
                    await FireBaseServices().signOut();
                    await FireBaseServices2().signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => AuthPage()), // Chuyển đến trang đăng nhập sau khi đăng xuất
                    );
                  },
                  icon: Icon(Icons.logout),
                ),
              ]
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(right: 25, left: 25, bottom: 20,),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Delete account",  style: TextStyle(fontSize: 17),),
                IconButton(
                  onPressed: () async {
                    bool confirmDelete = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Confirm delete'),
                        content: Text('Are you sure you want to delete your account?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text('Cancel', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black ),),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text('Delete', style: TextStyle(color: Colors.red),),
                          )
                        ],
                      ),
                    );
                    if (confirmDelete == true) {
                      final user = FirebaseAuth.instance.currentUser;
                      await FirebaseFirestore.instance.collection('users').doc(user!.uid).delete();
                      await deleteDocumentsByField('posts', 'uid', user.uid);
                      await user.delete();
                      logout();
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthPage(),));
                    }
                  },
                  icon: Icon(Icons.delete),
                ),
              ],
            ),
          ),
        ] 
      ),
    );
  }
}