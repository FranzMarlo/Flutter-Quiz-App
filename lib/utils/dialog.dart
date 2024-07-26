import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/screen/profile.dart';
import 'package:quiz_app/services/stream_builder.dart';
import 'constants.dart';

class emailDialog extends StatelessWidget {
  const emailDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      icon: const Icon(
        Icons.warning,
        color: incorrect,
        size: 50,
      ),
      title: const Text(
        'Please Enter Valid Email',
        style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'SF Pro'),
      ),
      actions: [
        Center(
          child: SizedBox(
            width: 100,
            height: 50,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(backgroundColor: correct),
              child: const Text(
                'Confirm',
                style: TextStyle(color: text, fontFamily: 'SF Pro'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class passwordDialog extends StatelessWidget {
  const passwordDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      icon: const Icon(
        Icons.warning,
        color: incorrect,
        size: 50,
      ),
      title: const Text(
        'Please Enter Valid Password',
        style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'SF Pro'),
      ),
      actions: [
        Center(
          child: SizedBox(
            width: 100,
            height: 50,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(backgroundColor: correct),
              child: const Text(
                'Confirm',
                style: TextStyle(color: text, fontFamily: 'SF Pro'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class passLengthDialog extends StatelessWidget {
  const passLengthDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      icon: const Icon(
        Icons.warning,
        color: incorrect,
        size: 50,
      ),
      title: const Text(
        'Password Must Be At Least 6 Characters',
        style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'SF Pro'),
      ),
      actions: [
        Center(
          child: SizedBox(
            width: 100,
            height: 50,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(backgroundColor: correct),
              child: const Text(
                'Confirm',
                style: TextStyle(color: text, fontFamily: 'SF Pro'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class logoutDialog extends StatelessWidget {
  logoutDialog({
    Key? key,
  }) : super(key: key);
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return ButtonBarTheme(
        data: const ButtonBarThemeData(alignment: MainAxisAlignment.center),
        child: AlertDialog(
          title: const Text(
            'Do you want to log out?',
            style: TextStyle(fontFamily: 'SF Pro'),
          ),
          icon: const Icon(
            Icons.warning,
            color: incorrect,
            size: 50,
          ),
          actions: [
            TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(backgroundColor: Colors.green),
              child: const Text(
                'Confirm',
                style: TextStyle(color: Colors.white, fontFamily: 'SF Pro'),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(backgroundColor: Colors.red),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white, fontFamily: 'SF Pro'),
              ),
            ),
          ],
          actionsAlignment: MainAxisAlignment.center,
        ));
  }
}

class firstNameDialog extends StatelessWidget {
  const firstNameDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      icon: const Icon(
        Icons.warning,
        color: incorrect,
        size: 50,
      ),
      title: const Text(
        'First Name Cannot Be Empty',
        style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'SF Pro'),
      ),
      actions: [
        Center(
          child: SizedBox(
            width: 100,
            height: 50,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(backgroundColor: correct),
              child: const Text(
                'Confirm',
                style: TextStyle(color: text, fontFamily: 'SF Pro'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class lastNameDialog extends StatelessWidget {
  const lastNameDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      icon: const Icon(
        Icons.warning,
        color: incorrect,
        size: 50,
      ),
      title: const Text(
        'Last Name Cannot Be Empty',
        style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'SF Pro'),
      ),
      actions: [
        Center(
          child: SizedBox(
            width: 100,
            height: 50,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(backgroundColor: correct),
              child: const Text(
                'Confirm',
                style: TextStyle(color: text, fontFamily: 'SF Pro'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class retypePassDialog extends StatelessWidget {
  const retypePassDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      icon: const Icon(
        Icons.warning,
        color: incorrect,
        size: 50,
      ),
      title: const Text(
        'Please Confirm Your Password',
        style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'SF Pro'),
      ),
      actions: [
        Center(
          child: SizedBox(
            width: 100,
            height: 50,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(backgroundColor: correct),
              child: const Text(
                'Confirm',
                style: TextStyle(color: text, fontFamily: 'SF Pro'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class passMatchDialog extends StatelessWidget {
  const passMatchDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      icon: const Icon(
        Icons.warning,
        color: incorrect,
        size: 50,
      ),
      title: const Text(
        'Passwords Don\'t Match Try Again',
        style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'SF Pro'),
      ),
      actions: [
        Center(
          child: SizedBox(
            width: 100,
            height: 50,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(backgroundColor: correct),
              child: const Text(
                'Confirm',
                style: TextStyle(color: text, fontFamily: 'SF Pro'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class signUpDialog extends StatelessWidget {
  const signUpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      icon: const Icon(
        Icons.check_circle,
        color: correct,
        size: 50,
      ),
      title: const Text(
        'Sign Up Success',
        style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'SF Pro'),
      ),
      actions: [
        Center(
          child: SizedBox(
            width: 100,
            height: 50,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => streamBuilder()));
              },
              style: TextButton.styleFrom(backgroundColor: correct),
              child: const Text(
                'Confirm',
                style: TextStyle(color: text, fontFamily: 'SF Pro'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class invalidCredentialDialog extends StatelessWidget {
  const invalidCredentialDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      icon: const Icon(
        Icons.warning,
        color: incorrect,
        size: 50,
      ),
      title: const Text(
        'Invalid Credentials\nPlease Try Again',
        style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'SF Pro'),
      ),
      actions: [
        Center(
          child: SizedBox(
            width: 100,
            height: 50,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(backgroundColor: correct),
              child: const Text(
                'Confirm',
                style: TextStyle(color: text, fontFamily: 'SF Pro'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class emailExistDialog extends StatelessWidget {
  const emailExistDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      icon: const Icon(
        Icons.warning,
        color: incorrect,
        size: 50,
      ),
      title: const Text(
        'Email Already In Use',
        style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'SF Pro'),
      ),
      actions: [
        Center(
          child: SizedBox(
            width: 100,
            height: 50,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(backgroundColor: correct),
              child: const Text(
                'Confirm',
                style: TextStyle(color: text, fontFamily: 'SF Pro'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class saveImageDialog extends StatelessWidget {
  saveImageDialog({
    Key? key,
  }) : super(key: key);
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return ButtonBarTheme(
        data: const ButtonBarThemeData(alignment: MainAxisAlignment.center),
        child: AlertDialog(
          title: const Text(
            'Save changes to profile?',
            style: TextStyle(fontFamily: 'SF Pro'),
          ),
          icon: const Icon(
            Icons.question_mark_rounded,
            color: appBar,
            size: 50,
          ),
          actions: [
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(backgroundColor: Colors.green),
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.white, fontFamily: 'SF Pro'),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(backgroundColor: Colors.red),
              child: const Text(
                'No',
                style: TextStyle(color: Colors.white, fontFamily: 'SF Pro'),
              ),
            ),
          ],
          actionsAlignment: MainAxisAlignment.center,
        ));
  }
}

class currentPasswordDialog extends StatelessWidget {
  const currentPasswordDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      icon: const Icon(
        Icons.warning,
        color: incorrect,
        size: 50,
      ),
      title: const Text(
        'Please Enter Your Current Password',
        style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'SF Pro'),
      ),
      actions: [
        Center(
          child: SizedBox(
            width: 100,
            height: 50,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(backgroundColor: correct),
              child: const Text(
                'Confirm',
                style: TextStyle(color: text, fontFamily: 'SF Pro'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class newPasswordDialog extends StatelessWidget {
  const newPasswordDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      icon: const Icon(
        Icons.warning,
        color: incorrect,
        size: 50,
      ),
      title: const Text(
        'Please Enter Your New Password',
        style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'SF Pro'),
      ),
      actions: [
        Center(
          child: SizedBox(
            width: 100,
            height: 50,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(backgroundColor: correct),
              child: const Text(
                'Confirm',
                style: TextStyle(color: text, fontFamily: 'SF Pro'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class confirmPasswordDialog extends StatelessWidget {
  const confirmPasswordDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      icon: const Icon(
        Icons.warning,
        color: incorrect,
        size: 50,
      ),
      title: const Text(
        'Please Enter Your New Password',
        style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'SF Pro'),
      ),
      actions: [
        Center(
          child: SizedBox(
            width: 100,
            height: 50,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(backgroundColor: correct),
              child: const Text(
                'Confirm',
                style: TextStyle(color: text, fontFamily: 'SF Pro'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class passwordChangedDialog extends StatelessWidget {
  const passwordChangedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      icon: const Icon(
        Icons.check_circle,
        color: correct,
        size: 50,
      ),
      title: const Text(
        'Password Updated',
        style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'SF Pro'),
      ),
      actions: [
        Center(
          child: SizedBox(
            width: 100,
            height: 50,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => userProfile()));
              },
              style: TextButton.styleFrom(backgroundColor: correct),
              child: const Text(
                'Confirm',
                style: TextStyle(color: text, fontFamily: 'SF Pro'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class changePassMatchDialog extends StatelessWidget {
  const changePassMatchDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      icon: const Icon(
        Icons.warning,
        color: incorrect,
        size: 50,
      ),
      title: const Text(
        'New Passwords Don\'t Match Try Again',
        style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'SF Pro'),
      ),
      actions: [
        Center(
          child: SizedBox(
            width: 100,
            height: 50,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(backgroundColor: correct),
              child: const Text(
                'Confirm',
                style: TextStyle(color: text, fontFamily: 'SF Pro'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class incorrectPassDialog extends StatelessWidget {
  const incorrectPassDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      icon: const Icon(
        Icons.warning,
        color: incorrect,
        size: 50,
      ),
      title: const Text(
        'Invalid Current Password\nPlease Try Again',
        style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'SF Pro'),
      ),
      actions: [
        Center(
          child: SizedBox(
            width: 100,
            height: 50,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(backgroundColor: correct),
              child: const Text(
                'Confirm',
                style: TextStyle(color: text, fontFamily: 'SF Pro'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class invalidEmailDialog extends StatelessWidget {
  const invalidEmailDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      icon: const Icon(
        Icons.warning,
        color: incorrect,
        size: 50,
      ),
      title: const Text(
        'Email Not Found In The Database',
        style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'SF Pro'),
      ),
      actions: [
        Center(
          child: SizedBox(
            width: 100,
            height: 50,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(backgroundColor: correct),
              child: const Text(
                'Confirm',
                style: TextStyle(color: text, fontFamily: 'SF Pro'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class unknownErrorDialog extends StatelessWidget {
  const unknownErrorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      icon: const Icon(
        Icons.warning,
        color: incorrect,
        size: 50,
      ),
      title: const Text(
        'System Error\nPlease Try Again Later',
        style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'SF Pro'),
      ),
      actions: [
        Center(
          child: SizedBox(
            width: 100,
            height: 50,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(backgroundColor: correct),
              child: const Text(
                'Confirm',
                style: TextStyle(color: text, fontFamily: 'SF Pro'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class emailRecoveryDialog extends StatelessWidget {
  const emailRecoveryDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      icon: const Icon(
        Icons.check_circle,
        color: correct,
        size: 50,
      ),
      title: const Text(
        'Password Reset Link Sent\nPlease Check Your Email',
        style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'SF Pro'),
      ),
      actions: [
        Center(
          child: SizedBox(
            width: 100,
            height: 50,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => streamBuilder()));
              },
              style: TextButton.styleFrom(backgroundColor: correct),
              child: const Text(
                'Confirm',
                style: TextStyle(color: text, fontFamily: 'SF Pro'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class accountDisabledDialog extends StatelessWidget {
  const accountDisabledDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      icon: const Icon(
        Icons.warning,
        color: incorrect,
        size: 50,
      ),
      title: const Text(
        'Account Disabled Due To Multiple Login Attempts',
        style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'SF Pro'),
      ),
      content: const Text(
        'Please try again later or reset your password to regain access',
        style: TextStyle(
            fontSize: 18,
            color: fadedBlack,
            fontFamily: 'SF Pro'),
            textAlign: TextAlign.center,
      ),
      actions: [
        Center(
          child: SizedBox(
            width: 100,
            height: 50,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(backgroundColor: correct),
              child: const Text(
                'Confirm',
                style: TextStyle(color: text, fontFamily: 'SF Pro'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class serverErrorDialog extends StatelessWidget {
  const serverErrorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      icon: const Icon(
        Icons.warning,
        color: incorrect,
        size: 50,
      ),
      title: const Text(
        'Server Error',
        style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'SF Pro'),
      ),
      content: const Text(
        'Please Check Your Internet Connection',
        style: TextStyle(
            fontSize: 18,
            color: fadedBlack,
            fontFamily: 'SF Pro'),
            textAlign: TextAlign.center,
      ),
      actions: [
        Center(
          child: SizedBox(
            width: 100,
            height: 50,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(backgroundColor: correct),
              child: const Text(
                'Confirm',
                style: TextStyle(color: text, fontFamily: 'SF Pro'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}