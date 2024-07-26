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

class chap6Quiz extends StatefulWidget {
  const chap6Quiz({super.key});
  @override
  _chap6QuizState createState() => _chap6QuizState();
}

class _chap6QuizState extends State<chap6Quiz> {
  final List<question> _questions = [
    question(
        id: '121',
        title: 'In Flutter, what is a route referred to as?',
        options: {
          'Activity': false,
          'ViewController': false,
          'Widget': true,
          'Fragment': false
        }),
    question(
        id: '122',
        title: 'What widget helps navigate between routes in Flutter?',
        options: {
          'Context': false,
          'Navigator': true,
          'Route': false,
          'Scaffold': false
        }),
    question(
        id: '123',
        title: 'Method is used to return to the previous route in Flutter.',
        options: {
          'pop()': true,
          'push': false,
          'navigateBack()': false,
          'return()': false
        }),
    question(
        id: '124',
        title:
            'What class is used to define arguments that will be passed between routes?',
        options: {
          'RouteArguments': false,
          'Arguments': true,
          'RouteData': false,
          'NavigationArguments': false
        }),
    question(
        id: '125',
        title: 'Used to extract arguments in a named route?',
        options: {
          'ModalRoute.of()': true,
          'getArguments()': false,
          'extractArguments()': false,
          'RouteData.of()': false
        }),
    question(
        id: '126',
        title:
            'In which function do you typically define the home page in Flutter?',
        options: {
          'main()': true,
          'initState()': false,
          'build()': false,
          'start()': false
        }),
    question(
        id: '127',
        title: 'What does the initialRoute attribute in MaterialApp specify?',
        options: {
          'Default route': false,
          'Starting Route': true,
          'End Route': false,
          'Named Route': false
        }),
    question(
        id: '128',
        title: 'How do you initialize the HomeRoute as the home page?',
        options: {
          'Navigator.push()': false,
          'MaterialApp(home: HomeRoute())': true,
          'Navigator.pop()': false,
          'Scaffold(home: HomeRoute())': false
        }),
    question(
        id: '129',
        title: 'How is the stack discipline in Navigator maintained?',
        options: {
          'push() and pop() methods': true,
          'add() and remove() methods': false,
          'navigate() and return() methods': false,
          ' insert() and delete() methods': false
        }),
    question(
        id: '130',
        title: 'What method do you use to navigate to the second route?',
        options: {
          'Navigator.pop()': false,
          'Navigator.pushNamed(context, \'/second\')': true,
          'Navigator.navigate()': false,
          'Navigator.push(context, \'second\')': false
        }),
    question(
        id: '131',
        title:
            'It is the purpose of the arguments parameter in Navigator.pushNamed().',
        options: {
          'Define routes': false,
          'Pass data to routes': true,
          'Navigate between routes': false,
          'Build UI': false
        }),
    question(
        id: '132',
        title: 'How do you define a home route in a multi-page application?',
        options: {
          'Navigator.push()': false,
          'Scaffold(home: HomeRoute())': false,
          'MaterialApp(initialRoute: \'/\')': true,
          'Navigator.pop()': false
        }),
    question(
        id: '133',
        title: 'What is the purpose of the ModalRoute.of() method?',
        options: {
          'Extract arguments': true,
          'Navigate to routes': false,
          'Stack routes': false,
          'Build UI': false
        }),
    question(
        id: '134',
        title: 'What is the role of Navigator.pop() method?',
        options: {
          'Return to the previous route': true,
          'Navigate forward': false,
          'Extract arguments': false,
          'Define routes': false
        }),
    question(
        id: '135',
        title:
            'How is the home page typically positioned in the navigator stack?',
        options: {
          'At the bottom': true,
          'At the top': false,
          'In the middle': false,
          'Randomly': false
        }),
    question(
        id: '136',
        title: 'It is the key advantage of using named routes.',
        options: {
          'Build UI': false,
          'Easy navigation': true,
          'Style buttons': false,
          'Display text': false
        }),
    question(
        id: '137',
        title:
            'The arguments can\'t be extracted using the ModalRoute.of() method or by using the onGenerateRoute() function.',
        options: {
          'True': false,
          'False': true,
        }),
    question(
        id: '138',
        title:
            'The pushNamed() method in Navigator is used to invoke a route whose class has been predefined.',
        options: {
          'True': true,
          'False': false,
        }),
    question(
        id: '139',
        title:
            'Navigation between routes is facilitated by a widget which manages these routes in a stack-like manner. What do you call this wigdet?',
        options: {
          'Buttons': false,
          'Text': false,
          'Navigator': true,
          'AppBar': false
        }),
    question(
        id: '140',
        title:
            'It is a stateless Flutter widget designed to display information passed to it via named routes.',
        options: {
          'main': false,
          'initState': false,
          'Future<void>': false,
          'ExtractArgumentsScreen class': true
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
          builder: (BuildContext context) => const chap6Countdown());
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
            'Chapter 6',
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

class chap6Prelim extends StatelessWidget {
  const chap6Prelim({Key? key}) : super(key: key);

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
                  'Chapter 6 Quiz',
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
                  'Navigation and Routing',
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
                          'Hard',
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
                        'The topics included in this quiz are: Routing, Navigation, and Methods for Routing and Navigation through different pages.',
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
                    MaterialPageRoute(builder: (context) => chap6Quiz()));
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

class chap6Countdown extends StatefulWidget {
  const chap6Countdown({Key? key}) : super(key: key);

  @override
  _chap6CountdownState createState() => _chap6CountdownState();
}

class _chap6CountdownState extends State<chap6Countdown> {
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
