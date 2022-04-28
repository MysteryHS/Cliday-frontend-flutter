import 'package:flutter/material.dart';

import 'register_form.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const FormRegister(),
    );
  }
}
