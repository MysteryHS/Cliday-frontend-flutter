import 'package:flutter/material.dart';

import '../mystore.dart';

class Question {
  String statement = '';
  List<Choice> choices = [];
  int numberOfChoices = 4;
  int indexChoosed = -1;
  int id = -1;

  Question(this.statement, this.id);

  addChoice(Choice choice) {
    if (choices.length < numberOfChoices) {
      choices.add(choice);
    }
  }

  selectChoice(int index) {
    indexChoosed = index;
  }

  isCorrect() {
    return choices[indexChoosed].isCorrect;
  }

  Map<String, String> getBody() {
    return {
      "question": id.toString(),
      "is_correct": isCorrect().toString(),
    };
  }
}

class Choice {
  bool isCorrect = false;
  String text = '';

  Choice(this.isCorrect, this.text);
}
