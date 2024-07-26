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

class chap1BQuiz extends StatefulWidget {
  const chap1BQuiz({super.key});
  @override
  _chap1BQuizState createState() => _chap1BQuizState();
}

class _chap1BQuizState extends State<chap1BQuiz> {
  final List<question> _questions = [
    question(
        id: '21',
        title:
            'It is an open-source programming language that was originally developed by Google, meant for both server and user sides.',
        options: {'Java': false, 'Python': false, 'PHP': false, 'Dart': true}),
    question(
        id: '22',
        title:
            'It is where a primary set of tasks are running, the program will still respond to other sets of tasks and at the end of the execution, a final result will be returned.',
        options: {
          'Type Safe': false,
          'Asynchronous Programming': true,
          'Browser Support': false,
          'Open Source': false
        }),
    question(
        id: '23',
        title:
            'Dart is not considered to be quite popular to individuals and few big organizations due to its open-source feature.',
        options: {
          'True': false,
          'False': true,
        }),
    question(
        id: '24',
        title:
            'If a variable is declared using the final keyword, it can only be set once, and is initialized when accessed.',
        options: {
          'True': true,
          'False': false,
        }),
    question(
        id: '25',
        title:
            'What character is used in declaring a nullable variable to its type?',
        options: {'!': false, '()': false, '{}': false, '?': true}),
    question(
        id: '26',
        title:
            'It allows the user to read data from the standard input both synchronously and asynchronously.',
        options: {
          'Stdin Class': true,
          'readLineSync()': false,
          'Input and Output': false,
          'Dart Standard Input': false
        }),
    question(
        id: '27',
        title: 'These are used in representing numeric literals.',
        options: {
          'String': false,
          'Number': true,
          'Boolean': false,
          'List': false
        }),
    question(id: '28', title: 'Represent a sequence of characters.', options: {
      'Number': false,
      'Map': false,
      'String': true,
      'Boolean': false
    }),
    question(id: '29', title: 'Represents true or false.', options: {
      'Boolean': true,
      'Number': false,
      'List': false,
      'Maps': false
    }),
    question(id: '30', title: 'An ordered group of objects.', options: {
      'Maps': false,
      'Number': false,
      'Strings': false,
      'List': true
    }),
    question(
        id: '31',
        title: 'Represents a set of values as key-value pairs.',
        options: {
          'Maps': true,
          'Number': false,
          'List': false,
          'Boolean': false
        }),
    question(
        id: '32',
        title:
            'In Dart, it provides a way to reuse methods across different class hierarchies without using multiple inheritances.',
        options: {
          'Mixins': true,
          'Dart': false,
          'Inheritance': false,
          'Abstract': false
        }),
    question(
        id: '33',
        title:
            'It is a keyword used to modify the behavior of a class through Inheritance.',
        options: {
          'Overrides': false,
          'Extends': true,
          'Uses': false,
          'Imports': false
        }),
    question(
        id: '34',
        title:
            'It allows a class to inherit properties and behaviors from another class, known as the superclass or parent class.',
        options: {
          'Encapsulation': false,
          'Polymorphism': false,
          'Interface': false,
          'Inheritance': true
        }),
    question(
        id: '35',
        title:
            'An annotation indicating that a method in a derived class is overriding a method from the base class.',
        options: {
          '@inherited': false,
          '@override': true,
          '@deprecated': false,
          '@documented': false
        }),
    question(
        id: '36',
        title:
            'A class must be declared as abstract if it contains one abstract method.',
        options: {
          'True': false,
          'False': true,
        }),
    question(
        id: '37',
        title: 'Occurs when a class is inheriting from another child class.',
        options: {
          'Single Inheritance': false,
          'Multi-Level Inheritance': true,
          'Multiple Inheritance': false,
          'Hierarchical Inheritance': false
        }),
    question(
        id: '38',
        title: 'Happens when more than one class have the same parent class.',
        options: {
          'Single Inheritance': false,
          'Multi-Level Inheritance': false,
          'Multiple Inheritance': false,
          'Hierarchical Inheritance': true
        }),
    question(
        id: '39',
        title:
            'It is the class whose properties are to be inherited by the child class.',
        options: {
          'Parent/Base/Super Class': true,
          'Children Class': false,
          'Child/Derived Class': false,
          'Sub Class': false
        }),
    question(
        id: '40',
        title: 'Represents 64-bit precise floating-point numbers.',
        options: {
          'int': false,
          'num': false,
          'double': true,
          'boolean': false
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
          builder: (BuildContext context) => const chap1BCountdown());
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
            'Chapter 1B',
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

class chap1BPrelim extends StatelessWidget {
  const chap1BPrelim({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: text,
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
                  'Chapter 1B Quiz',
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
                  'Dart Basics and Object-Oriented Programming',
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
                      contentPadding: EdgeInsets.only(right: 10),
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
                      contentPadding: EdgeInsets.only(right: 10),
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
                      contentPadding: EdgeInsets.only(right: 10),
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
                      contentPadding: EdgeInsets.only(right: 10),
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      leading: Icon(
                        Icons.circle,
                        size: 10,
                      ),
                      minLeadingWidth: 5,
                      title: Text(
                        'The topics included in this quiz are: Dart Programming, Dart Basics and Syntaxes, and OOP Principles in Dart',
                        style: TextStyle(
                          fontFamily: 'SF Pro',
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.only(right: 10, bottom: 20),
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
                    MaterialPageRoute(builder: (context) => chap1BQuiz()));
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

class chap1BCountdown extends StatefulWidget {
  const chap1BCountdown({Key? key}) : super(key: key);

  @override
  _chap1BCountdownState createState() => _chap1BCountdownState();
}

class _chap1BCountdownState extends State<chap1BCountdown> {
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
