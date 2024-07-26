import 'package:flutter/material.dart';
import 'screen/loading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(myApp());
}

class myApp extends StatelessWidget {
  const myApp({super.key});

  @override

  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: loadingScreen(),
      title: "Flutter Quiz",
    );
  }
}
