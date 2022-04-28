import 'package:app/main.dart';
import 'package:app/store/classes/answer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vxstate/vxstate.dart';

import '../constants.dart' as constants;
import '../store/mutations/account_mutations.dart';
import '../store/mutations/questions_mutations.dart';
import '../store/mystore.dart';

Widget drawerHeader = SizedBox(
  height: 100.0,
  child: DrawerHeader(
    padding: const EdgeInsets.symmetric(vertical: 16.0),
    child: Row(
      children: [
        const SizedBox(
          width: 13.0,
        ),
        SizedBox(
          width: 30,
          child: SvgPicture.asset('assets/logo.svg'),
        ),
        const SizedBox(
          width: 30.0,
        ),
        const Text(
          'Cliday',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  ),
);

List<Widget> drawerElements = [
  ListTile(
    leading: const Icon(Icons.show_chart),
    title: const Text('Statistiques'),
    onTap: () {
      final MyStore store = VxState.store;
      if (store.account.isConnected() && store.answers.isNotEmpty) {
        Navigator.pop(NavigationService.navigatorKey.currentContext!);
        Navigator.pushNamed(
            NavigationService.navigatorKey.currentContext!, '/stats');
      } else if (!store.account.isConnected()) {
        _showNeedConnectionDialog();
      } else if (store.answers.isEmpty) {
        _showNoAnswerDialog();
      }
    },
  ),
];

Widget bottomDrawerWidget = VxBuilder<MyStore>(
  builder: (context, store, status) {
    if (store.account.isConnected()) {
      String avatarURL =
          'https://avatars.dicebear.com/api/big-ears-neutral/${store.account.userId}.svg?r=50';
      return Row(
        children: [
          Container(
            height: 30,
            width: 30,
            margin: const EdgeInsets.only(
              left: 13,
              top: 15,
              bottom: 15,
              right: 7,
            ),
            child: SvgPicture.network(avatarURL),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  store.account.username,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: constants.secondColor,
                    fontSize: 17,
                  ),
                ),
                levelText,
              ],
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showLogoutDialog();
            },
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  },
  mutations: const {Login, Logout},
);

Widget levelText = VxBuilder<MyStore>(
  builder: (context, store, status) {
    return Text(
      getLevel(),
      textAlign: TextAlign.left,
      style: TextStyle(
        color: Colors.grey.shade600,
        fontSize: 12,
      ),
    );
  },
  mutations: const {FetchAnswers, Answer},
);

void _showLogoutDialog() {
  showDialog(
    context: NavigationService.navigatorKey.currentContext!,
    builder: (context) {
      return AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                _dismissDialog();
              },
              child: Text(
                'Annuler',
                style: TextStyle(
                  color: constants.secondColor,
                ),
              )),
          TextButton(
            onPressed: () {
              Logout();
              _dismissDialog();
            },
            child: Text(
              'Confirmer',
              style: TextStyle(
                color: constants.secondColor,
              ),
            ),
          )
        ],
      );
    },
  );
}

void _showNeedConnectionDialog() {
  showDialog(
    context: NavigationService.navigatorKey.currentContext!,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          'Erreur',
          style: TextStyle(color: Colors.red),
        ),
        content: const Text(
            'Vous avez besoin de vous connecter pour accéder à cette page'),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                _dismissDialog();
              },
              child: Text(
                'Annuler',
                style: TextStyle(
                  color: constants.secondColor,
                ),
              )),
          TextButton(
            onPressed: () {
              _dismissDialog();
              Navigator.pushNamed(context, '/login');
            },
            child: Text(
              'Me connecter',
              style: TextStyle(
                color: constants.secondColor,
              ),
            ),
          )
        ],
      );
    },
  );
}

void _showNoAnswerDialog() {
  showDialog(
    context: NavigationService.navigatorKey.currentContext!,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          'Erreur',
          style: TextStyle(color: Colors.red),
        ),
        content: const Text(
            'Il faut avoir répondu à au moins une question avant d\'accéder à cette page'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              _dismissDialog();
            },
            child: Text(
              'OK',
              style: TextStyle(
                color: constants.secondColor,
              ),
            ),
          ),
        ],
      );
    },
  );
}

_dismissDialog() {
  Navigator.pop(NavigationService.navigatorKey.currentContext!);
}

String getLevel() {
  final MyStore store = VxState.store;
  if (store.answers.isEmpty) {
    return constants.levels[0]['status'];
  }
  for (int i = (constants.levels.length - 1); i > 0; i--) {
    if (constants.levels[i]['nbOfAnswers'] <= store.answers.length &&
        constants.levels[i]['percentageCorrectAnswers'] <=
            (100 * store.getNumberCorrectAnswers() / store.answers.length)) {
      return constants.levels[i]['status'];
    }
  }
  return constants.levels[0]['status'];
}
