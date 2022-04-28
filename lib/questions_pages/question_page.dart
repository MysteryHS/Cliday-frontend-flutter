import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:vxstate/vxstate.dart';

import '../store/mutations/questions_mutations.dart';
import '../store/mystore.dart';
import '../store/classes/questions.dart';
import '../constants.dart' as constants;

class QuestionPage extends StatefulWidget {
  const QuestionPage({
    Key? key,
  }) : super(key: key);

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  int hasPressedIndex = -1;
  Question? _question;

  @override
  Widget build(BuildContext context) {
    var choicesList = <Widget>[];

    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: VxBuilder<MyStore>(
          builder: (context, store, status) {
            _question = store.getQuestion();

            if (_question != null) {
              choicesList = <Widget>[];
              for (var i = 0; i < _question!.choices.length; i++) {
                Color col = (hasPressedIndex != -1
                    ? _question!.choices[i].isCorrect
                        ? Colors.green
                        : hasPressedIndex == i
                            ? Colors.red
                            : constants.secondColor
                    : constants.secondColor);
                choicesList.add(
                  ElevatedButton(
                    onPressed: hasPressedIndex != -1
                        ? () {}
                        : () async {
                            setState(() {
                              hasPressedIndex = i;
                            });
                            PostAnswer(_question!, i);
                            await Future.delayed(const Duration(seconds: 2));
                            setState(() {
                              hasPressedIndex = -1;
                              NextQuestion();
                            });
                          },
                    child: Text(
                      _question!.choices[i].text,
                      style: const TextStyle(
                        fontSize: 17.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: col,
                      onSurface: col,
                      minimumSize: const Size.fromHeight(100),
                    ),
                  ),
                );
              }

              //Faire fonction build choicesList
              return Column(
                children: [
                  Container(
                    child: Center(
                      child: AutoSizeText(
                        _question!.statement,
                        maxLines: 4,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          color: constants.secondColor,
                        ),
                      ),
                    ),
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    height: 150.0,
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: choicesList,
                      ),
                      margin: const EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                        bottom: 40,
                      ),
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
          mutations: const {NextQuestion},
        ),
      ),
    );
  }
}
