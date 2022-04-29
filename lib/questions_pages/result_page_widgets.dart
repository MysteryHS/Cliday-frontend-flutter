import 'package:app/questions_pages/result_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vxstate/vxstate.dart';

import '../main.dart';
import '../store/mutations/questions_mutations.dart';
import '../store/mystore.dart';
import '../constants.dart' as constants;
import 'animation_result_page.dart';

Widget shareButton = ElevatedButton.icon(
  icon: const Icon(
    Icons.share,
    color: Colors.white,
  ),
  style: ElevatedButton.styleFrom(
    primary: constants.secondColor,
    fixedSize: const Size.fromHeight(50.0),
  ),
  onPressed: () async {
    await Share.share(
      getShareText(),
    );
  },
  label: const FittedBox(
    fit: BoxFit.fitWidth,
    child: Text(
      'PARTAGER',
      style: TextStyle(
        fontSize: 30,
        color: Colors.white,
      ),
    ),
  ),
);

Widget timerNextQuiz = FittedBox(
  fit: BoxFit.fitWidth,
  child: Column(
    children: [
      Text(
        'PROCHAIN QUIZ',
        style: TextStyle(
          color: constants.secondColor,
          fontSize: 25.0,
        ),
      ),
      CountdownTimer(
        endTime: constants.getTimeBeforeNextDay(),
        onEnd: () {
          FetchAnswers();
        },
        endWidget: Center(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pushReplacementNamed(
                  NavigationService.navigatorKey.currentContext!, '/questions');
            },
            icon: const Icon(Icons.navigate_next),
            label: const Text('MAINTENANT'),
            style: ElevatedButton.styleFrom(
              primary: constants.secondColor,
            ),
          ),
        ),
        textStyle: TextStyle(
          color: constants.secondColor,
          fontSize: 40.0,
        ),
      ),
    ],
  ),
);

List<Widget> getWidgetsResults() {
  //Return list [Spacer, ele, Spacer, ele, Spacer, ...]
  final MyStore store = VxState.store;
  double ratio = 1 / store.resultsQOTD.length;
  int i = 0;
  return [
    const Spacer(),
    ...store.resultsQOTD.expand(
      (correct) {
        i++;
        return [
          Expanded(
            flex: 5,
            child: RotationTransitionExample(
              delay: Duration(milliseconds: i * 800),
              duration: const Duration(milliseconds: 1000),
              nbOfTurns: 3,
              child: Container(
                height: MediaQuery.of(
                            NavigationService.navigatorKey.currentContext!)
                        .size
                        .width *
                    ratio,
                width: MediaQuery.of(
                            NavigationService.navigatorKey.currentContext!)
                        .size
                        .width *
                    ratio,
                decoration: BoxDecoration(
                  color: correct ? Colors.green : Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          const Spacer(),
        ];
      },
    )
  ].toList();
}

String getShareText() {
  final MyStore store = VxState.store;
  String res = "Cliday " + getResultText() + "\n";
  for (bool isCorrect in store.resultsQOTD) {
    res += isCorrect ? "🟢" : "🔴";
  }

  return res + (store.resultsQOTD.contains(false) ? "" : "✨");
}
