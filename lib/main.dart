import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dashboard.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // the root of application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'My Contacts',
      home:AnimatedSplashScreen(
          duration: 2000,
          splash: SvgPicture.asset('assets/images/vimigo.svg',), //load vimigo icon on splash screen
          nextScreen: const DashBoard(title: 'Main Menu'),
          splashTransition: SplashTransition.fadeTransition,
          backgroundColor: Colors.blue
      )

    );
  }
}



