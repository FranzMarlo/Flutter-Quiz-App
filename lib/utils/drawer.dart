import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/screen/about.dart';
import 'package:quiz_app/screen/leaderboard.dart';
import 'package:quiz_app/screen/profile.dart';
import 'package:quiz_app/services/stream_builder.dart';
import 'package:quiz_app/utils/dialog.dart';
import 'constants.dart';

class drawer extends StatefulWidget {
  drawer({super.key});

  @override
  State<drawer> createState() => _drawerState();
}

class _drawerState extends State<drawer> {
  final user = FirebaseAuth.instance.currentUser!;
  String? uid;
  String? firstName;
  String? lastName;
  String? email;
  int? totalPoints;
  String? imageLink;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          DrawerHeader(
            padding: EdgeInsets.all(0),
            decoration: BoxDecoration(
              color: appBar,
            ),
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: appBar),
              accountName: FutureBuilder(
                  future: _fetchUserData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return Text(
                        '',
                      );
                    } else {
                      return Text(
                        '$firstName $lastName',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SF Pro'),
                      );
                    }
                  }),
              accountEmail: FutureBuilder(
                  future: _fetchUserData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return Text(
                        '',
                      );
                    } else {
                      return Text(
                        "$email",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SF Pro'),
                      );
                    }
                  }),
              currentAccountPictureSize: Size.square(50),
              currentAccountPicture: FutureBuilder(
                future: _fetchUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return CircleAvatar(
                        backgroundImage: NetworkImage(
                            'https://preview.redd.it/high-resolution-remakes-of-the-old-default-youtube-avatar-v0-bgwxf7bec4ob1.png?width=640&crop=smart&auto=webp&s=99d5fec405e0c7fc05f94c1e1754f7dc29ccadbd'));
                  } else if (imageLink == 'no image') {
                    return CircleAvatar(
                        backgroundImage: NetworkImage(
                            'https://preview.redd.it/high-resolution-remakes-of-the-old-default-youtube-avatar-v0-bgwxf7bec4ob1.png?width=640&crop=smart&auto=webp&s=99d5fec405e0c7fc05f94c1e1754f7dc29ccadbd'));
                  } else {
                    return CircleAvatar(
                        backgroundImage: NetworkImage('$imageLink'));
                  }
                },
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.home_filled,
              color: appBar,
            ),
            title: const Text(
              ' Home ',
              style: TextStyle(fontFamily: 'SF Pro'),
            ),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => streamBuilder()));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.person,
              color: appBar,
            ),
            title: const Text(
              ' My Profile ',
              style: TextStyle(fontFamily: 'SF Pro'),
            ),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => userProfile()));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.star,
              color: appBar,
            ),
            title: const Text(
              ' Leaderboard ',
              style: TextStyle(fontFamily: 'SF Pro'),
            ),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => leaderboard()));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.info_outline,
              color: appBar,
            ),
            title: const Text(
              ' About ',
              style: TextStyle(fontFamily: 'SF Pro'),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => aboutApp()));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: appBar,
            ),
            title: const Text(
              ' Log Out ',
              style: TextStyle(fontFamily: 'SF Pro'),
            ),
            onTap: () {
              showDialog(context: context, builder: (_) => logoutDialog());
            },
          ),
        ],
      ),
    );
  }
}
