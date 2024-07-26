import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/services/get_data.dart';
import 'package:quiz_app/services/stream_builder.dart';
import '../utils/constants.dart';

class leaderboard extends StatefulWidget {
  const leaderboard({super.key});

  @override
  State<leaderboard> createState() => _leaderboardState();
}

class _leaderboardState extends State<leaderboard> {
  final user = FirebaseAuth.instance.currentUser!;
  String? imageLink;
  String? firstName;
  String? lastName;
  String? email;
  String? uid;
  int? totalPoints;
  List<String> ranking = [];
  int? currentRank;
  List<String> finalRanking = [];

  getData() async {
    await FirebaseFirestore.instance
        .collection('AppUsers')
        .orderBy('totalPoints', descending: true)
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              ranking.add(document.get('uid').toString());
            }));
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
          scrolledUnderElevation: 0.0,
          centerTitle: true,
          title: const Text(
            'Leaderboard',
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: fadedWhite,
          iconTheme: const IconThemeData(color: Colors.black),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const streamBuilder())),
          ),
        ),
        backgroundColor: fadedWhite,
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: SizedBox(
                  height: 140,
                  width: mediaQuery.size.width,
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: appBar,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text(
                              'Your rank',
                              style: TextStyle(
                                color: text,
                                fontFamily: 'SF Pro',
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 0),
                                  child: SizedBox(
                                    width: 30,
                                    child: FutureBuilder(
                                        future: getRanking(),
                                        builder: (context, snapshot) {
                                          if(currentRank ==1){
                                            return Image.asset('assets/images/1st.png', fit: BoxFit.cover,);
                                          }
                                          else if(currentRank ==2){
                                            return Image.asset('assets/images/2nd.png', fit: BoxFit.cover,);
                                          }
                                          else if(currentRank ==3){
                                            return Image.asset('assets/images/3rd.png', fit: BoxFit.cover,);
                                          }
                                          else{
                                          return Text(
                                            '$currentRank',
                                            style: TextStyle(
                                                color: text,
                                                fontFamily: 'SF Pro',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          );
                                          }
                                        }),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
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
                                              backgroundImage:
                                                  NetworkImage('$imageLink'));
                                        }
                                      }),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: FutureBuilder(
                                      future: _fetchUserData(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState !=
                                            ConnectionState.done) {
                                          return Text('');
                                        } else {
                                          return Text(
                                            '$firstName',
                                            style: TextStyle(
                                                color: text,
                                                fontFamily: 'SF Pro',
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700),
                                          );
                                        }
                                      }),
                                ),
                                Spacer(),
                                Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: FutureBuilder(
                                      future: _fetchUserData(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState !=
                                            ConnectionState.done) {
                                          return Text('');
                                        } else {
                                          return Text(
                                            '$totalPoints',
                                            style: TextStyle(
                                                color: text,
                                                fontFamily: 'SF Pro',
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700),
                                          );
                                        }
                                      }),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(color: fadedWhite),
                  child: FutureBuilder(
                      future: getData(),
                      builder: (context, snapshot) {
                        return ListView.builder(
                          itemCount: ranking.length,
                          itemBuilder: (context, index) {
                            int rank = index + 1;
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: SizedBox(
                                height: 80,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: fadedBlack,
                                      width: 0.5,
                                    ),
                                    color: text,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 50,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 5, 0, 5),
                                            child: Builder(
                                              builder: (context) {
                                                if(rank == 1){
                                                  return Image.asset('assets/images/1st.png', height: 40, width: 40,);
                                                }
                                                else if(rank ==2){
                                                  return Image.asset('assets/images/2nd.png', height: 40, width: 40,);
                                                }
                                                else if(rank ==3){
                                                  return Image.asset('assets/images/3rd.png', height: 40, width: 40,);
                                                }
                                                else return Text(
                                                  '$rank',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: 'SF Pro',
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 18,
                                                      color: fadedBlack),
                                                );
                                              }
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                5, 5, 5, 5),
                                            child: imageRetriever(
                                                documentId: ranking[index]),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 120,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: firstNameRetriever(
                                                documentId: ranking[index]),
                                          ),
                                        ),
                                        Spacer(),
                                        SizedBox(
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 8, 0, 8),
                                            child: pointsRetriever(
                                                documentId: ranking[index]),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 35,
                                          ),
                                        ),
                                      ]),
                                ),
                              ),
                            );
                          },
                        );
                      }),
                ),
              )
            ]));
  }
}
