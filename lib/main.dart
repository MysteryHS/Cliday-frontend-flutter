import 'package:app/drawer/drawer.dart';
import 'package:app/account_pages/register_page.dart';
import 'package:app/error_pages/no_connection.dart';
import 'package:app/main_page/widgets_main.dart';
import 'package:app/other_pages/stats_page.dart';
import 'package:app/questions_pages/question_page.dart';
import 'package:app/questions_pages/result_page.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:vxstate/vxstate.dart';

import 'account_pages/login_page.dart';
import 'store/mutations/account_mutations.dart';
import 'store/mystore.dart';
import '../constants.dart' as constants;

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MySplashScreen());
}

initApp() async {
  await initializeDateFormatting('fr_FR', null);
  await initStore();

  Navigator.popUntil(
      NavigationService.navigatorKey.currentContext!, (route) => false);
  Navigator.pushNamed(NavigationService.navigatorKey.currentContext!, '/home');
}

verifAfterBuild() async {
  ConnectivityResult connectivityResult =
      await (Connectivity().checkConnectivity());
  if (!(connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi)) {
    await Future.delayed(const Duration(seconds: 1));

    Navigator.popUntil(
        NavigationService.navigatorKey.currentContext!, (route) => false);
    Navigator.pushNamed(
        NavigationService.navigatorKey.currentContext!, '/error');
  } else {
    initApp();
  }
}

class MySplashScreen extends StatelessWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = MyStore();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      verifAfterBuild();
    });
    return VxState(
      store: store,
      child: MaterialApp(
        navigatorKey: NavigationService.navigatorKey,
        title: 'Cliday',
        home: Scaffold(
          body: Center(
            child: SvgPicture.asset(
              'assets/logo.svg',
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            scaffoldBackgroundColor: constants.mainColor,
            primaryColor: constants.secondColor,
            appBarTheme: AppBarTheme(
              color: constants.mainColor,
              foregroundColor: constants.secondColor,
              elevation: 0,
            )),
        routes: {
          '/home': (context) => const HomePage(),
          '/questions': (context) => const QuestionPage(),
          '/results': (context) => const ResultPage(),
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/stats': (context) => const StatsPage(),
          '/error': (context) => const NoConnectionPage(),
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    VxState.watch(context, on: [Login, Logout]);

    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        actions: [
          VxBuilder<MyStore>(
            builder: (context, store, status) {
              if (!store.account.isConnected()) {
                return TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                      right: 13,
                    ),
                    child: Text(
                      'Se connecter',
                      style: TextStyle(
                        color: constants.secondColor,
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
            mutations: const {Login, Logout},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Center(
          child: Column(
            children: [
              const Spacer(
                flex: 2,
              ),
              mainText,
              const Spacer(),
              carousel,
              const Spacer(
                flex: 3,
              ),
              bottomButton,
            ],
          ),
        ),
      ),
    );
  }
}
