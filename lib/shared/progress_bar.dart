import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/services/models.dart';

class ProgressBar extends StatelessWidget {
  final double value;
  final double height;

  const ProgressBar({
    Key? key,
    required this.value,
    this.height = 12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints box) {
        return Container(
          padding: const EdgeInsets.all(10),
          width: box.maxWidth,
          child: Stack(
            children: <Widget>[
              Container(
                height: height,
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(height)),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOutCubic,
                height: height,
                width: box.maxWidth * _floor(value),
                decoration: BoxDecoration(
                  color: _colorGen(value),
                  borderRadius: BorderRadius.all(
                    Radius.circular(height),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class TopicProgress extends StatelessWidget {
  final Topic topic;
  const TopicProgress({Key? key, required this.topic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var report = Provider.of<Report>(context);
    return Row(
      children: <Widget>[
        _progressCount(report, topic),
        Expanded(
          child: ProgressBar(
            value: _calculateProgress(report, topic),
            height: 8,
          ),
        ),
      ],
    );
  }
}

Widget _progressCount(Report report, Topic topic) {
  return Padding(
    padding: const EdgeInsets.only(left: 8),
    child: Text(
      '${report.topics[topic.id]?.length ?? 0} / ${topic.quizzes.length}',
      style: const TextStyle(fontSize: 10, color: Colors.grey),
    ),
  );
}

/// Always round negative or NaNs to min value
_floor(double value, [min = 0.0]) {
  return value.sign <= min ? min : value;
}

_colorGen(double value) {
  int rgb = (value * 255).toInt();
  return Colors.deepOrange.withGreen(rgb).withRed(255 - rgb);
}

double _calculateProgress(Report report, Topic topic) {
  try {
    int totalQuizzes = topic.quizzes.length;
    int completedQuizzes = report.topics[topic.id].length;
    return completedQuizzes / totalQuizzes;
  } catch (e) {
    return 0.0;
  }
}
