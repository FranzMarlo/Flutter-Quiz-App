import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/utils/constants.dart';

class pointsRetriever extends StatelessWidget{
  pointsRetriever({required this.documentId});
  final String documentId;

  @override
  Widget build(BuildContext context) {

    CollectionReference users = FirebaseFirestore.instance.collection('AppUsers');

    return FutureBuilder<DocumentSnapshot>(future: users.doc(documentId).get(), builder: ((context, snapshot){
      if (snapshot.connectionState == ConnectionState.done) {
        Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
        return Text(' ${data['totalPoints']}', style: TextStyle(
          fontSize: 18,
          fontFamily: 'SF Pro',
          fontWeight: FontWeight.w700,
          color: fadedBlack
        ),);
      }
      return Text('loading...', style: TextStyle(
          fontSize: 18,
          fontFamily: 'SF Pro',
          fontWeight: FontWeight.w700,
          color: fadedBlack
        ),);
    }));
  }
}

class firstNameRetriever extends StatelessWidget{
  firstNameRetriever({required this.documentId});
  final String documentId;

  @override
  Widget build(BuildContext context) {

    CollectionReference users = FirebaseFirestore.instance.collection('AppUsers');

    return FutureBuilder<DocumentSnapshot>(future: users.doc(documentId).get(), builder: ((context, snapshot){
      if (snapshot.connectionState == ConnectionState.done) {
        Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
        return Text(' ${data['firstName']}', style: TextStyle(
          fontSize: 18,
          fontFamily: 'SF Pro',
          fontWeight: FontWeight.w700,
          color: Colors.black
        ),);
      }
      return Text('loading...', style: TextStyle(
          fontSize: 18,
          fontFamily: 'SF Pro',
          fontWeight: FontWeight.w700,
          color: Colors.black
        ),);
    }));
  }
}
class imageRetriever extends StatelessWidget{
  imageRetriever({required this.documentId});
  final String documentId;

  @override
  Widget build(BuildContext context) {

    CollectionReference users = FirebaseFirestore.instance.collection('AppUsers');

    return FutureBuilder<DocumentSnapshot>(future: users.doc(documentId).get(), builder: ((context, snapshot){
      if (snapshot.connectionState == ConnectionState.done) {
        Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
        if(data['imageLink'] == 'no image'){
          return CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage('https://preview.redd.it/high-resolution-remakes-of-the-old-default-youtube-avatar-v0-bgwxf7bec4ob1.png?width=640&crop=smart&auto=webp&s=99d5fec405e0c7fc05f94c1e1754f7dc29ccadbd'),
        );
        }
        return CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage('${data['imageLink']}'),
        );
      }
      return CircleAvatar(
        radius: 30,
      );
    }));
  }
}
