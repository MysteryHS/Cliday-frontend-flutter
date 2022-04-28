import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vxstate/vxstate.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';
import '../classes/answer.dart';
import '../classes/questions.dart';
import '../mystore.dart';

import '../../constants.dart' as constants;

class NextQuestion extends VxMutation<MyStore> {
  @override
  Future<void> perform() async {
    store!.resultsQOTD[store!.currentQuestion] =
        store!.questions[store!.currentQuestion].isCorrect();

    store!.currentQuestion++;

    if (store!.currentQuestion == constants.qotdNumber) {
      store!.qotdDone = true;
      await store!.storage.write(
          key: constants.qotdLastDoneDateKey,
          value: constants.getTodaysDate().toString());
      Navigator.pushReplacementNamed(
        NavigationService.navigatorKey.currentContext!,
        '/results',
      );
      await store!.storage.write(
          key: constants.qotdResults, value: store!.resultsQOTD.toString());
    }
  }
}

class FetchQotd extends VxMutation<MyStore> {
  @override
  Future<void> perform() async {
    store!.isFetchingQotd = true;

    http.Response res = await http.get(
      Uri.parse(constants.qotdURL),
      headers: constants.headers,
    );

    final List<dynamic> data = jsonDecode(utf8.decode(res.bodyBytes));
    for (var questionRaw in data) {
      Question question = Question(questionRaw['statement'], questionRaw['id']);
      for (var choiceRaw in questionRaw['answers']) {
        question
            .addChoice(Choice(choiceRaw['is_correct'], choiceRaw['response']));
      }
      store!.questions.add(question);
    }
    store!.isFetchingQotd = false;
  }
}

class FetchAnswers extends VxMutation<MyStore> {
  @override
  Future<void> perform() async {
    http.Response res = await http.get(
      Uri.parse(constants.getAnswerURL),
      headers: store!.account.getHeaders(),
    );
    final List<dynamic> data = jsonDecode(utf8.decode(res.bodyBytes));
    int j = 0;
    store!.answers.clear();
    for (var i = 0; i < data.length; i++) {
      final object = data[i];
      final answer = Answer.fromJson(object);
      store!.answers.add(answer);
      for (Question question in store!.questions) {
        if (answer.questionId == question.id &&
            constants.isToday(answer.date) &&
            j < constants.qotdNumber) {
          store!.resultsQOTD[j] = object['is_correct'];
          j++;

          store!.currentQuestion++;
        }
      }
    }
    store!.answers.sort((a1, a2) => a1.date.compareTo(a2.date));

    store!.qotdDone |= (store!.currentQuestion == constants.qotdNumber);
    store!.isLogingIn = false;
  }
}

class PostAnswer extends VxMutation<MyStore> {
  PostAnswer(this.question, this.index);
  Question question;
  int index;

  @override
  Future<void> perform() async {
    question.selectChoice(index);

    if (store!.account.isConnected()) {
      http.MultipartRequest request = http.MultipartRequest(
        'POST',
        Uri.parse(constants.anwserURL),
      );
      request.fields.addAll(question.getBody());

      request.headers.addAll(store!.account.getHeaders());

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String resp = await response.stream.bytesToString();
        Map<String, dynamic> object = jsonDecode(resp);
        final Answer answer = Answer.fromJson(object);
        store!.answers.add(answer);
      }
    }
  }
}
