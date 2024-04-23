// ignore_for_file: prefer_const_constructors

import 'package:app/themes/theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    if (user != null) {
      return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 65,
        centerTitle: true,
        title: Text(
          'Wingle',
          style: TextStyle(
              fontSize: 25, color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        automaticallyImplyLeading: false, // mất nút quay về
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        //logo
        leading: Padding(
          padding: const EdgeInsets.only(left: 30.0,),
          child: Icon(
            Icons.camera,
          ),
        ),
        //share and
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Row(children: [
              const Icon(
                Icons.notifications,
                color: Colors.lightBlueAccent,
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0,),
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
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .where('uid', isNotEqualTo: user.uid)
              .orderBy('uid')
              .orderBy('timepost', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            return SingleChildScrollView(
              child: Column(
                children: List.generate(
                  snapshot.data!.docs.length,
                  (index) {
                    final postData = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;
                    return FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(postData['uid'])
                            .get(),
                        builder: (context, usersnapshot) {
                          if (usersnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          if (usersnapshot.hasError) {
                            return Center(
                                child: Text("Error: ${usersnapshot.error}"));
                          }
                          final userData =
                              usersnapshot.data!.data() as Map<String, dynamic>;
                          return Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              child: Column(children: [
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
                                        userData['first name'] +
                                            ' ' +
                                            userData['last name'],
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      subtitle: Text(
                                        timestampToString(postData['timepost']),
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                      trailing: Icon(Icons.more_horiz),
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
                                          postData['caption'],
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: isDarkMode
                                                ? Colors.black12
                                                : Colors.grey, // Màu của border
                                            width: 0.5, // Độ dày của border
                                          ),
                                        ),
                                        child: Image.network(
                                          postData['imagePost'],
                                          height: 300,
                                          width:
                                              MediaQuery.of(context).size.width,
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
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 25.0,
                                                        vertical: 11.0),
                                                    child: const Row(
                                                      children: [
                                                        Icon(Icons
                                                            .favorite_outline),
                                                        SizedBox(
                                                            width:
                                                                5), // Khoảng cách giữa biểu tượng và văn bản
                                                        Text(
                                                          'Love',
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ), // Văn bản bên cạnh biểu tượng
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {},
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15.0,
                                                        vertical: 11.0),
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
                                                          'Comment',
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ), // Văn bản bên cạnh biểu tượng
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {},
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 25.0,
                                                        vertical: 11.0),
                                                    child: Row(
                                                      children: [
                                                        Image.asset(
                                                          'lib/images/share.png',
                                                          height: 20,
                                                          color: isDarkMode
                                                              ? Colors.white
                                                              : Colors.black,
                                                        ),
                                                        const SizedBox(
                                                            width:
                                                                5), // Khoảng cách giữa biểu tượng và văn bản
                                                        const Text(
                                                          'Share',
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ), // Văn bản bên cạnh biểu tượng
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                        ),
                                      ]),
                                ),
                              ]));
                        });
                  },
                ),
                // itemCount:
                //     snapshot.data == null ? 0 : snapshot.data!.docs.length,
              ),
            );
          },
        ),
      ),

      //               // Padding(
      //               //   padding: const EdgeInsets.only(left: 8.0),
      //               //   child: Text(
      //               //     '0',
      //               //     style: TextStyle(
      //               //       fontSize: 13,
      //               //       fontWeight: FontWeight.w500,
      //               //     ),
      //               //   ),
      //               // ),
      //               // Padding(
      //               //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
      //               //   child: Row(
      //               //     children: [
      //               //       Text(
      //               //         'username ' + '',
      //               //         style: TextStyle(
      //               //           fontSize: 13,
      //               //           fontWeight: FontWeight.w500,
      //               //         ),
      //               //       ),
      //               //       Text(
      //               //         'caption',
      //               //         style: TextStyle(
      //               //           fontSize: 13,
      //               //         ),
      //               //       ),
      //               //     ],
      //               //   ),
      //               // ),
      //               // Padding(
      //               //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
      //               //   child: Text(
      //               //     'dateformat',
      //               //     style: TextStyle(
      //               //       fontSize: 13,
      //               //       color: Colors.grey,
      //               //     ),
      //               //   ),
      //               // ),
      //             ],
      //           ),
      //         ),
      //       ],
      //     ),
      //   );
      // // } else if (usersnapshot.hasError) {
      //   return Center(
      //     child: Text("Error: ${usersnapshot.error}"),
      //   );
      // }
      // return Center(
      //   child: CircularProgressIndicator(),
      // );
      //               }
      //               return Container();
      //             },
      //           );
      //         },
      //       );
      //     } else if (snapshot.hasError) {
      //       return Center(
      //         child: Text("Error: ${snapshot.error}"),
      //       );
      //     }
      //     return Center(
      //       child: CircularProgressIndicator(),
      //     );
      //   },
      // ),
    );
    }
    return Container();
  }
}
