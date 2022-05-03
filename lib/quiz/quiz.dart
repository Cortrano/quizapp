import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/quiz/quiz_state.dart';
import 'package:quizapp/services/firestore.dart';
import 'package:quizapp/services/models.dart';
import 'package:quizapp/shared/shared.dart';

class QuizScreen extends StatelessWidget {
  final String quizId;
  const QuizScreen({Key? key, required this.quizId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuizState(),
      child: FutureBuilder(
        future: FirestoreService().getQuiz(quizId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          var state = Provider.of<QuizState>(context);
          if (!snapshot.hasData || snapshot.hasError) {
            return const Loader();
          } else {
            var quiz = snapshot.data!;

            return Scaffold(
              appBar: AppBar(
                title: ProgressBar(value: state.progress),
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(FontAwesomeIcons.xmark),
                ),
              ),
              body: PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                controller: state.controller,
                onPageChanged: (int index) =>
                    state.progress = (index / quiz.questions.length + 1),
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return StartPage(quiz: quiz);
                  } else if (index == quiz.questions.length + 1) {
                    return CongratsPage(quiz: quiz);
                  } else {
                    return QuestionPage(question: quiz.questions[index - 1]);
                  }
                },
              ),
            );
          }
        },
      ),
    );
  }
}

class StartPage extends StatelessWidget {
  final Quiz quiz;
  const StartPage({Key? key, required this.quiz}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<QuizState>(context);
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(quiz.title, style: Theme.of(context).textTheme.headline4),
          const Divider(),
          Expanded(
            child: Text(quiz.description),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton.icon(
                  onPressed: state.nextPage,
                  label: const Text('Start Quiz!'),
                  icon: const Icon(Icons.pool)),
            ],
          ),
        ],
      ),
    );
  }
}

class CongratsPage extends StatelessWidget {
  final Quiz quiz;
  const CongratsPage({Key? key, required this.quiz}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Congrats! You completed the ${quiz.title} quiz',
            textAlign: TextAlign.center,
          ),
          const Divider(),
          Image.asset('assets/congrats.gif'),
          const Divider(),
          ElevatedButton.icon(
              style: TextButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                FirestoreService().updateUserReport(quiz);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/topics',
                  (route) => false,
                );
              },
              label: const Text('Mark Complete!'),
              icon: const Icon(FontAwesomeIcons.check)),
        ],
      ),
    );
  }
}

class QuestionPage extends StatelessWidget {
  final Question question;
  const QuestionPage({Key? key, required this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<QuizState>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: Text(question.text),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: question.options.map((opt) {
                return Container(
                  height: 90,
                  margin: const EdgeInsets.only(bottom: 10.0),
                  child: InkWell(
                    onTap: () {
                      state.selected = opt;
                      _bottomSheet(context, opt, state);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            state.selected == opt
                                ? FontAwesomeIcons.circleCheck
                                : FontAwesomeIcons.circle,
                            size: 30,
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 16.0),
                              child: Text(
                                opt.value,
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList()),
        ),
      ],
    );
  }
}

_bottomSheet(BuildContext context, Option opt, QuizState state) {
  bool correct = opt.correct;

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 250,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(correct ? 'Good Job!' : 'Wrong'),
            Text(opt.detail,
                style: const TextStyle(fontSize: 18, color: Colors.white54)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: correct ? Colors.green : Colors.red,
              ),
              child: Text(correct ? 'Onward!' : 'Try Again',
                  style: const TextStyle(
                    letterSpacing: 1.5,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
              onPressed: () {
                if (correct) {
                  state.nextPage();
                }
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}
