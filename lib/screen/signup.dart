import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/services/stream_builder.dart';
import 'package:quiz_app/utils/constants.dart';
import 'package:quiz_app/utils/dialog.dart';
import 'package:quiz_app/utils/widgets.dart';

class signUp extends StatefulWidget {
  const signUp({super.key});
  @override
  _signUpState createState() => _signUpState();
}

class _signUpState extends State<signUp> {
  final _formKey = GlobalKey<FormState>();
  var isLoading = false;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController retypePasswordController =
      TextEditingController();

  Future signUp() async {
    var firstName = firstNameController.text;
    var lastName = lastNameController.text;
    var email = emailController.text;
    var password = passwordController.text;
    var retypePassword = retypePasswordController.text;
    if (emailController.text.isEmpty ||
        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(emailController.text)) {
      showDialog(context: context, builder: (_) => const emailDialog());
      return;
    } else if (firstName.isEmpty) {
      showDialog(context: context, builder: (_) => const firstNameDialog());
      return;
    } else if (lastName.isEmpty) {
      showDialog(context: context, builder: (_) => const lastNameDialog());
      return;
    } else if (email.isEmpty) {
      showDialog(context: context, builder: (_) => const emailDialog());
      return;
    } else if (password.isEmpty) {
      showDialog(context: context, builder: (_) => const passwordDialog());
      return;
    } else if (retypePassword.isEmpty) {
      showDialog(context: context, builder: (_) => const retypePassDialog());
    } else if (password != retypePassword) {
      showDialog(context: context, builder: (_) => const passMatchDialog());
    } else {
      try {
        showDialog(context: context, builder: (context) => circularLoader());
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        final currentUser = FirebaseAuth.instance.currentUser!;
        addUserDetails(currentUser.uid, firstName, lastName, 0, email);
        Navigator.of(context, rootNavigator: true).pop();
        showDialog(context: context, builder: (_) => const signUpDialog());
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Navigator.of(context, rootNavigator: true).pop();
          showDialog(
              context: context, builder: (_) => const passLengthDialog());
        } else if (e.code == 'email-already-in-use') {
          Navigator.of(context, rootNavigator: true).pop();
          showDialog(
              context: context, builder: (_) => const emailExistDialog());
        } else if (e.code == 'invalid-email') {
          Navigator.of(context, rootNavigator: true).pop();
          showDialog(context: context, builder: (_) => const emailDialog());
        } else {
          Navigator.of(context, rootNavigator: true).pop();
          showDialog(
              context: context, builder: (_) => const serverErrorDialog());
        }
      }
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    retypePasswordController.dispose();
    super.dispose();
  }

