import 'package:flutter/material.dart';
import 'package:vxstate/vxstate.dart';

import '../store/mutations/account_mutations.dart';
import '../store/mystore.dart';
import 'drawer_widgets.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VxState.watch(context, on: [Login, Logout]);
    return SizedBox(
      width: 250,
      child: SafeArea(
        child: Drawer(
          child: Column(
            children: [
              drawerHeader,
              ...drawerElements,
              const Spacer(),
              bottomDrawerWidget,
            ],
          ),
        ),
      ),
    );
  }
}
