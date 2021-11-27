import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:username_gen/username_gen.dart';
import 'FileManager.dart';
import 'package:share/share.dart';


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

  @override
  void initState() {
    file.initState();
    _controller.addListener(_scrollListener);

    items=file.ReadJsonData();
    bool bol=false;
    isSelected = [ bol, !bol];
    _getTimeFormatFromSharedPref();

    super.initState();

  }

  _getTimeFormatFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isSelected = (prefs.getStringList('timeFormat')?.map((e) => e == 'true' ? true : false).toList() ?? [true, false]);
    });
  }

  _saveTimeFormatFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setStringList('timeFormat',isSelected.map((e) => e ? 'true' : 'false').toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("All Contacts"),
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
                      String username = UsernameGen().generate();

                      int min = 1000000; //min and max values act as your 6 digit range
                      int max = 9999999;
                      var randomizer = Random();
                      var rNum = min + randomizer.nextInt(max - min);

                      var CurrentDateTime=DateTime.now();

                      print(username+"\n"+ "01"+rNum.toString()+"\n"+CurrentDateTime.toString());
                      file.writeToFile(username, "01"+rNum.toString(), CurrentDateTime.toString());
                    }
                    Fluttertoast.showToast(
                        msg: "5 contacts generated",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
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
                            itemCount: showAll?(snapshot.data as List).length:15,
                            controller: _controller,
                            itemBuilder: (context, index) {
                              return Card(
                                margin: const EdgeInsets.all(10),
                                child: ListTile(
                                  leading: Text((index+1).toString()+'. '+(snapshot.data as List)[index]["user"]),
                                  title: Text((snapshot.data as List)[index]["phone"]),
                                  subtitle: isSelected[0]?Text((snapshot.data as List)[index]["date"] +'\t\t'+(snapshot.data as List)[index]["time"]) :Text((snapshot.data as List)[index]["timeAgo"]),
                                ),
                              );
                            },
                          )
                      );

                     }else{
                      return new CircularProgressIndicator();}
                    }else{
                    return new CircularProgressIndicator();
                  }
                  }
            )
        )
    );
  }
  //previous json position

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        if(showAll){
          Fluttertoast.showToast(
              msg: "You have reached end of the list",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1
          );
        }else{
          Fluttertoast.showToast(
              msg: "Remaining contacts loaded",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1
          );
          showAll=true;
        }

      });
    }
/*    if ((_controller.offset <= _controller.position.minScrollExtent  )&&
        !_controller.position.outOfRange) {
      setState(() {
        for(int i=0;i<5;i++){
          String username = UsernameGen().generate();

          int min = 1000000; //min and max values act as your 6 digit range
          int max = 9999999;
          var randomizer = Random();
          var rNum = min + randomizer.nextInt(max - min);

          var CurrentDateTime=DateTime.now();

          print(username+"\n"+ "01"+rNum.toString()+"\n"+CurrentDateTime.toString());
          file.writeToFile(username, "01"+rNum.toString(), CurrentDateTime.toString());
        }
        Fluttertoast.showToast(
            msg: "5 contacts generated",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1
        );
        items=file.ReadJsonData();
      });
    }*/
  }
}







