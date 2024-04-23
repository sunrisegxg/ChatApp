import 'dart:io';
import 'dart:typed_data';

import 'package:app/components/button_close.dart';
import 'package:app/components/button_upload.dart';
import 'package:app/components/textarea.dart';
import 'package:app/models/add_data_image_post.dart';
import 'package:app/themes/theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key,});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final _caption = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;

  Future addPhotowithDataUser() async {
    if (_image != null) {
      try {
        var uid = Uuid().v4();
        Timestamp timepost = Timestamp.now();
        String imageUrl = await StoreDataImagePost().uploadImagePostToStorage(user.uid, _image!);
        await FirebaseFirestore.instance.collection('posts').doc(uid).set(
          {
            'uid' : user.uid,
            'email' : user.email,
            'imagePost' : imageUrl,
            'caption' : _caption.text.trim(),
            'timepost' : timepost,
            'postId' : uid,
          }
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Post uploaded successfully'),
          ),
        );
      } catch (e) {
        // Xử lý lỗi
        print('Failed to add post: $e');
      } 
    }
  }
  @override
  void dispose() {
    _caption.dispose();
    super.dispose();
  }
  //gallery
  Future _pickImageFromGallery() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;
    setState(() {
      selectedImage = File(returnImage.path);
      _image = File(returnImage.path).readAsBytesSync();
    });
    Navigator.of(context).pop();
  }

  //camera
  Future _pickImageFromCamera() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnImage == null) return;
    setState(() {
      selectedImage = File(returnImage.path);
      _image = File(returnImage.path).readAsBytesSync();
    });
    Navigator.of(context).pop();
  }
  Future<void> resetImageSelection() async {
    setState(() {
      _image = null;
      selectedImage = null;
    });
  }

  // function upload image
  void showImagePickerOption(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.blue[100],
      context: context,
      builder: (builder) {
        return Padding(
          padding: const EdgeInsets.only(top: 25.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 250,
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Complete the operation with',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 100.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              _pickImageFromGallery();
                            },
                            child: const SizedBox(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.image,
                                    color: Colors.blue,
                                    size: 70,
                                  ),
                                  Text(
                                    'Gallery',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              _pickImageFromCamera();
                            },
                            child: const SizedBox(
                              child: Column(
                                children: [
                                  Icon(Icons.camera_alt,
                                      color: Colors.indigo, size: 70),
                                  Text(
                                    'Camera',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: BtnClose(onTap: () {
                      Navigator.pop(context);
                    }),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
  Uint8List? _image;
  File? selectedImage;
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
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
        actions: const [
          // Padding(
          //   padding: EdgeInsets.only(right: 10.0,),
          //   child: Row(children: [
          //     Icon(
          //       Icons.notifications,
          //       color: Colors.lightBlueAccent,
          //     ),
          //   ]),
          // ),
          Padding(
            padding: EdgeInsets.only(right: 30.0,),
            child: Row(children: [
              Icon(
                Icons.share,
                color: Colors.blue,
              ),
            ]),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10,),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Create Post",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
                  ),
                  Icon(Icons.star)
                ],
              ),
              const SizedBox(height: 20,),
              // upload image or video
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //upload image
                  GestureDetector(
                    onTap: () {
                      showImagePickerOption(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, color: Colors.pink, size: 25,),
                          SizedBox(width: 10,),
                          Text("Photo", style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold, fontSize: 16),),
                        ]
                      ),
                    ),
                  ),
                  //upload video
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 42),      
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.videocam, color: Colors.blue, size: 25,),
                        SizedBox(width: 10,),
                        Text("Video",  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16),),
                      ]
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              //upload and display
              Container(
                decoration: BoxDecoration(
                  // color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400,
                    width: 2,  // Độ dày của đường viền
                    style: BorderStyle.solid,  // Loại đường viền là dashed
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color:  isDarkMode? Color.fromARGB(255, 64, 68, 73) : Color.fromARGB(255, 225, 236, 250),
                    border: Border.all(
                      color:  isDarkMode? Color.fromARGB(255, 109, 115, 122) :Color.fromARGB(255, 199, 216, 237),  // Màu của đường viền
                      width: 2,  // Độ dày của đường viền
                      style: BorderStyle.solid,  // Loại đường viền là dashed
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _image != null ? Stack(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,  // Chiều rộng của container
                        height: 200,  // Chiều cao của container
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.memory(
                            _image!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: IconButton(
                          onPressed: resetImageSelection,
                          icon: const Icon(Icons.close, color: Colors.white,),
                        ),
                      ),
                    ],
                  )
                  : SizedBox(
                    width: MediaQuery.of(context).size.width,  // Chiều rộng của container
                    height: 200,  // Chiều cao của container
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 34),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'The uploaded photo or video will be displayed here',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 10,),
                            Icon(Icons.drive_folder_upload,
                              size: 35,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Caption",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              MyTextArea(controller: _caption , hintText: "Let's write something about it"),
              SizedBox(height:25),
              BtnUpload(onTap: () async {
                if (_caption.text.isNotEmpty) {
                  await addPhotowithDataUser();
                  await resetImageSelection();
                  _caption.clear(); 
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Please fill in caption'),
                    ),
                  );
                }
                
              }),
            ],
          ),
        ),
      ),
    );
  }
}