import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vxstate/vxstate.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';
import '../mystore.dart';

import '../../constants.dart' as constants;
import 'questions_mutations.dart';

class ChangeStayConnected extends VxMutation<MyStore> {
  ChangeStayConnected(this.value);
  bool value;
  @override
  perform() {
    store!.stayConnected = value;
  }
}

class Logout extends VxMutation<MyStore> {
  @override
  Future<void> perform() async {
    store!.account.userId = -1;
    store!.answers.clear();
    store!.removeStorageCredentials();
  }
}

class Register extends VxMutation<MyStore> {
  @override
  Future<void> perform() async {
    store!.isFetching = true;
    http.Response res = await http.post(
      Uri.parse(constants.registerURL),
      headers: constants.headers,
      body: jsonEncode(
        <String, String>{
          'email': store!.regForm.email,
          'password': store!.regForm.password,
          'username': store!.regForm.username
        },
      ),
    );

    store!.isFetching = false;
    Map<String, dynamic> data = jsonDecode(res.body);

    if (res.statusCode == 201) {
      store!.regForm.usernameTaken = false;
      store!.regForm.emailTaken = false;
      store!.credentials.setEmail(store!.regForm.email);
      store!.credentials.setPassword(store!.regForm.password);
      Navigator.pushReplacementNamed(
          NavigationService.navigatorKey.currentContext!, '/login');
      SnackBar snackBar = SnackBar(
        backgroundColor: constants.thirdColor,
        content: const Text('Vous êtes bien enregistré, connectez vous !'),
      );

      ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!)
          .showSnackBar(snackBar);
    } else {
      store!.regForm.usernameTaken = data['username'] != null;
      store!.regForm.emailTaken = data['email'] != null;
    }
  }
}

class Login extends VxMutation<MyStore> {
  bool redirect;

  Login({required this.redirect});

  void fail(http.Response res) {
    store!.errorLogin = true;
  }

  @override
  Future<void> perform() async {
    store!.isLogingIn = true;

    http.Response res = await http.post(
      Uri.parse(constants.loginURL),
      headers: constants.headers,
      body: jsonEncode(
        <String, String>{
          'email': store!.credentials.email,
          'password': store!.credentials.password
        },
      ),
    );
    await store!.storage.write(
        key: constants.stayCoKey, value: store!.stayConnected.toString());
    if (res.statusCode == 200) {
      if (store!.stayConnected) {
        await store!.storage
            .write(key: constants.emailKey, value: store!.credentials.email);
        await store!.storage.write(
            key: constants.passwordKey, value: store!.credentials.password);
      } else {
        await store!.storage.delete(key: constants.emailKey);
        await store!.storage.delete(key: constants.passwordKey);
      }
      success(res);
      next(
        () {
          if (redirect) {
            Navigator.maybePop(NavigationService.navigatorKey.currentContext!);
            SnackBar snackBar = SnackBar(
              backgroundColor: constants.thirdColor,
              content: const Text('Vous êtes bien connecté !'),
            );

            ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!)
                .showSnackBar(snackBar);
          }
          return FetchAnswers();
        },
      );
    } else {
      fail(res);
    }
  }

  void success(http.Response res) {
    store!.errorLogin = false;
    Map<String, dynamic> user = jsonDecode(res.body);
    store!.account.setAccessToken(user['access']);
    store!.account.setRefreshToken(user['refresh']);
  }
}

class ApiRefreshToken extends VxMutation<MyStore> {
  @override
  Future<bool> perform() async {
    http.Response res = await http.post(
      Uri.parse(constants.refreshURL),
      headers: constants.headers,
      body: jsonEncode(
        <String, String>{
          'refresh': store!.account.refreshToken,
        },
      ),
    );
    if (res.statusCode == 200) {
      success(res);
      return true;
    } else {
      return false;
    }
  }

  void success(http.Response res) {
    Map<String, dynamic> token = jsonDecode(res.body);
    store!.account.setAccessToken(token['access']);
  }
}
