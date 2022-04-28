import 'package:flutter/material.dart';

import 'login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: const [
            Expanded(
              child: SizedBox(
                height: 200.0,
                child: LoginForm(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
