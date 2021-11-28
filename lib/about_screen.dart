import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
          body: Container(
            alignment: Alignment.topCenter,
            child:Card(shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), elevation: 10,
                margin: const EdgeInsets.all(10),
                child:Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text("Developed by : Brandon Jedd Arius Jipiu\n"),
                        Text("\nDescription:\nVimigo's candidate technical assessment to asses the candidate's skill"),
                        Text("\nPlugins used:\n1. cupertino_icons\n2.flutter_svg \n3.flutter_staggered_grid_view"
                            " \n4.flutter_staggered_animations \n5.intl \n6.fluttertoast \n7.shared_preferences \n8.username_gen"
                            " \n9.path_provider \n10.share ")




                      ]),
                )
            )
          )
        )
    );
  }
}
