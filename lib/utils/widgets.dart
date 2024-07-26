import 'package:flutter/material.dart';
import 'package:quiz_app/services/stream_builder.dart';
import 'package:quiz_app/utils/constants.dart';

class questionWidget extends StatelessWidget {
  const questionWidget(
      {Key? key,
      required this.question,
      required this.indexAction,
      required this.totalQuestion})
      : super(key: key);

  final String question;
  final int indexAction;
  final int totalQuestion;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(10.0),
            child: Text(
              '${indexAction + 1}/$totalQuestion',
              style: const TextStyle(
                  fontSize: 24.0,
                  color: text,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SF Pro'),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '$question',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 22.0, color: text, fontFamily: 'SF Pro'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class nextButton extends StatelessWidget {
  const nextButton({Key? key, required this.nextQuestion}) : super(key: key);
  final VoidCallback nextQuestion;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: nextQuestion,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: appBar, borderRadius: BorderRadius.circular(10.0)),
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: const Text(
          'Next',
          textAlign: TextAlign.center,
          style: TextStyle(color: text, fontFamily: 'SF Pro'),
        ),
      ),
    );
  }
}

class optionCard extends StatelessWidget {
  const optionCard({Key? key, required this.option, required this.color})
      : super(key: key);

  final String option;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: ListTile(
        title: Text(
          option,
          style: const TextStyle(
              fontSize: 22.0, color: text, fontFamily: 'SF Pro'),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class resultScreen extends StatelessWidget {
  const resultScreen(
      {Key? key,
      required this.score,
      required this.totalQuestion,
      required this.resultGreeting,
      required this.resultMessage})
      : super(key: key);
  final int score;
  final int totalQuestion;
  final String resultGreeting;
  final String resultMessage;


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/result.png'),
              fit: BoxFit.cover,
            ),
            color: background,
          ),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                child: Image.asset(
                  'assets/images/trophy.png',
                ),
              ),
              const SizedBox(height: 20),
              Text(
                resultGreeting,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    fontFamily: 'SF Pro'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Your Score',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 20,
                    fontFamily: 'SF Pro'),
              ),
              const SizedBox(height: 20),
              Text(
                '$score / $totalQuestion',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    fontFamily: 'SF Pro'),
              ),
              const SizedBox(height: 20),
              Text(
                '$resultMessage',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    fontFamily: 'SF Pro'),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const streamBuilder()));
                  },
                  style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll<Color>(appBar)),
                  child: const Text(
                    ' Back To Home ',
                    style: TextStyle(
                        color: text, fontSize: 25, fontFamily: 'SF Pro'),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class circularLoader extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: appBar,
      ),
    );
  }
}