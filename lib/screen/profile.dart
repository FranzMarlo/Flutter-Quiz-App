import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quiz_app/screen/about.dart';
import 'package:quiz_app/screen/change_password.dart';
import 'package:quiz_app/services/image_picker.dart';
import 'package:quiz_app/services/store_data.dart';
import 'package:quiz_app/services/stream_builder.dart';
import '../utils/constants.dart';
import '../utils/dialog.dart';

class userProfile extends StatefulWidget {
  const userProfile({super.key});

  @override
  State<userProfile> createState() => _userProfileState();
}

class _userProfileState extends State<userProfile> {
  final user = FirebaseAuth.instance.currentUser!;
  String? imageLink;
  String? firstName;
  String? lastName;
  String? email;
  String? uid;
  int? totalPoints;
  Uint8List? _image;
  int? currentRank;
  List<String> finalRanking = [];

  _fetchUserData() async {
    await FirebaseFirestore.instance
        .collection('AppUsers')
        .doc(user.uid)
        .get()
        .then((snapshot) {
      uid = snapshot['uid'];
      firstName = snapshot['firstName'];
      lastName = snapshot['lastName'];
      email = snapshot['email'];
      totalPoints = snapshot['totalPoints'];
      imageLink = snapshot['imageLink'];
    }).catchError((e) {
      print(e);
    });
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
      addImage();
      _fetchUserData();
    });
  }

  void addImage() async {
    await storeData().saveData(file: _image!);
  }

  getRanking() async {
    await FirebaseFirestore.instance
        .collection('AppUsers')
        .orderBy('totalPoints', descending: true)
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              finalRanking.add(document.get('uid').toString());
            }));
    for (String id in finalRanking) {
      if (id == user.uid) {
        currentRank = finalRanking.indexOf(id) + 1;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    getRanking();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Profile',
            style: TextStyle(
                color: text, fontFamily: 'SF Pro', fontWeight: FontWeight.bold),
          ),
          backgroundColor: appBar,
          iconTheme: const IconThemeData(color: text),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const streamBuilder())),
          ),
        ),
        backgroundColor: appBar,
        body: Container(
          child: SingleChildScrollView(
              child: Column(children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Stack(
                  children: [
                    FutureBuilder(
                        future: _fetchUserData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return CircleAvatar(
                              radius: 70,
                              backgroundImage: NetworkImage(
                                  'https://preview.redd.it/high-resolution-remakes-of-the-old-default-youtube-avatar-v0-bgwxf7bec4ob1.png?width=640&crop=smart&auto=webp&s=99d5fec405e0c7fc05f94c1e1754f7dc29ccadbd'),
                            );
                          } else if (imageLink == 'no image') {
                            return CircleAvatar(
                                radius: 70,
                                backgroundImage: NetworkImage(
                                    'https://preview.redd.it/high-resolution-remakes-of-the-old-default-youtube-avatar-v0-bgwxf7bec4ob1.png?width=640&crop=smart&auto=webp&s=99d5fec405e0c7fc05f94c1e1754f7dc29ccadbd'));
                          } else if (_image != null) {
                            return CircleAvatar(
                              radius: 70,
                              backgroundImage: MemoryImage(_image!),
                            );
                          } else {
                            return CircleAvatar(
                              radius: 70,
                              backgroundImage: NetworkImage('$imageLink'),
                            );
                          }
                        }),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        icon: Icon(
                          Icons.add_a_photo_rounded,
                          color: text,
                        ),
                        onPressed: () {
                          selectImage();
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            Center(
                child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: FutureBuilder(
                future: _fetchUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Text('');
                  } else {
                    return Text(
                      '$firstName $lastName',
                      style: TextStyle(
                          color: text,
                          fontFamily: 'SF Pro',
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    );
                  }
                },
              ),
            )),
            Container(
              width: mediaQuery.size.width,
              height: (mediaQuery.size.height - 0 - mediaQuery.padding.top),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                color: fadedWhite,
                border: Border.all(
                  color: fadedWhite,
                  width: 3,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 30, 20, 5),
                    child: SizedBox(
                      height: 50,
                      width: mediaQuery.size.width,
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                              color: text),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, right: 5),
                                child: SizedBox(
                                  height: 35,
                                  width: 35,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: correct),
                                    child: Icon(
                                      Icons.email,
                                      color: text,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 0, 10),
                                child: Text(
                                  'Email',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'SF Pro',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 20, 10),
                                child: FutureBuilder(
                                    future: _fetchUserData(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState !=
                                          ConnectionState.done) {
                                        return Text(
                                          'Loading Please Wait...',
                                          style: TextStyle(
                                              fontFamily: 'SF Pro',
                                              color: fadedBlack,
                                              fontSize: 18),
                                        );
                                      } else {
                                        return Text(
                                          '$email',
                                          style: TextStyle(
                                              fontFamily: 'SF Pro',
                                              color: fadedBlack,
                                              fontSize: 15),
                                        );
                                      }
                                    }),
                              ),
                            ],
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                    child: SizedBox(
                      height: 50,
                      width: mediaQuery.size.width,
                      child: Container(
                          decoration: BoxDecoration(color: text),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, right: 5),
                                child: SizedBox(
                                  height: 35,
                                  width: 35,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.amber),
                                    child: Icon(
                                      Icons.star,
                                      color: text,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 0, 10),
                                child: Text(
                                  'Total Points',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'SF Pro',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 20, 10),
                                child: FutureBuilder(
                                    future: _fetchUserData(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState !=
                                          ConnectionState.done) {
                                        return Text(
                                          'Loading Please Wait...',
                                          style: TextStyle(
                                              fontFamily: 'SF Pro',
                                              color: fadedBlack,
                                              fontSize: 18),
                                        );
                                      } else {
                                        return Text(
                                          '$totalPoints',
                                          style: TextStyle(
                                              fontFamily: 'SF Pro',
                                              color: fadedBlack,
                                              fontSize: 18),
                                        );
                                      }
                                    }),
                              ),
                            ],
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                    child: SizedBox(
                      height: 50,
                      width: mediaQuery.size.width,
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                              color: text),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, right: 5),
                                child: SizedBox(
                                  height: 35,
                                  width: 35,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.blue),
                                    child: Icon(
                                      Icons.bar_chart,
                                      color: text,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 0, 10),
                                child: Text(
                                  'Ranking',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'SF Pro',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 20, 10),
                                child: FutureBuilder(
                                    future: getRanking(),
                                    builder: (context, snapshot) {
                                      return Text(
                                        '$currentRank',
                                        style: TextStyle(
                                            fontFamily: 'SF Pro',
                                            color: fadedBlack,
                                            fontSize: 18),
                                      );
                                    }),
                              ),
                            ],
                          )),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => changePassword()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 40, 20, 5),
                      child: SizedBox(
                        height: 70,
                        width: mediaQuery.size.width,
                        child: Container(
                            decoration: BoxDecoration(
                                color: text,
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 0, 10),
                                  child: SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: fadedBlack,
                                      ),
                                      child: Icon(
                                        Icons.lock,
                                        color: text,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: Text(
                                    'Change Password',
                                    style: TextStyle(
                                        fontFamily: 'SF Pro',
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Spacer(),
                                Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 10, 20, 10),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: fadedBlack,
                                    )),
                              ],
                            )),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => aboutApp()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                      child: SizedBox(
                        height: 70,
                        width: mediaQuery.size.width,
                        child: Container(
                            decoration: BoxDecoration(
                                color: text,
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 0, 10),
                                  child: SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: appBar),
                                      child: Icon(
                                        Icons.info_rounded,
                                        color: text,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: Text(
                                    'About',
                                    style: TextStyle(
                                        fontFamily: 'SF Pro',
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Spacer(),
                                Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 10, 20, 10),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: fadedBlack,
                                    )),
                              ],
                            )),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context, builder: (_) => logoutDialog());
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                      child: SizedBox(
                        height: 70,
                        width: mediaQuery.size.width,
                        child: Container(
                            decoration: BoxDecoration(
                                color: text,
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 0, 10),
                                  child: SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: incorrect,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        Icons.exit_to_app,
                                        color: text,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: Text(
                                    'Log Out',
                                    style: TextStyle(
                                        fontFamily: 'SF Pro',
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Spacer(),
                                Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 10, 20, 10),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: fadedBlack,
                                    )),
                              ],
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ])),
        ));
  }
}
