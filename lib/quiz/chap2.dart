import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_app/services/stream_builder.dart';
import '../utils/constants.dart';
import 'question.dart';
import '../utils/widgets.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

AudioPlayer player = AudioPlayer();
AudioPlayer answer = AudioPlayer();
void playBGM() async {
  player.play(AssetSource('audios/bgm.mp3'));
}

void stopBGM() async {
  player.stop();
}

Future<void> wrongAns() async {
  await answer.play(AssetSource('audios/wrong.mp3'));
}

Future<void> correctAns() async {
  await answer.play(AssetSource('audios/correct.mp3'));
}

class chap2Quiz extends StatefulWidget {
  const chap2Quiz({super.key});
  @override
  _chap2QuizState createState() => _chap2QuizState();
}

class _chap2QuizState extends State<chap2Quiz> {
  final List<question> _questions = [
    question(
        id: '41',
        title:
            'These are the bundle of widgets that are absolutely necessary for the development of any Flutter application.',
        options: {
          'Basics': true,
          'Input': false,
          'Async': false,
          'Layout': false
        }),
    question(
        id: '42',
        title:
            'These are sets of widgets that make a Flutter application to be more easily accessible.',
        options: {
          'Async': false,
          'Material Components': false,
          'Scrolling': false,
          'Accessibility': true
        }),
    question(
        id: '43',
        title:
            'This deals with the theme, responsiveness, and sizing of the app.',
        options: {
          'Text': false,
          'Scrolling': false,
          'Styling': true,
          'Animation and Motion': false
        }),
    question(
        id: '44',
        title:
            'A type of widget that can change its state, meaning, it is able to maintain and update the appearance in the response to change state.',
        options: {
          'Stateless Widget': false,
          'Line Widget': false,
          'Stateful Widget': true,
          'Combined Widget': false
        }),
    question(
        id: '45',
        title: 'To create a bar at the top of the screen.',
        options: {
          'Scaffold': false,
          'App-Bar': true,
          'Container': false,
          'Center': false
        }),
    question(
        id: '46',
        title: 'To provide center alignment to other widgets.',
        options: {
          'Center': true,
          'Text': false,
          'Container': false,
          'Scaffold': false
        }),
    question(
        id: '47',
        title:
            'Can be given, of different shapes, for example, rounded rectangle, etc.',
        options: {
          'Margin': false,
          'Padding': false,
          'Child': false,
          'Border': true
        }),
    question(
        id: '48',
        title: 'The widget that will be placed inside the container.',
        options: {
          'Child': true,
          'Padding': false,
          'Margin': false,
          'Border': false
        }),
    question(
        id: '49',
        title:
            'It is used to give space from the border of the container from its children.',
        options: {
          'Color': false,
          'Padding': true,
          'Child': false,
          'Margin': false
        }),
    question(
        id: '50',
        title:
            'When we want to give additional constraints to the child, we can use this property.',
        options: {
          'Alignment': false,
          'Constraints': true,
          'Decoration': false,
          'Transform': false
        }),
    question(
        id: '51',
        title: 'Displays the main or primary content in the Scaffold.',
        options: {
          'Body': true,
          'App-Bar': false,
          'Transform': false,
          'Drawer': false
        }),
    question(
        id: '52',
        title:
            'A slider menu or panel that is displayed on the Scaffold\'s side.',
        options: {
          'App-Bar': false,
          'Drawer': true,
          'Navigation Bar': false,
          'List View': false
        }),
    question(
        id: '53',
        title: 'A predefined class of widget in a Flutter app.',
        options: {
          'MaterialApp': true,
          'App-Bar': false,
          'List View': false,
          'Scaffold': false
        }),
    question(
        id: '54',
        title: 'Controls the primary color used in the application.',
        options: {
          'Dark Theme': false,
          'Home': false,
          'Locale': false,
          'Color': true
        }),
    question(
        id: '55',
        title:
            'It takes in RouteFactory typedef as the object to generate a title string for the application if provided.',
        options: {
          'onUnknownRoute': false,
          'onGenerateRoute': false,
          'onGenerateTitle': true,
          'onGenerateInitialRoutes': false
        }),
    question(
        id: '56',
        title:
            'This property was used in providing a short description of the application to the user.',
        options: {
          'Theme': false,
          'Title': true,
          'Home': false,
          'Drawer': false
        }),
    question(
        id: '57',
        title: 'Used to determine which theme to be used.',
        options: {
          'darkTheme': false,
          'Routes': false,
          'ThemeMode': true,
          'Color': false
        }),
    question(
        id: '58',
        title:
            'Blocks the user interaction with the rest of the screen, allowing the user to interact with the drawer only.',
        options: {
          'Modal Navigation Drawer': true,
          'Bottom Navigation Drawer': false,
          'Standard Navigation Drawer': false,
          'Drawer Widget': false
        }),
    question(
        id: '59',
        title:
            'It takes in a list of widgets as a parameter to be displayed after the title if the AppBar is a row.',
        options: {
          'Title': false,
          'Actions': true,
          'Shape': false,
          'Elevation': false
        }),
    question(
        id: '60',
        title:
            'Used to define the z-coordinates to which the AppBar will be placed, with respect to its parent.',
        options: {
          'Shape': false,
          'centerTile': false,
          'Title': false,
          'Elevation': true
        }),
  ];

