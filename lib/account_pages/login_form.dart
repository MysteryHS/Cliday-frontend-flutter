import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vxstate/vxstate.dart';
import 'package:checkbox_formfield/checkbox_formfield.dart';

import '../constants.dart' as constants;
import '../store/mutations/account_mutations.dart';
import '../store/mystore.dart';
import '../store/string_ext.dart';
import 'form_widgets.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final MyStore store = VxState.store;

  bool _isObscure = true;
  bool stayConnected = false;
  @override
  Widget build(BuildContext context) {
    VxState.watch(context, on: [Login, ChangeStayConnected]);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              children: [
                const Spacer(),
                Text(
                  'Se connecter',
                  style: TextStyle(
                    fontSize: 30,
                    color: constants.secondColor,
                  ),
                ),
                const Spacer(
                  flex: 2,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: constants.thirdColor,
                    decoration: getInputDecoration(hintText: 'Email'),
                    onSaved: (String? value) {
                      store.credentials.setEmail(value!);
                    },
                    validator: (val) {
                      if (!val!.isValidEmail) {
                        return 'Veuillez rentrer un email valide';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    obscureText: _isObscure,
                    onSaved: (String? value) {
                      store.credentials.setPassword(value!);
                    },
                    validator: (val) {
                      if (!val!.isValidPassword) {
                        return 'Le mot de passe doit avoir 8 charactères avec un chiffre';
                      }
                      return null;
                    },
                    decoration: getInputDecoration(
                      hintText: 'Mot de passe',
                      errorText: store.errorLogin
                          ? 'Votre identifiant ou mot de passe est incorrect'
                          : null,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off,
                          color: constants.secondColor,
                        ),
                        onPressed: () {
                          setState(
                            () {
                              _isObscure = !_isObscure;
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
                CheckboxListTileFormField(
                  title: const Text('Rester connecté'),
                  onChanged: (newValue) => {ChangeStayConnected(newValue)},
                  activeColor: constants.thirdColor,
                  initialValue: true,
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 20,
                  ),
                  child: ElevatedButton(
                    onPressed: store.isLogingIn
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              Login(redirect: true);
                            }
                          },
                    child: const Text('SE CONNECTER'),
                    style: ElevatedButton.styleFrom(
                      primary: constants.secondColor,
                      minimumSize: const Size.fromHeight(50),
                    ),
                  ),
                ),
                const Spacer(
                  flex: 3,
                ),
                RichText(
                  text: TextSpan(
                    text: 'Pas encore enregistré ? ',
                    style: TextStyle(color: constants.secondColor),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'S\'enregistrer',
                        style: TextStyle(color: constants.thirdColor),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacementNamed(
                                context, '/register');
                          },
                      ),
                    ],
                  ),
                ),
                const Spacer(
                  flex: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
