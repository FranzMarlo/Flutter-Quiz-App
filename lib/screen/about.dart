import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/utils/dialog.dart';
import '../utils/constants.dart';

class aboutApp extends StatefulWidget {
  const aboutApp({super.key});

  @override
  State<aboutApp> createState() => _aboutAppState();
}

class _aboutAppState extends State<aboutApp> {
  final user = FirebaseAuth.instance.currentUser!;
  String? uid;
  String? buildNumber;
  _fetchUserData() async {
    await FirebaseFirestore.instance
        .collection('AppUsers')
        .doc(user.uid)
        .get()
        .then((snapshot) {
      uid = snapshot['uid'];
      buildNumber = uid!.substring(0, 11).toUpperCase();
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          centerTitle: true,
          title: const Text(
            'About',
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: fadedWhite,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        backgroundColor: fadedWhite,
        body: SingleChildScrollView(
          child: Container(
            height: mediaQuery.size.height,
            child: Column(
              children: [
                Center(
                  child: SizedBox(
                    height: 300,
                    width: 300,
                    child: Image.asset('assets/images/logo.png'),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: SizedBox(
                      height: 60,
                      width: mediaQuery.size.width,
                      child: Container(
                        decoration: BoxDecoration(
                            color: text,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 5,
                                blurRadius: 7,
                              ),
                            ]),
                        child: Row(children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: SizedBox(
                              height: 40,
                              width: 40,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: fadedBlack,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.build_circle_sharp,
                                  color: text,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: SizedBox(
                                child: Text(
                              'Build Number',
                              style: TextStyle(
                                  fontFamily: 'SF Pro',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                          Spacer(),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: SizedBox(
                                child: FutureBuilder(
                              future: _fetchUserData(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return Text(
                                    '$buildNumber',
                                    style: TextStyle(
                                        fontFamily: 'SF Pro',
                                        fontSize: 18,
                                        color: fadedBlack),
                                  );
                                } else {
                                  return Text('');
                                }
                              },
                            )),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: SizedBox(
                      height: 60,
                      width: mediaQuery.size.width,
                      child: Container(
                        decoration: BoxDecoration(
                            color: text,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 5,
                                blurRadius: 7,
                              ),
                            ]),
                        child: Row(children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: SizedBox(
                              height: 40,
                              width: 40,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: appBar,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.verified_user,
                                  color: text,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: SizedBox(
                                child: Text(
                              ' App Version',
                              style: TextStyle(
                                  fontFamily: 'SF Pro',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                          Spacer(),
                          Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: SizedBox(
                                  child: Text(
                                'v1.0 Beta',
                                style: TextStyle(
                                    fontFamily: 'SF Pro',
                                    fontSize: 18,
                                    color: fadedBlack),
                              ))),
                        ]),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context, builder: (_) => logoutDialog());
                  },
                  child: Center(
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
                ),
              ],
            ),
          ),
        ));
  }
}
