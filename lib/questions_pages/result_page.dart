import 'package:app/questions_pages/result_page_widgets.dart';
import 'package:flutter/material.dart';
import 'package:vxstate/vxstate.dart';

import '../store/mystore.dart';
import '../constants.dart' as constants;

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    final MyStore store = VxState.store;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          const Spacer(),
          Center(
            child: Text(
              getResultText(),
              style: TextStyle(
                fontSize: 100,
                color: constants.secondColor,
              ),
            ),
          ),
          Row(
            children: getWidgetsResults(),
          ),
          const Spacer(),
          Row(
            children: [
              const Spacer(),
              Expanded(
                child: timerNextQuiz,
                flex: 4,
              ),
              const Spacer(),
              Expanded(
                child: shareButton,
                flex: 4,
              ),
              const Spacer(),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

String getResultText() {
  final MyStore store = VxState.store;
  return store.resultsQOTD.where((isCorrect) => isCorrect).length.toString() +
      '/' +
      store.resultsQOTD.length.toString();
}
