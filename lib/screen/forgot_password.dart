import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quiz_app/utils/constants.dart';
import 'package:quiz_app/screen/signup.dart';
import 'package:quiz_app/utils/dialog.dart';
import 'package:quiz_app/utils/widgets.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    if (emailController.text.isEmpty ||
        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(emailController.text)) {
      showDialog(context: context, builder: (_) => const emailDialog());
      return;
    }
    try {
      showDialog(context: context, builder: (context) => circularLoader());

      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text);
       Navigator.of(context, rootNavigator: true).pop();
      showDialog(context: context, builder: (_) => const emailRecoveryDialog());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
         Navigator.of(context, rootNavigator: true).pop();
        showDialog(
            context: context, builder: (_) => const invalidEmailDialog());
      } else{
        Navigator.of(context, rootNavigator: true).pop();
        showDialog(
            context: context, builder: (_) => const serverErrorDialog());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        toolbarHeight: 40,
        backgroundColor: appBar,
        iconTheme: const IconThemeData(color: text),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(color: appBar),
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 200,
                  child: Image.asset('assets/images/logo.png'),
                ),
                Container(
                  width: mediaQuery.size.width,
                  height: (mediaQuery.size.height - 300),
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
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40, 20, 40, 0),
                          child: SizedBox(
                            child: Text(
                              'Reset Your Password',
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
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Center(
                                  child: Text(
                                      'Enter your Email and we will send you a password reset link.',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'SF Pro',
                                          color: fadedBlack)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 20, top: 10, bottom: 10),
                                child: TextFormField(
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(15),
                                    prefixIcon: const Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, right: 15),
                                      child: Icon(
                                        Icons.email,
                                        color: appBar,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(
                                            color: background, width: 0)),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
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
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 10, right: 20),
                                  child: SizedBox(
                                    height: 55,
                                    width: double.infinity,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: appBar,
                                      ),
                                      child: TextButton(
                                          onPressed: passwordReset,
                                          child: const Text(
                                            'Reset Password',
                                            style: TextStyle(
                                                fontFamily: 'SF Pro',
                                                fontSize: 20.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 10, 20, 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 30),
                                      child: Text(
                                        'Don\'t have account?',
                                        style: TextStyle(
                                          fontFamily: 'SF Pro',
                                          fontSize: 18.0,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () => Navigator.of(context)
                                          .pushReplacement(MaterialPageRoute(
                                              builder: (context) => signUp())),
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 30),
                                        child: Text(
                                          'Sign Up',
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
                          )),
                        ),
                      ]),
                ),
              ]),
        ),
      ),
    );
  }
}
