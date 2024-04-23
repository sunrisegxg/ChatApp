import 'package:app/pages/detailed_page/mypost.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ImageView extends StatefulWidget {
  const ImageView({super.key});
  
  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  int imageCount = 0;
  final currentUser = FirebaseAuth.instance.currentUser!;
  @override
  void initState() {
    getImageCount();
    super.initState();
  }
  Future<void> getImageCount() async {
    try {
      CollectionReference imagesRef = FirebaseFirestore.instance.collection('posts');
      QuerySnapshot snapshot1 = await imagesRef.where('uid', isEqualTo: currentUser.uid).get();
      setState(() {
        imageCount = snapshot1.size;
      });
    } catch (e) {
      print("Error: $e");
    }
  }
  Future<Map<String, dynamic>> getImageData(int index) async {
    try {
      CollectionReference imagesRef = FirebaseFirestore.instance.collection('posts');
      QuerySnapshot snapshot = await imagesRef
        .where('uid', isEqualTo: currentUser.uid)
        .orderBy('timepost', descending: true).get();
      DocumentSnapshot imageDoc = snapshot.docs[index];
      String imagePost = imageDoc['imagePost'];
      String postId = imageDoc['postId'];
      return {'imagePost': imagePost, 'postId': postId};
    } catch (e) {
      throw e;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 1.0),
      child: imageCount > 0 ? MasonryGridView.builder(
        itemCount: imageCount,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 1.0, right:1.0),
          child: ClipRRect(
            child: FutureBuilder(
              future: getImageData(index),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    height: 100,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else {
                  Map<String, dynamic> imageData = snapshot.data as Map<String, dynamic>;
                  String imagePost = imageData['imagePost'] as String;
                  String postId = imageData['postId'] as String;
                  return GestureDetector(
                    onTap:() {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MyPost(postId: postId),));
                    },
                    child: Image.network(
                      imagePost, fit: BoxFit.cover,
                      height: 100,
                      ),
                    );
                }
              },
            ),
          ),
        ),
      )
      : Center(
        child: Text('No images available'),
      )
    );
  }
}