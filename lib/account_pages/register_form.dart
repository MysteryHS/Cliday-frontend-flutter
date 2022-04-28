import 'package:app/account_pages/form_widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vxstate/vxstate.dart';
import '../store/mutations/account_mutations.dart';
import '../store/mystore.dart';
import '../store/string_ext.dart';

import '../constants.dart' as constants;

class FormRegister extends StatefulWidget {
  const FormRegister({Key? key}) : super(key: key);
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormRegister> {
  final _formKey = GlobalKey<FormState>();
  final MyStore store = VxState.store;
  final TextEditingController _pass = TextEditingController();

  bool stayConnected = false;
  @override
  Widget build(BuildContext context) {
    VxState.watch(context, on: [Register]);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Text(
                          'S\'enregistrer',
                          style: TextStyle(
                            fontSize: 30,
                            color: constants.secondColor,
                          ),
                        ),
                      ),
                      const Spacer(
                        flex: 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          cursorColor: constants.thirdColor,
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (String? value) {
                            store.regForm.username = value!;
                          },
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Le nom d\'utilisateur ne peut pas être vide.';
                            }
                            return null;
                          },
                          decoration: getInputDecoration(
                            hintText: 'Nom d\'utilisateur',
                            errorText: store.regForm.usernameTaken
                                ? 'Ce nom d\'utilisateur a déjà été choisi.'
                                : null,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          cursorColor: constants.thirdColor,
                          onSaved: (String? value) {
                            store.regForm.email = value!;
                          },
                          validator: (val) {
                            if (!val!.isValidEmail) {
                              return 'Cet email n\'est pas valide';
                            }
                            return null;
                          },
                          decoration: getInputDecoration(
                            hintText: 'Email',
                            errorText: store.regForm.emailTaken
                                ? 'Cet email a déjà été choisi.'
                                : null,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          cursorColor: constants.thirdColor,
                          obscureText: true,
                          controller: _pass,
                          validator: (val) {
                            if (!val!.isValidPassword) {
                              return 'Le mot de passe doit avoir 8 charactères avec un chiffre';
                            }
                            return null;
                          },
                          decoration:
                              getInputDecoration(hintText: 'Mot de passe'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          cursorColor: constants.thirdColor,
                          obscureText: true,
                          onSaved: (String? value) {
                            store.regForm.password = value!;
                          },
                          validator: (val) {
                            if (!val!.isValidPassword || val != _pass.text) {
                              return 'Les mots de passe ne sont pas les mêmes';
                            }
                            return null;
                          },
                          decoration: getInputDecoration(
                              hintText: 'Confirmation du mot de passe'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                        ),
                        child: ElevatedButton(
                          onPressed: store.isFetching
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    Register();
                                  }
                                },
                          child: const Text('S\'ENREGISTRER'),
                          style: ElevatedButton.styleFrom(
                            primary: constants.secondColor,
                            minimumSize: const Size.fromHeight(50),
                          ),
                        ),
                      ),
                      const Spacer(
                        flex: 3,
                      ),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: 'J\'ai déjà un compte. ',
                            style: TextStyle(color: constants.secondColor),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Se connecter',
                                style: TextStyle(color: constants.thirdColor),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushReplacementNamed(
                                        context, '/login');
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(
                        flex: 3,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
