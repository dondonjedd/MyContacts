import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'about_screen.dart';
import 'contact_screen.dart';
import 'settings.dart';
import 'themes.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key, required this.title}) : super(key: key);
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final String title;
  @override
  _DashBoardState createState() => _DashBoardState();
}



class _DashBoardState extends State<DashBoard> {
  final ThemeData _light = Themes().getThemeLight();
  final ThemeData _dark = Themes().getThemeDark();
  bool _isDark=false;

  @override
  void initState() {
    // TODO: implement initState
    _getisDarkMode();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    double height = MediaQuery.of(context).size.height;
    double barheight =AppBar().preferredSize.height;
    double padding=20;

    void parentChange(bol) {
      setState(() {
        _isDark = bol;
      });
    }

    return MaterialApp(
        darkTheme:_dark,
        theme: _light,
        themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
        home:
        Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(widget.title,style: const TextStyle(fontFamily: 'DancingScript'))
          ),
          body: Container(
            color: Colors.white60,
            padding: EdgeInsets.all(20),
            child: StaggeredGridView.countBuilder(
              primary: true,
              itemCount: 3,
              /*physics: const NeverScrollableScrollPhysics(),*/
              mainAxisSpacing: 20.0,
              crossAxisSpacing: 0,
              crossAxisCount:2,
              itemBuilder: (BuildContext context, int index) => GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => index==0? const ContactScreen() :index==1?const AboutScreen(): SettingsScreen(customFunction:parentChange),
                    ),
                  );
                },
                child: AnimationConfiguration.staggeredGrid(
                  position: index, columnCount: 2, child: ScaleAnimation(

                    duration: index==0? const Duration(milliseconds: 1000) : index==1?const Duration(milliseconds: 2000) : const Duration(milliseconds: 2500),
                    child:FadeInAnimation(
                        child: Card(shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), elevation: 10,color: _isDark? Colors.black12:index==0? Colors.blue.shade50 : index==1?Colors.orange.shade50:Colors.brown.shade50 ,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children:index==0?  <Widget>[
                                SvgPicture.asset('assets/images/contact.svg',height: 200,color: _isDark?Colors.black:Colors.blueAccent.shade200),const Text('\nMy Log Book', style: TextStyle(fontSize:38 ,fontFamily: 'DancingScript',color: Colors.black54)),
                              ]:index==1?<Widget>[
                                SvgPicture.asset('assets/images/about.svg',height: 100,color: _isDark?Colors.black:Colors.blueAccent.shade200 ),const Text('About', style: TextStyle(fontSize:30 ,fontFamily: 'DancingScript',color: Colors.black54)),
                              ]:<Widget>[
                                SvgPicture.asset('assets/images/settings.svg',height: 100,color: _isDark?Colors.black:Colors.blueAccent.shade200),const Text('Settings', style: TextStyle(fontSize:30 ,fontFamily: 'DancingScript',color: Colors.black54)),
                              ]

                            )
                        )
                    )
                )
                ),
              ),
              staggeredTileBuilder: (int index) =>
                  StaggeredTile.extent(index>0 ? 1 : 2,index>0 ? (height-barheight-padding*6)*(1/3) :(height-barheight-padding*6)*(2/3))
            ),
          ),
        )
    );
  }

  //get boolean of dark mode
  _getisDarkMode() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _isDark = prefs.getBool('DarkMode')!;
    });

  }
}





