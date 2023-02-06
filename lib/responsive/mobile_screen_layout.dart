import 'package:flutter/material.dart';
import 'package:revamph/resources/auth_methods.dart';

import '../screens/login_screen.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          AuthModels().signOutUser();
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const LoginScreen()));
        },
        child: const Text('SIGN OUT'),
      ),
    );
  }
}
