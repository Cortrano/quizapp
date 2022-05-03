import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/quiz/quiz.dart';
import 'package:quizapp/services/models.dart';

class TopicDrawer extends StatelessWidget {
  final List<Topic> topics;
  const TopicDrawer({Key? key, required this.topics}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          Topic topic = topics[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Text(
                  topic.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
              ),
              QuizList(topic: topic),
            ],
          );
        },
        separatorBuilder: (_, __) => const Divider(),
        itemCount: topics.length,
        shrinkWrap: true,
      ),
    );
  }
}

class QuizList extends StatelessWidget {
  final Topic topic;
  const QuizList({Key? key, required this.topic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        children: topic.quizzes.map((quiz) {
      return Card(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        elevation: 4,
        margin: const EdgeInsets.all(4),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => QuizScreen(quizId: quiz.id),
            ));
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            child: ListTile(
              leading: QuizBadge(topic: topic, quizId: quiz.id),
              title: Text(
                quiz.title,
                style: Theme.of(context).textTheme.headline5,
              ),
              subtitle: Text(
                quiz.description,
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ),
          ),
        ),
      );
    }).toList());
  }
}

class QuizBadge extends StatelessWidget {
  final String quizId;
  final Topic topic;
  const QuizBadge({Key? key, required this.quizId, required this.topic})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Report report = Provider.of<Report>(context);
    List completed = report.topics[topic.id] ?? [];

    if (completed.contains(quizId)) {
      return const Icon(FontAwesomeIcons.checkDouble, color: Colors.green);
    } else {
      return const Icon(FontAwesomeIcons.solidCircle, color: Colors.grey);
    }
  }
}
