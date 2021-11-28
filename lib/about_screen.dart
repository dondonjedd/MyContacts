import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycontacts/themes.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {

  final ThemeData _light = Themes().getThemeLight();
  final ThemeData _dark = Themes().getThemeDark();
  var _isDark=false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        darkTheme:_dark,
        theme: _light,
        themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
        home:Scaffold(
          appBar: AppBar(title: const Text("About",style: TextStyle(fontFamily: 'DancingScript'))),
          body: Card(
            margin: const EdgeInsets.all(10),
            child:Text("test")
          )
        )
    );
  }
}
