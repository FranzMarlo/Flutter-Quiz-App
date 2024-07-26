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

class chap3Quiz extends StatefulWidget {
  const chap3Quiz({super.key});
  @override
  _chap3QuizState createState() => _chap3QuizState();
}

class _chap3QuizState extends State<chap3Quiz> {
  final List<question> _questions = [
    question(
        id: '61',
        title:
            'It is responsible for controlling the functionality of each tab by syncing them and its contents with each other.',
        options: {
          'TabBar Widget': false,
          'TabController': true,
          'TabBarView': false,
          'DefaultTabController': false
        }),
    question(
        id: '62',
        title:
            'It comes to play while using the app in Accessibility Mode (i.e. voice-over).',
        options: {
          'Color': false,
          'Size': false,
          'textDirection': false,
          'semanticLabel': true
        }),
    question(id: '63', title: 'Used for rendering the icon.', options: {
      'Color': false,
      'Size': false,
      'textDirection': true,
      'semanticLabel': false
    }),
    question(
        id: '64',
        title:
            'A  widget that comes on the window or screen containing any critical information, or may ask for any decision from the user.',
        options: {
          'Dialog': true,
          'AlertDialog': false,
          'Action': false,
          'Content': false
        }),
    question(
        id: '65',
        title:
            'This property is recommended to be short as possible, making it understandable to the user.',
        options: {
          'Action': false,
          'Title': true,
          'Content': false,
          'Shape': false
        }),
    question(
        id: '66',
        title:
            'This property is the body of the Alert Dialog widget, defined by the content.',
        options: {
          'Shape': false,
          'Title': false,
          'Content': true,
          'Action': false
        }),
    question(
        id: '67',
        title:
            'Used for changing the current screen of the app to show the dialog popup.',
        options: {
          'AlertDialog': false,
          'Dialog': false,
          'showDialog': true,
          'Action': false
        }),
    question(
        id: '68',
        title:
            'Ensures that the dialog uses the safe area of the screen, not overlapping the screen area.',
        options: {
          'useSafeArea': true,
          'Builder': false,
          'Barriercolor': false,
          'Text': false
        }),
    question(
        id: '69',
        title: 'This is used for creating an option that pops up a dialog box.',
        options: {
          'SimpleDialog': false,
          'ShowDialog': true,
          'AlertDialog': false,
          'Dialog': false
        }),
    question(
        id: '70',
        title:
            'Displays the time needed for completing tasks, for example, download, installation, upload, file transfer, et cetera.',
        options: {
          'CircularProgressIndicator': false,
          'LinearProgressIndicator': false,
          'ProgressIndicator': true,
          'Indicator': false
        }),
    question(
        id: '71',
        title:
            'Also known as progress bar is a widget showing progress in a linear manner, or along a line, indicating that the application is currently in progress.',
        options: {
          'CircularProgressIndicator': false,
          'LinearProgressIndicator': true,
          'ProgressIndicator': false,
          'Indicator': false
        }),
    question(
        id: '72',
        title:
            'This is an indicator that does not display a specific value at any instance of time.',
        options: {
          'Determinate': false,
          'Indicator': false,
          'Indeterminate': true,
          'CircularProgressIndicator': false
        }),
    question(
        id: '73',
        title:
            'Sets the thickness of the circular line in a CircularProgressIndicator.',
        options: {
          'backgroundColor': false,
          'minHeight': false,
          'valueColor': false,
          'strokeWidth': true
        }),
    question(
        id: '74',
        title: 'A layout type used for displaying images and posts.',
        options: {
          'Hybrid Layout': false,
          'Staggered Grid View': true,
          'Combination Layout': false,
          'Process Layout': false
        }),
    question(
        id: '75',
        title: 'Tells the user about any condition requiring any recognition.',
        options: {
          'SimpleDialog': false,
          'ShowDialog': false,
          'AlertDialog': true,
          'Performance': false
        }),
    question(
        id: '76',
        title:
            'This property is used for showing the content for what action is to be performed.',
        options: {
          'Shape': false,
          'Title': false,
          'Content': false,
          'Action': true
        }),
    question(
        id: '77',
        title: 'This property is used for changing the style of the text.',
        options: {
          'backgroundColor': false,
          'TextStyle': true,
          'Shape': false,
          'Title': false
        }),
    question(
        id: '78',
        title: 'Returns the child, instead of creating a child argument.',
        options: {
          'Builder': true,
          'BarrierColor': false,
          'useSafeArea': false,
          'TextStyle': false
        }),
    question(
        id: '79',
        title:
            'This shows progress along a circle. It is a circular progress bar spinning to indicate the application is busy or on hold.',
        options: {
          'CircularProgressIndicator': true,
          'LinearProgressIndicator': false,
          'ProgressIndicator': false,
          'Indicator': false
        }),
    question(
        id: '80',
        title: 'Used to assign a constant color to the valueColor property.',
        options: {
          'valueColor': false,
          'strokeWidth': false,
          'AlwaysStoppedAnimation': true,
          'value': false
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
          builder: (BuildContext context) => const chap3Countdown());
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
            'Chapter 3',
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

class chap3Prelim extends StatelessWidget {
  const chap3Prelim({Key? key}) : super(key: key);

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
                  'Chapter 3 Quiz',
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
                  'UI Components',
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
                        'The topics included in this quiz are: TabBarView, Linear and Circular Progress Indicator, AlertDialog, and Grid View.',
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
                    MaterialPageRoute(builder: (context) => chap3Quiz()));
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

class chap3Countdown extends StatefulWidget {
  const chap3Countdown({Key? key}) : super(key: key);

  @override
  _chap3CountdownState createState() => _chap3CountdownState();
}

class _chap3CountdownState extends State<chap3Countdown> {
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
