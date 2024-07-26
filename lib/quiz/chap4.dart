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

class chap4Quiz extends StatefulWidget {
  const chap4Quiz({super.key});
  @override
  _chap4QuizState createState() => _chap4QuizState();
}

class _chap4QuizState extends State<chap4Quiz> {
  final List<question> _questions = [
    question(
        id: '81',
        title: 'Where do you register the fonts in a Flutter project?',
        options: {
          'main.dart': false,
          'index.html': false,
          'styles.css': false,
          'pubspec.yaml': true
        }),
    question(
        id: '82',
        title:
            'To define a custom font in Flutter, which attribute is used in the TextStyle widget to whatever you called in pubspec.yaml.?',
        options: {
          'fontFamily': true,
          ' fontType': false,
          'fontStyle': false,
          'font': false
        }),
    question(
        id: '83',
        title: 'What does the Theme widget\'s data property take as an input?',
        options: {
          'TextStyle': false,
          'String': false,
          'ThemeData': true,
          'Color': false
        }),
    question(
        id: '84',
        title:
            'What widget is used to determine the current orientation of the app in Flutter?',
        options: {
          'Container': false,
          'Scaffold': false,
          'OrientationBuilder': true,
          'Column': false
        }),
    question(
        id: '85',
        title: 'What method is used to extend the theme, app-wide in Flutter?',
        options: {
          'copyWith': true,
          'extendWith': false,
          'cloneWith': false,
          'expandWith': false
        }),
    question(
        id: '86',
        title: 'Which of the following is a property of the Text widget?',
        options: {
          'backgroundColor': false,
          ' fontWeight': true,
          'borderColor': false,
          'align': false
        }),
    question(
        id: '87',
        title:
            'To create a GridView with a different number of columns based on orientation, which widget is used?',
        options: {
          'ListView': false,
          'Column': false,
          'GridView': true,
          'Row': false
        }),
    question(
        id: '88',
        title: 'Which of these is not a property of the TextStyle class?',
        options: {
          ' fontWeight': false,
          'padding': true,
          'fontSize': false,
          'color': false
        }),
    question(
        id: '89',
        title:
            'What is the default value of the crossAxisCount property in a GridView when in landscape mode?',
        options: {'2': false, '3': false, '4': true, '5': false}),
    question(
        id: '90',
        title:
            'Which of the following is not a step in using a custom font in Flutter?',
        options: {
          'Get the font and download it': false,
          'Registering the font in main.dart': true,
          'Adding the font to the project': false,
          'Use the font in theme or widget': false
        }),
    question(
        id: '91',
        title: 'Which method is used to push a new route in Flutter?',
        options: {
          'Navigator.pop()': false,
          'Navigator.push()': true,
          'Navigator.add()': false,
          'Navigator.newRoute()': false
        }),
    question(
        id: '92',
        title:
            'What property is used to define the primary color in a Flutter theme?',
        options: {
          'textColor': false,
          'primaryColor': true,
          'buttonColor': false,
          'backgroundColor': false
        }),
    question(
        id: '93',
        title:
            'In a Flutter animation, what is used to create a smooth transition effect?',
        options: {
          'CurveTween': true,
          'ColorTween': false,
          'GridTween': false,
          'TransitionTween': false
        }),
    question(
        id: '94',
        title: 'What does the fontWeight property in TextStyle control?',
        options: {
          'Font size': false,
          'Font thickness': true,
          'Font color': false,
          'Font style': false
        }),
    question(
        id: '95',
        title:
            'Which property is used to change the brightness of the theme in Flutter?',
        options: {
          'textBrightness': false,
          'brightness': true,
          'themeBrightness': false,
          'colorBrightness': false
        }),
    question(
        id: '96',
        title: 'Which widget is not used to create a button in Flutter?',
        options: {
          'ElevatedButton': false,
          'ColorButton': true,
          'TextButton': false,
          'OutlinedButton': false
        }),
    question(
        id: '97',
        title: 'What is the purpose of the body property in Scaffold?',
        options: {
          'To set the title': false,
          'To set the background color': false,
          'To define the main content of the screen': true,
          'To add a footer': false
        }),
    question(
        id: '98',
        title: 'Which method is used to drive an animation in Flutter?',
        options: {
          'animation.drive()': true,
          'animation.run()': false,
          'animation.start()': false,
          'animation.begin()': false
        }),
    question(
        id: '99',
        title: 'What does the fontSize property in TextStyle control?',
        options: {
          'Font family': false,
          'Font color': false,
          'Font size': true,
          'Font weight': false
        }),
    question(
        id: '100',
        title:
            'Which method is used to create a transition animation between pages in Flutter?',
        options: {
          'MaterialPageRoute': false,
          'PageRouteBuilder': true,
          'CupertinoPageRoute': false,
          'Navigator.push()': false
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
          builder: (BuildContext context) => const chap4Countdown());
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
            'Chapter 4',
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

class chap4Prelim extends StatelessWidget {
  const chap4Prelim({Key? key}) : super(key: key);

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
                  'Chapter 4 Quiz',
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
                  'Design and Animation',
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
                        'The topics included in this quiz are: Fonts Customization, Themes, Buttons and UI, and Routing Animations.',
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
                    MaterialPageRoute(builder: (context) => chap4Quiz()));
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

class chap4Countdown extends StatefulWidget {
  const chap4Countdown({Key? key}) : super(key: key);

  @override
  _chap4CountdownState createState() => _chap4CountdownState();
}

class _chap4CountdownState extends State<chap4Countdown> {
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
