import 'dart:async';
import 'dart:convert';

import 'package:app/store/classes/answer.dart';
import 'package:app/store/classes/questions.dart';
import 'package:vxstate/vxstate.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants.dart' as constants;

import 'classes/account.dart';
import 'classes/credentials.dart';
import 'mutations/account_mutations.dart';
import 'mutations/questions_mutations.dart';

class MyStore extends VxStore {
  final account = Account();
  final credentials = Credentials();
  final List<Question> questions = [];
  final List<Answer> answers = [];
  int currentQuestion = 0;
  List<bool> resultsQOTD = List.filled(constants.qotdNumber, false);

  final RegisterForm regForm = RegisterForm();
  final storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  bool isFetching = false;
  bool isLogingIn = false;
  bool isFetchingQotd = false;
  bool errorLogin = false;
  bool stayConnected = true;
  bool qotdDone = false;

  int getNumberCorrectAnswers() {
    return answers.where((element) => element.isCorrect).length;
  }

  void removeStorageCredentials() async {
    await storage.delete(key: constants.emailKey);
    await storage.delete(key: constants.passwordKey);
    await storage.write(key: constants.stayCoKey, value: 'false');
  }
}

class RegisterForm {
  bool emailTaken = false;
  bool usernameTaken = false;
  String username = '';
  String email = '';
  String password = '';
}

initStore() async {
  final MyStore store = VxState.store;
  FetchQotd();
  String? qotdLastDoneDateString =
      await store.storage.read(key: constants.qotdLastDoneDateKey);
  if (qotdLastDoneDateString != null) {
    store.qotdDone = constants.isToday(DateTime.parse(qotdLastDoneDateString));
    final test = await store.storage.read(key: constants.qotdResults);
    if (test != null) {
      List<dynamic> list = jsonDecode(test); //Error if List<bool>
      for (int i = 0; i < list.length; i++) {
        store.resultsQOTD[i] = list[i];
      }
    }
  }

  if (await store.storage.read(key: constants.stayCoKey) == 'true') {
    String? email = await store.storage.read(key: constants.emailKey);
    String? password = await store.storage.read(key: constants.passwordKey);
    store.credentials.setEmail(email!);
    store.credentials.setPassword(password!);
    Login(redirect: false);
  }
  await waitWhile(verifFetchingInit);
}

bool verifFetchingInit() {
  final MyStore store = VxState.store;
  return store.isLogingIn || store.isFetchingQotd;
}

Future waitWhile(bool Function() test,
    [Duration pollInterval = const Duration(milliseconds: 100)]) {
  var completer = Completer();
  check() {
    if (!test()) {
      completer.complete();
    } else {
      Timer(pollInterval, check);
    }
  }

  check();
  return completer.future;
}
