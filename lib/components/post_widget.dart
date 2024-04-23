// import 'package:app/themes/theme_provider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class PostWidget extends StatefulWidget {
//   const PostWidget({super.key});

//   @override
//   State<PostWidget> createState() => _PostWidgetState();
// }

// class _PostWidgetState extends State<PostWidget> {
//   final user = FirebaseAuth.instance.currentUser!;
//   @override
//   Widget build(BuildContext context) {
//     bool isDarkMode =
//         Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
//     return StreamBuilder<DocumentSnapshot>(
//       stream: FirebaseFirestore.instance.collection('posts').doc(widget.postId).snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasData && snapshot.data!.exists) {
//           final userPost = snapshot.data!.data() as Map<String, dynamic>;
//           return FutureBuilder(
//               future: FirebaseFirestore.instance
//                   .collection('users')
//                   .doc(!user.uid)
//                   .get(),
//               builder: (context, usersnapshot) {
//                 if (usersnapshot.hasData && usersnapshot.data!.exists) {
//                   final userData =
//                       usersnapshot.data!.data() as Map<String, dynamic>;
                  
//                 } else if (usersnapshot.hasError) {
//                   return Center(
//                     child: Text("Error${usersnapshot.error}"),
//                   );
//                 }
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }
//             );
//         } else if (snapshot.hasError) {
//           return Center(
//             child: Text("Error${snapshot.error}"),
//           );
//         }
//         return const Center(
//           child: CircularProgressIndicator(),
//         );
//       },
//     );
//   }
// }
