import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class storeData {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final user = FirebaseAuth.instance.currentUser!;
  String? uid;

  Future<String> uploadImageToStorage(String childName, Uint8List file) async {
    Reference ref = _storage.ref().child(childName);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> saveData({required Uint8List file}) async {
    String resp = 'Some Error Occured';
    try {
      String imageUrl =
          await uploadImageToStorage('${user.uid}/imageProfile', file);
      await FirebaseFirestore.instance
          .collection('AppUsers')
          .doc(user.uid)
          .update({
        'imageLink': imageUrl,
      });
      resp = 'success';
    } catch (e) {
      resp = e.toString();
    }
    return resp;
  }
}
