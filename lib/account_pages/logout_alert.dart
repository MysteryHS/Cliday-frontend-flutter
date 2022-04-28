import 'package:flutter/material.dart';

import '../store/mutations/account_mutations.dart';

void showLogoutDialog(context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Voulez vous vous déconnecter ?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'Cancel');
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Logout();
              Navigator.pop(context, 'OK');
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
