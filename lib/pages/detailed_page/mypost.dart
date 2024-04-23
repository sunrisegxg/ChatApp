import 'package:app/components/page_common.dart';
import 'package:app/components/post_widget.dart';
import 'package:app/pages/bottom_app_bar_page/account_page.dart';
import 'package:app/pages/bottom_app_bar_page/home_page.dart';
import 'package:app/themes/theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MyPost extends StatefulWidget {
  final String postId; // Biến để lưu trữ ID của bài viết
  const MyPost({super.key, required this.postId});

  @override
  State<MyPost> createState() => _MyPostState();
}

class _MyPostState extends State<MyPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isContainerVisible = false;
  String timestampToString(Timestamp timestamp) {
    // Tạo đối tượng DateTime từ Timestamp
    DateTime now = DateTime.now();
    DateTime dateTime = timestamp.toDate();
    // Tính toán khoảng thời gian giữa thời gian hiện tại và thời gian đăng bài
    Duration difference = now.difference(dateTime);

    // Lấy giá trị tuyệt đối của khoảng thời gian
    difference = difference.abs();

    // Định dạng khoảng thời gian thành một chuỗi phù hợp
    String timeAgo = getTimeAgo(difference);

    return timeAgo;
  }

  String getTimeAgo(Duration difference) {
    if (difference.inDays > 365) {
      int years = (difference.inDays / 365).floor();
      return '$years năm trước';
    } else if (difference.inDays > 30) {
      int months = (difference.inDays / 30).floor();
      return '$months tháng trước';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'vừa xong';
    }
  }

  //edit field
  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text(
            "Edit " + field,
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            
            autofocus: true,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              
              hintText: "Enter new $field",
              hintStyle: TextStyle(color: Colors.grey),
            ),
            onChanged: (value) {
              newValue = value.trim();
            },
          ),
          actions: [
            //cancel button
            TextButton(
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                setState(() {
                    newValue = "";
                });
                Navigator.pop(context);
              } 
            ),
            //save button
            TextButton(
              child: Text(
                "Save",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(newValue),
            ),
          ]),
    );
    // update in firestore
    if (newValue.trim().length > 0) {
      //only update if there is something in the textfield
      await FirebaseFirestore.instance.collection('posts').doc(widget.postId).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    //     final QuerySnapshot usersnapshot = await FirebaseFirestore.instance.collection("users").where('uid', isEqualTo: currentUser.uid).get();
    // String avatarUrl;
    // if (usersnapshot.docs.isNotEmpty) {
    //   final userData = userSnapshot.docs.last.data() as Map<String, dynamic>;
    //   setState(() {
    //     avatarUrl = userData['avatar'];
    //   });
    // }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'My post',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
        leadingWidth: 70,
        iconTheme: IconThemeData(
          color: isDarkMode
              ? Colors.white
              : Colors.black, // Màu sắc của nút quay về
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("posts")
                  .doc(widget.postId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.exists) {
                  final userPost = snapshot.data!.data() as Map<String, dynamic>;
                  return FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(currentUser.uid)
                        .get(),
                    builder: (context, usersnapshot) {
                      if (usersnapshot.hasData && usersnapshot.data!.exists) {
                        final userData =
                            usersnapshot.data!.data() as Map<String, dynamic>;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              isContainerVisible = false;
                            });
                          },
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          width: 1,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width,
                                          child: Center(
                                            child: ListTile(
                                              leading: ClipOval(
                                                child: SizedBox(
                                                  width: 50,
                                                  height: 50,
                                                  child: Image.network(
                                                    userData['avatar'],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              title: Text(
                                                userData['first name'] + ' ' + userData['last name'],
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              subtitle: Text(
                                                timestampToString(
                                                    userPost['timepost']),
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                              trailing: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    isContainerVisible = !isContainerVisible;
                                                  });
                                                },
                                                icon: Icon(Icons.more_horiz),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20.0,
                                                    right: 20.0,
                                                    bottom: 15.0),
                                                child: Text(
                                                  userPost['caption'],
                                                  style: TextStyle(fontSize: 20),
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: isDarkMode
                                                        ? Colors.black12
                                                        : Colors
                                                            .grey, // Màu của border
                                                    width: 0.5, // Độ dày của border
                                                  ),
                                                ),
                                                child: Image.network(
                                                  userPost['imagePost'],
                                                  height: 300,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width,
                                          // height: 120,
                                          // color: Colors.blue,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                // color: Colors.blue,
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 15.0,
                                                      vertical: 12.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Image.asset(
                                                            'lib/images/heart.png',
                                                            height: 20,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            '0',
                                                            style: TextStyle(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight.w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Row(children: [
                                                            Text(
                                                              '0',
                                                              style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight.w500,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Image.asset(
                                                              'lib/images/chat-bubble.png',
                                                              height: 20,
                                                            ),
                                                          ]),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Row(children: [
                                                            Text(
                                                              '0',
                                                              style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight.w500,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Image.asset(
                                                              'lib/images/shared.png',
                                                              height: 20,
                                                            ),
                                                          ]),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 10.0, vertical: 0),
                                                child: Container(
                                                  height: 0,
                                                  child: Divider(
                                                    thickness: 0.7,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 15.0,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {},
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 11.0),
                                                        child: const Row(
                                                          children: [
                                                            Icon(
                                                                Icons.favorite_outline),
                                                            SizedBox(
                                                                width:
                                                                    5), // Khoảng cách giữa biểu tượng và văn bản
                                                            Text(
                                                                'Love', style: TextStyle(fontSize: 16),), // Văn bản bên cạnh biểu tượng
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {},
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 11.0),
                                                        child: Row(
                                                          children: [
                                                          Image.asset(
                                                            'lib/images/comment.png',
                                                            height: 20,
                                                            color: isDarkMode
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                          const SizedBox(
                                                              width:
                                                                  5), // Khoảng cách giữa biểu tượng và văn bản
                                                          const Text(
                                                              'Comment', style: TextStyle(fontSize: 16),), // Văn bản bên cạnh biểu tượng
                                                        ],
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {},
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 11.0),
                                                        child: Row(
                                                          children: [
                                                          Image.asset(
                                                            'lib/images/share.png',
                                                            
                                                            height: 20,
                                                            color: isDarkMode
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                          SizedBox(
                                                              width:
                                                                  5), // Khoảng cách giữa biểu tượng và văn bản
                                                          Text(
                                                              'Share', style: TextStyle(fontSize: 16),), // Văn bản bên cạnh biểu tượng
                                                        ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                top: 55,
                                right: 38,
                                child: Visibility(
                                  visible: isContainerVisible,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            editField("caption");
                                          },
                                          child: Container(
                                            width: 185,
                                            decoration: BoxDecoration(
                                                // borderRadius: BorderRadius.circular(20),
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color: Colors.grey,
                                                        width: 0.5))),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16, horizontal: 35),
                                            child: Center(
                                              child: Text(
                                                "Update caption",
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            bool? confirmDelete = await showDialog<bool?>(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text('Confirm delete'),
                                                content: Text('Are you sure you want to delete your post?'),
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
                                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CommonPage()),);
                                              await FirebaseFirestore.instance.collection('posts').doc(widget.postId).delete(); 
                                            }
                                          },
                                          child: Container(
                                            width: 185,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              // borderRadius: BorderRadius.circular(12),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16, horizontal: 35),
                                            child: Center(
                                              child: Text(
                                                "Delete post",
                                                style: TextStyle(
                                                    color: Colors.pink,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (usersnapshot.hasError) {
                        return Center(
                          child: Text("Error${usersnapshot.error}"),
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error${snapshot.error}"),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ),
      ),
    );
  }
}