  int index = 0;
  int score = 0;
  bool isPressed = false;
  bool isAlreadySelected = false;
  String resultGreeting = '';
  String resultMessage = '';

  final user = FirebaseAuth.instance.currentUser!;
  int? totalPoints;

  void nextQuestion() {
    if (index == _questions.length - 1) {
      stopBGM();
      int total = _questions.length;
      if (score >= 17) {
        resultGreeting = 'Excellent!';
        resultMessage = 'Excellent work.\nYou\'re an outstanding learner!';
      } else if (score >= 10) {
        resultGreeting = 'Good job!';
        resultMessage = 'Good job.\nLearn more by taking another quiz.';
      } else if (score < 10) {
        resultGreeting = 'Keep trying!';
        resultMessage = 'Keep trying!\nYou can do better.';
      }
      FirebaseFirestore.instance.collection('AppUsers').doc(user.uid).update({
        'totalPoints': FieldValue.increment(score),
      });
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => resultScreen(
                score: score,
                totalQuestion: total,
                resultGreeting: resultGreeting,
                resultMessage: resultMessage,
              )));
    } else {
      if (isPressed) {
        setState(() {
          index++;
          isPressed = false;
          isAlreadySelected = false;
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: text,
              icon: const Icon(
                Icons.warning,
                color: incorrect,
                size: 50,
              ),
              title: const Text(
                'Warning',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'SF Pro'),
              ),
              content: const Text(
                'Please Select Answer',
                style: TextStyle(
                    fontSize: 15, color: Colors.black, fontFamily: 'SF Pro'),
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
                      child: const Text(
                        'Confirm',
                        style: TextStyle(color: text, fontFamily: 'SF Pro'),
                      ),
                      style: TextButton.styleFrom(backgroundColor: correct),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }
    }
  }

  void checkAnswerAndUpdate(bool value) {
    if (isAlreadySelected) {
      return;
    } else {
      if (value == true) {
        correctAns();
        score++;
        setState(() {
          isPressed = true;
          isAlreadySelected = true;
        });
      } else {
        wrongAns();
        setState(() {
          isPressed = true;
          isAlreadySelected = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog<String>(
          context: context,
          builder: (BuildContext context) => const chap2Countdown());
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          title: const Text(
            'Chapter 2',
            style: TextStyle(
                color: text, fontWeight: FontWeight.bold, fontFamily: 'SF Pro'),
          ),
          backgroundColor: appBar,
          shadowColor: Colors.transparent,
          toolbarHeight: 80,
          actions: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text(
                'Score: $score',
                style: const TextStyle(
                    fontSize: 18.0, color: text, fontFamily: 'SF Pro'),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            height: mediaQuery.size.height,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                questionWidget(
                  indexAction: index,
                  question: _questions[index].title,
                  totalQuestion: _questions.length,
                ),
                const Divider(
                  color: text,
                ),
                const SizedBox(height: 25.0),
                for (int i = 0; i < _questions[index].options.length; i++)
                  GestureDetector(
                    onTap: () => checkAnswerAndUpdate(
                        _questions[index].options.values.toList()[i]),
                    child: optionCard(
                      option: _questions[index].options.keys.toList()[i],
                      color: isPressed
                          ? _questions[index].options.values.toList()[i] == true
                              ? correct
                              : incorrect
                          : neutral,
                    ),
                  ),
              ],
            ),
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: nextButton(
            nextQuestion: nextQuestion,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}

class chap2Prelim extends StatelessWidget {
  const chap2Prelim({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: text,
        scrolledUnderElevation: 0.0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const streamBuilder())),
        ),
      ),
      backgroundColor: text,
      body: SingleChildScrollView(
        child: Container(
          height: mediaQuery.size.height,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
              child: SizedBox(
                child: Text(
                  'Chapter 2 Quiz',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SF Pro',
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
              child: SizedBox(
                child: Text(
                  'Key Widgets',
                  style: TextStyle(
                      fontSize: 15.0,
                      fontFamily: 'SF Pro',
                      color: Colors.black54),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 20),
              child: Row(children: [
                SizedBox(
                    height: 50,
                    width: 50,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(width: 3, color: appBar)),
                      child: const Icon(
                        Icons.list,
                        color: appBar,
                        size: 30,
                      ),
                    )),
                const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: SizedBox(
                            child: Text(
                          '20',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.bold,
                              color: appBar),
                        )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: SizedBox(
                            child: Text(
                          'Multiple Choice Questions',
                          style: TextStyle(
                              fontSize: 15.0,
                              fontFamily: 'SF Pro',
                              color: Colors.black54),
                        )),
                      ),
                    ])
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 20),
              child: Row(children: [
                SizedBox(
                    height: 50,
                    width: 50,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(width: 3, color: appBar)),
                      child: const Icon(
                        Icons.star,
                        color: appBar,
                        size: 30,
                      ),
                    )),
                const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: SizedBox(
                            child: Text(
                          '10',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.bold,
                              color: appBar),
                        )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: SizedBox(
                            child: Text(
                          'Passing Score',
                          style: TextStyle(
                              fontSize: 15.0,
                              fontFamily: 'SF Pro',
                              color: Colors.black54),
                        )),
                      ),
                    ])
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 20),
              child: Row(children: [
                SizedBox(
                    height: 50,
                    width: 50,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(width: 3, color: appBar)),
                      child: const Icon(
                        Icons.bar_chart,
                        color: appBar,
                        size: 30,
                      ),
                    )),
                const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: SizedBox(
                            child: Text(
                          'Medium',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.bold,
                              color: appBar),
                        )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: SizedBox(
                            child: Text(
                          'Level of Difficulty',
                          style: TextStyle(
                              fontSize: 15.0,
                              fontFamily: 'SF Pro',
                              color: Colors.black54),
                        )),
                      ),
                    ])
              ]),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Divider(
                color: Color.fromARGB(61, 168, 168, 168),
                thickness: 3.0,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20, left: 20),
              child: SizedBox(
                child: Text(
                  'Before you start',
                  style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'SF Pro',
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10, left: 20),
              child: SizedBox(
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.only(right: 0),
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      leading: Icon(
                        Icons.circle,
                        size: 10,
                      ),
                      minLeadingWidth: 5,
                      title: Text(
                        'You must complete the quiz once started.',
                        style: TextStyle(
                          fontFamily: 'SF Pro',
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.only(right: 0),
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      leading: Icon(
                        Icons.circle,
                        size: 10,
                      ),
                      minLeadingWidth: 5,
                      title: Text(
                        'Every correct answer is equivalent to one point.',
                        style: TextStyle(
                          fontFamily: 'SF Pro',
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.only(right: 0),
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      leading: Icon(
                        Icons.circle,
                        size: 10,
                      ),
                      minLeadingWidth: 5,
                      title: Text(
                        'You must select an answer before proceeding to the next question.',
                        style: TextStyle(
                          fontFamily: 'SF Pro',
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.only(right: 0),
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      leading: Icon(
                        Icons.circle,
                        size: 10,
                      ),
                      minLeadingWidth: 5,
                      title: Text(
                        'The topics included in this quiz are: Flutter Widgets, Scaffold, Container, MaterialApp, Drawer and their properties.',
                        style: TextStyle(
                          fontFamily: 'SF Pro',
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.only(right: 0, bottom: 20),
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      leading: Icon(
                        Icons.circle,
                        size: 10,
                      ),
                      minLeadingWidth: 5,
                      title: Text(
                        'The quiz is always available for retaking.',
                        style: TextStyle(
                          fontFamily: 'SF Pro',
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => chap2Quiz()));
              },
              child: const Center(
                  child: SizedBox(
                height: 60,
                width: double.infinity,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: appBar,
                  ),
                  child: Center(
                      child: Text(
                    'Start Quiz',
                    style: TextStyle(
                        fontFamily: 'SF Pro',
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  )),
                ),
              )),
            )
          ]),
        ),
      ),
    );
  }
}

class chap2Countdown extends StatefulWidget {
  const chap2Countdown({Key? key}) : super(key: key);

  @override
  _chap2CountdownState createState() => _chap2CountdownState();
}

class _chap2CountdownState extends State<chap2Countdown> {
  int timeLeft = 5;
  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        timer.cancel();
        Navigator.of(context, rootNavigator: true).pop();
        playBGM();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Colors.transparent,
        content: SizedBox(
          height: 200,
          width: 200,
          child: Center(
            child: Text(
              timeLeft == 0 ? 'Go!' : timeLeft.toString(),
              style: const TextStyle(
                  fontSize: 100,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.bold,
                  color: text),
            ),
          ),
        ));
  }
}
