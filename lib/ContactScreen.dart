import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:username_gen/username_gen.dart';
import 'FileManager.dart';


class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  late Future<List> items ;
  late ScrollController _controller;
  var itemToShowLength=15;
  var realItemLength=0;
  late List<bool> isSelected;
  FileManager file=FileManager();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // file.ReadJsonData().then((value) => items=value);
    items=file.ReadJsonData();
    // realItemLength=items.length;
    bool bol=false;
    isSelected = [ bol, !bol];
    _getTimeFormatFromSharedPref();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
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
        body: Scrollbar(
            isAlwaysShown: true,
            child: FutureBuilder<List>(
              future:items,
                builder:(context, snapshot,){
                  realItemLength=(snapshot.data as List).length;
                  return ListView.builder(
                      controller: _controller,
                      itemCount: itemToShowLength,
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
                    );
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
        if(itemToShowLength==realItemLength){
          Fluttertoast.showToast(
              msg: "You have reached end of the list",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1
          );
        }else{
          Fluttertoast.showToast(
              msg: "Loading remaining contacts",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1
          );
          /*file.ReadJsonData().then((value) => items=value);*/
          itemToShowLength=realItemLength;

        }

      });
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        for(int i=0;i<5;i++){
          var username = UsernameGen.generateWith(
              data: UsernameGenData(
                names: ['new names'],
                adjectives: ['new names'],
              ),
              seperator: ' '
          );

          int min = 1000000; //min and max values act as your 6 digit range
          int max = 9999999;
          var randomizer = Random();
          var rNum = min + randomizer.nextInt(max - min);

          var CurrentDateTime=DateTime.now();

        }

      });
    }
  }
}





