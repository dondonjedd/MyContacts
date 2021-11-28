import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'file_manager.dart';
import 'package:share/share.dart';
import 'themes.dart';


class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);
  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  late Future<List> items ;
  bool showAll=false;
  var realItemLength=0;
  late List<bool> isSelected;
  FileManager file=FileManager();
  final ScrollController _controller=ScrollController();
  final ThemeData _light = Themes().getThemeLight();
  final ThemeData _dark = Themes().getThemeDark();
  var _isDark=false;

  @override
  void initState() {
    file.initState();
    _controller.addListener(_scrollListener);

    items=file.ReadJsonData();
    bool bol=false;
    isSelected = [ bol, !bol];
    _getTimeFormatFromSharedPref();
    _getisDarkMode();

    super.initState();

  }

  /*
  get the current time format selected
   */
  _getTimeFormatFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isSelected = (prefs.getStringList('timeFormat')?.map((e) => e == 'true' ? true : false).toList() ?? [true, false]);
    });
  }

  /*
  save the current time format selected
   */
  _saveTimeFormatFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setStringList('timeFormat',isSelected.map((e) => e ? 'true' : 'false').toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        darkTheme:_dark,
        theme: _light,
        themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
        home:  Scaffold(
            appBar: AppBar(title: const Text("All Contacts",style: TextStyle(fontFamily: 'DancingScript')),
              actions: [Container(
                margin: const EdgeInsets.all(8),
                child:
                  ToggleButtons(
                    borderColor: Colors.blueGrey,
                    fillColor: Colors.white70,
                    borderWidth: 0.5,
                    selectedBorderColor: Colors.white,
                    selectedColor: Colors.blueGrey,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    children: const <Widget>[
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          '12 hour',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          'Time ago',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                    onPressed: (int index) {
                      setState(() {
                        for (int i = 0; i < isSelected.length; i++) {
                          isSelected[i] = i == index;
                        }
                        _saveTimeFormatFromSharedPref();
                      });
                    },
                    isSelected: isSelected,
                  ),
              )],
            ),
            body: RefreshIndicator(
                onRefresh: () {
                  return Future.delayed(
                    const Duration(seconds: 1), () {

                      setState(() {
                        for(int i=0;i<5;i++){
                          Map generatedUser=file.generateUser();
                          file.writeToFile(generatedUser["user"], "01"+generatedUser["phone"],generatedUser["check-in"]);
                        }
                        Fluttertoast.showToast(
                            msg: "5 contacts generated",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.black.withAlpha(130),
                            timeInSecForIosWeb: 1
                        );
                        items=file.ReadJsonData();
                      });

                    },
                  );
                },
                child: FutureBuilder(
                  future:items,
                    builder:(context, snapshot,){
                      if (snapshot.hasData) {
                        if (snapshot.data != null) {
                          realItemLength=(snapshot.data! as List).length;
                          return Scrollbar(
                              isAlwaysShown: true,
                              child:ListView.builder(
                                cacheExtent: 9999,
                                itemCount: showAll?(snapshot.data as List).length:15,
                                controller: _controller,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                      child: AnimationConfiguration.staggeredGrid(columnCount: 1,position: index, child: ScaleAnimation(
                                        child: Card(
                                          margin: const EdgeInsets.all(10),
                                          child: ListTile(
                                            leading: Text((index+1).toString()+'. '+(snapshot.data as List)[index]["user"]),
                                            title: Text((snapshot.data as List)[index]["phone"]),
                                            subtitle: isSelected[0]?Text((snapshot.data as List)[index]["date"] +'\t\t'+(snapshot.data as List)[index]["time"]) :Text((snapshot.data as List)[index]["timeAgo"]),
                                          ),
                                        ),
                                      )
                                      ),
                                    onLongPress: (){
                                      _onShare(context,snapshot.data as List,index);
                                    },
                                  );

                                },
                              )
                          );

                         }else{
                          return const Center(child: CircularProgressIndicator());}
                        }else{
                        return const Center(child: CircularProgressIndicator());}
                      }
                )
            )
        )
    );
  }

  /*
  Share date in arguments to other existing applications
   */
  _onShare(BuildContext context, List data,int index) async {
    await Share.share(data[index]["user"]+"\n"+data[index]["phone"]+"\n"+data[index]["date"]+"\n"+data[index]["time"]);
  }

  /*
  Listens to changes in the user's scroll
   */
  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent && //User has scrolled to the end of the list
        !_controller.position.outOfRange) {
      setState(() {
        if(showAll){  // if all the datas should be shown
          Fluttertoast.showToast(
              msg: "You have reached end of the list",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.black.withAlpha(130),
              timeInSecForIosWeb: 1
          );
        }else{
          Fluttertoast.showToast(
              msg: "Remaining contacts loaded",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.black.withAlpha(130),
              timeInSecForIosWeb: 1
          );
          showAll=true;
        }

      });
    }
  }

  _getisDarkMode() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _isDark = prefs.getBool('DarkMode')!;
    });

  }
}







