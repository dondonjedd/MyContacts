import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Themes.dart';

class SettingsScreen extends StatefulWidget {
  final customFunction;
  const SettingsScreen({Key? key, this.customFunction}) : super(key: key);


  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  ThemeData _light = Themes().getThemeLight();
  ThemeData _dark = Themes().getThemeDark();
  var _isDark=false;

  @override
  void initState() {
    // TODO: implement initState
    _getisDarkMode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme:_dark,
      theme: _light,
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
        home:  Scaffold(
          appBar: AppBar(
              centerTitle: true,
              title: const Text("Settings",style: TextStyle(fontFamily: 'DancingScript'))
          ),
          body: Padding(
            padding:EdgeInsets.all(8.0),
              child:Row(
                  children:[
                    Text('Dark Mode:\t\t',style: TextStyle(fontSize: 20)),
                    CupertinoSwitch(
                      value: _isDark,
                      onChanged: (v) {
                        setState(() {
                          _isDark = !_isDark;
                          _setisDarkMode(_isDark);
                          widget.customFunction(_isDark);
                        });
                      },
                    )
                  ],
              )
            )
          )
    );

  }

  _getisDarkMode() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _isDark = prefs.getBool('DarkMode')!;
    });

  }

  _setisDarkMode(bool bol) async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      prefs.setBool('DarkMode',bol);
    });
  }
}

