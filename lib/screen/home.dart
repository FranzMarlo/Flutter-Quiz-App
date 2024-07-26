import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/quiz/chap1a.dart';
import 'package:quiz_app/quiz/chap1b.dart';
import 'package:quiz_app/quiz/chap2.dart';
import 'package:quiz_app/quiz/chap3.dart';
import 'package:quiz_app/quiz/chap4.dart';
import 'package:quiz_app/quiz/chap5.dart';
import 'package:quiz_app/quiz/chap6.dart';
import 'package:quiz_app/utils/drawer.dart';
import '../utils/constants.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  final user = FirebaseAuth.instance.currentUser!;
  String? uid;
  String? firstName;
  String? lastName;
  String? email;
  int? totalPoints;
  String? imageLink;
  int? currentRank;
  List<String> finalRanking = [];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    getRanking();
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
  void dispose() {      
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
            toolbarHeight: 40,
            backgroundColor: appBar,
            scrolledUnderElevation: 0.0,
            iconTheme: const IconThemeData(color: text)),
        drawer: drawer(),
        backgroundColor: appBar,
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 10, 10, 1),
                        child: FutureBuilder(
                            future: _fetchUserData(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState !=
                                  ConnectionState.done) {
                                return Text(
                                  '',
                                );
                              } else {
                                return Text(
                                  'Hi, $firstName',
                                  style: const TextStyle(
                                      color: text,
                                      fontSize: 25,
                                      fontFamily: 'SF Pro',
                                      fontWeight: FontWeight.bold),
                                );
                              }
                            }),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                          'Let\'s make this day productive!',
                          style: TextStyle(
                            color: text,
                            fontSize: 15,
                            fontFamily: 'SF Pro',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 15, 1),
                    child: FutureBuilder(
                        future: _fetchUserData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                    'https://preview.redd.it/high-resolution-remakes-of-the-old-default-youtube-avatar-v0-bgwxf7bec4ob1.png?width=640&crop=smart&auto=webp&s=99d5fec405e0c7fc05f94c1e1754f7dc29ccadbd'));
                          } else if (imageLink == 'no image') {
                            return CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                    'https://preview.redd.it/high-resolution-remakes-of-the-old-default-youtube-avatar-v0-bgwxf7bec4ob1.png?width=640&crop=smart&auto=webp&s=99d5fec405e0c7fc05f94c1e1754f7dc29ccadbd'));
                          } else {
                            return CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage('$imageLink'));
                          }
                        }),
                  )
                ],
              ),
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  height: 70,
                  width: double.infinity,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      color: background,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(
                            child: Image.asset(
                              'assets/images/trophy.png',
                              height: 40,
                              width: 40,
                            ),
                          ),
                          SizedBox(
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Ranking',
                                    style: TextStyle(
                                      fontFamily: 'SF Pro',
                                      fontSize: 15,
                                    ),
                                  ),
                                  FutureBuilder(
                                      future: getRanking(),
                                      builder: (context, snapshot) {
                                        return Text(
                                          '$currentRank',
                                          style: TextStyle(
                                              fontFamily: 'SF Pro',
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        );
                                      }),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                            child: VerticalDivider(
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                            width: 40,
                            child: Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 40,
                            ),
                          ),
                          SizedBox(
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Points',
                                    style: TextStyle(
                                      fontFamily: 'SF Pro',
                                      fontSize: 15,
                                    ),
                                  ),
                                  FutureBuilder(
                                      future: _fetchUserData(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState !=
                                            ConnectionState.done) {
                                          return Text('');
                                        } else {
                                          return Text(
                                            '$totalPoints',
                                            style: TextStyle(
                                                fontFamily: 'SF Pro',
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          );
                                        }
                                      }),
                                ],
                              ),
                            ),
                          ),
                        ]),
                  ),
                ),
              )),
              const Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  'Let\'s take a quiz!',
                  style: TextStyle(
                      color: text,
                      fontSize: 20,
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 13,
                  crossAxisSpacing: 13,
                  padding: const EdgeInsets.all(10),
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const chap1APrelim()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: background,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/chap1a.png',
                              scale: 2.8,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              child: const Text('Chapter 1A',
                                  style: TextStyle(
                                      fontFamily: 'SF Pro',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const chap1BPrelim()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: background,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/chap1b.png',
                              scale: 2.5,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              child: const Text('Chapter 1B',
                                  style: TextStyle(
                                      fontFamily: 'SF Pro',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const chap2Prelim()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: background,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/chap2.png',
                              scale: 2.8,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              child: const Text('Chapter 2',
                                  style: TextStyle(
                                      fontFamily: 'SF Pro',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const chap3Prelim()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: background,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/chap3.png',
                              scale: 3.0,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              child: const Text('Chapter 3',
                                  style: TextStyle(
                                      fontFamily: 'SF Pro',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const chap4Prelim()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: background,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/chap4.png',
                              scale: 3.0,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              child: const Text('Chapter 4',
                                  style: TextStyle(
                                      fontFamily: 'SF Pro',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const chap5Prelim()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: background,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/chap5.png',
                              scale: 2.5,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              child: const Text('Chapter 5',
                                  style: TextStyle(
                                      fontFamily: 'SF Pro',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const chap6Prelim()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: background,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/chap6.png',
                              scale: 2.7,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              child: const Text('Chapter 6',
                                  style: TextStyle(
                                      fontFamily: 'SF Pro',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
      ),
    );
  }
}
