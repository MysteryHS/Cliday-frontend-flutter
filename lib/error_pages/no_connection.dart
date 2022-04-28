import 'package:app/main.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants.dart' as constants;

class NoConnectionPage extends StatefulWidget {
  const NoConnectionPage({Key? key}) : super(key: key);

  @override
  State<NoConnectionPage> createState() => _NoConnectionPageState();
}

class _NoConnectionPageState extends State<NoConnectionPage> {
  bool _disableButton = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const Spacer(
                flex: 4,
              ),
              SvgPicture.asset(
                'assets/storm.svg',
                height: 200,
              ),
              const Spacer(),
              const Text(
                'Oops, pas de connection !',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _disableButton
                    ? null
                    : () async {
                        setState(
                          () {
                            _disableButton = true;
                          },
                        );

                        ConnectivityResult connectivityResult =
                            await (Connectivity().checkConnectivity());
                        if (connectivityResult == ConnectivityResult.mobile ||
                            connectivityResult == ConnectivityResult.wifi) {
                          await initApp();
                        } else {
                          await Future.delayed(const Duration(seconds: 3));
                        }
                        setState(
                          () {
                            _disableButton = false;
                          },
                        );
                      },
                child: const Text(
                  'Réessayer',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: constants.thirdColor,
                  minimumSize: const Size(200, 50),
                ),
              ),
              const Spacer(
                flex: 4,
              )
            ],
          ),
        ),
      ),
    );
  }
}
