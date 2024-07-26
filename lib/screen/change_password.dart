import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/dialog.dart';

class changePassword extends StatefulWidget {
  const changePassword({super.key});

  @override
  State<changePassword> createState() => _changePasswordState();
}

class _changePasswordState extends State<changePassword> {
  final _formKey = GlobalKey<FormState>();

  String? uid;

  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  Future changePassword() async {
    var currentPassword = currentPasswordController.text;
    var newPassword = newPasswordController.text;
    var confirmPassword = confirmPasswordController.text;

    if (currentPassword.isEmpty) {
      showDialog(
          context: context, builder: (_) => const currentPasswordDialog());
      return;
    } else if (newPassword.isEmpty) {
      showDialog(context: context, builder: (_) => const newPasswordDialog());
      return;
    } else if (confirmPassword.isEmpty) {
      showDialog(
          context: context, builder: (_) => const confirmPasswordDialog());
      return;
    } else if (newPassword.length < 6) {
      showDialog(context: context, builder: (_) => const passLengthDialog());
    } else if (confirmPassword != newPassword) {
      showDialog(
          context: context, builder: (_) => const changePassMatchDialog());
      return;
    } else {
      reAuthenticate(currentPassword, newPassword);
    }
  }

  void reAuthenticate(String currentPassword, String newPassword) async {
    final user = FirebaseAuth.instance.currentUser!;
    final cred = EmailAuthProvider.credential(
        email: user.email!, password: currentPassword);
    await user.reauthenticateWithCredential(cred).then((value) {
      user.updatePassword(newPassword).then((_) {
        showDialog(
            context: context, builder: (_) => const passwordChangedDialog());
      }).catchError((error) {
        showDialog(
            context: context, builder: (_) => const incorrectPassDialog());
      });
    }).catchError((e) {
      showDialog(context: context, builder: (_) => const incorrectPassDialog());
    });
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: text,
          scrolledUnderElevation: 0.0,
          toolbarHeight: 40,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
          height: mediaQuery.size.height,
          decoration: BoxDecoration(color: text),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 170,
                  child: Image.asset('assets/images/reset-password.png'),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: const SizedBox(
                    child: Text(
                      'Change Password',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SF Pro'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: const SizedBox(
                    child: Text(
                      'Fill in the required fields below to\nchange your password',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: fadedBlack,
                          fontSize: 17,
                          fontFamily: 'SF Pro'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                  child: SizedBox(
                    child: Form(
                        key: _formKey,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Padding(
                                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                child: Text('Current Password',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'SF Pro',
                                    )),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 5, 20, 5),
                                child: SizedBox(
                                  width: 350,
                                  child: TextFormField(
                                    style: TextStyle(
                                        fontSize: 20, fontFamily: 'SF Pro'),
                                    obscureText: true,
                                    controller: currentPasswordController,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.all(15),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: const BorderSide(
                                              color: fadedWhite, width: 0)),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: BorderSide.none),
                                      fillColor: fadedWhite,
                                      filled: true,
                                      hintText: 'Current Password',
                                      hintStyle: const TextStyle(
                                        fontSize: 17,
                                        fontFamily: 'SF Pro',
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                child: Text('New Password',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'SF Pro',
                                    )),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 5, 20, 5),
                                child: SizedBox(
                                  width: 350,
                                  child: TextFormField(
                                    style: TextStyle(
                                        fontSize: 20, fontFamily: 'SF Pro'),
                                    obscureText: true,
                                    controller: newPasswordController,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.all(15),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: const BorderSide(
                                              color: fadedWhite, width: 0)),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: BorderSide.none),
                                      fillColor: fadedWhite,
                                      filled: true,
                                      hintText: 'New Password',
                                      hintStyle: const TextStyle(
                                        fontSize: 17,
                                        fontFamily: 'SF Pro',
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                child: Text('Confirm New Password',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'SF Pro',
                                    )),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 5, 5, 10),
                                child: SizedBox(
                                  width: 350,
                                  child: TextFormField(
                                    style: TextStyle(
                                        fontSize: 20, fontFamily: 'SF Pro'),
                                    obscureText: true,
                                    controller: confirmPasswordController,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.all(15),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: const BorderSide(
                                              color: fadedWhite, width: 0)),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: BorderSide.none),
                                      fillColor: fadedWhite,
                                      filled: true,
                                      hintText: 'Confirm New Password',
                                      hintStyle: const TextStyle(
                                        fontSize: 17,
                                        fontFamily: 'SF Pro',
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, bottom: 20),
                                  child: SizedBox(
                                    height: 55,
                                    width: 350,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: appBar,
                                      ),
                                      child: TextButton(
                                          onPressed: () => changePassword(),
                                          child: const Text(
                                            'Change Password',
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
                            ])),
                  ),
                ),
              ]),
        )));
  }
}