  Future addUserDetails(String uid, String firstName, String lastName,
      int totalPoints, String email) async {
    await FirebaseFirestore.instance.collection('AppUsers').doc(uid).set({
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'totalPoints': totalPoints,
      'email': email,
      'imageLink': 'no image'
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Color.fromRGBO(83, 167, 214, 1),
            Color.fromRGBO(136, 205, 246, 1),
            Color.fromRGBO(188, 230, 255, 1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )),
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SizedBox(
                    height: 180,
                    child: Image.asset('assets/images/logo.png'),
                  ),
                ),
                Container(
                  width: mediaQuery.size.width,
                  height: (mediaQuery.size.height - 0 - mediaQuery.padding.top),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50)),
                    color: Colors.white,
                    border: Border.all(
                      color: text,
                      width: 3,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.fromLTRB(40, 25, 20, 10),
                          child: SizedBox(
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'SF Pro',
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40, 10, 20, 10),
                          child: SizedBox(
                              child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(bottom: 5),
                                        child: Text('First Name',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'SF Pro',
                                            )),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        child: TextFormField(
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.all(15),
                                            prefixIcon: const Padding(
                                              padding: EdgeInsets.only(
                                                  left: 20, right: 15),
                                              child: Icon(
                                                Icons.person,
                                                color: appBar,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: const BorderSide(
                                                    color: background,
                                                    width: 0)),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: BorderSide.none),
                                            fillColor: background,
                                            filled: true,
                                            hintText: 'First Name',
                                            hintStyle: const TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'SF Pro',
                                              color: Colors.black54,
                                            ),
                                          ),
                                          controller: firstNameController,
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(bottom: 5),
                                        child: Text('Last Name',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'SF Pro',
                                            )),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        child: TextFormField(
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.all(15),
                                            prefixIcon: const Padding(
                                              padding: EdgeInsets.only(
                                                  left: 20, right: 15),
                                              child: Icon(
                                                Icons.person,
                                                color: appBar,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: const BorderSide(
                                                    color: background,
                                                    width: 0)),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: BorderSide.none),
                                            fillColor: background,
                                            filled: true,
                                            hintText: 'Last Name',
                                            hintStyle: const TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'SF Pro',
                                              color: Colors.black54,
                                            ),
                                          ),
                                          controller: lastNameController,
                                        ),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.only(bottom: 5, top: 5),
                                        child: Text('Email',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'SF Pro',
                                            )),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        child: TextFormField(
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.all(15),
                                            prefixIcon: const Padding(
                                              padding: EdgeInsets.only(
                                                  left: 20, right: 15),
                                              child: Icon(
                                                Icons.email,
                                                color: appBar,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: const BorderSide(
                                                    color: background,
                                                    width: 0)),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: BorderSide.none),
                                            fillColor: background,
                                            filled: true,
                                            hintText: 'Email',
                                            hintStyle: const TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'SF Pro',
                                              color: Colors.black54,
                                            ),
                                          ),
                                          controller: emailController,
                                        ),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.only(bottom: 5, top: 5),
                                        child: Text('Password',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'SF Pro',
                                            )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 20,
                                        ),
                                        child: TextFormField(
                                          obscureText: true,
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.all(15),
                                            prefixIcon: const Padding(
                                              padding: EdgeInsets.only(
                                                  left: 20, right: 15),
                                              child: Icon(
                                                Icons.lock,
                                                color: appBar,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: const BorderSide(
                                                    color: background,
                                                    width: 0)),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: BorderSide.none),
                                            fillColor: background,
                                            filled: true,
                                            hintText: 'Password',
                                            hintStyle: const TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'SF Pro',
                                              color: Colors.black54,
                                            ),
                                          ),
                                          controller: passwordController,
                                        ),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.only(bottom: 5, top: 5),
                                        child: Text('Confirm Password',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'SF Pro',
                                            )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 20,
                                        ),
                                        child: TextFormField(
                                          obscureText: true,
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.all(15),
                                            prefixIcon: const Padding(
                                              padding: EdgeInsets.only(
                                                  left: 20, right: 15),
                                              child: Icon(
                                                Icons.lock_person,
                                                color: appBar,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: const BorderSide(
                                                    color: background,
                                                    width: 0)),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: BorderSide.none),
                                            fillColor: background,
                                            filled: true,
                                            hintText: 'Confirm Password',
                                            hintStyle: const TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'SF Pro',
                                              color: Colors.black54,
                                            ),
                                          ),
                                          controller: retypePasswordController,
                                        ),
                                      ),
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 20, right: 20),
                                          child: SizedBox(
                                            height: 55,
                                            width: double.infinity,
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: appBar,
                                              ),
                                              child: TextButton(
                                                  onPressed: () => signUp(),
                                                  child: const Text(
                                                    'Sign Up',
                                                    style: TextStyle(
                                                        fontFamily: 'SF Pro',
                                                        fontSize: 20.0,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 0, 20, 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(top: 10),
                                              child: Text(
                                                'Already have an account?',
                                                style: TextStyle(
                                                  fontFamily: 'SF Pro',
                                                  fontSize: 18.0,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            GestureDetector(
                                              onTap: () => Navigator.of(context)
                                                  .pushReplacement(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const streamBuilder())),
                                              child: const Padding(
                                                padding:
                                                    EdgeInsets.only(top: 10),
                                                child: Text(
                                                  'Login',
                                                  style: TextStyle(
                                                    fontFamily: 'SF Pro',
                                                    fontSize: 18.0,
                                                    color: appBar,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ))),
                        ),
                      ]),
                ),
              ]),
        ),
      ),
    );
  }
}
