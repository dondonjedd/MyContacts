import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  List items = [];
  late ScrollController _controller;
  var itemToShowLength=15;
  var realItemLength=0;
  late List<bool> isSelected;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ReadJsonData();
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
        body: Center(
            child: ListView.builder(
              controller: _controller,
              itemCount: itemToShowLength,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: Text((index+1).toString()+'. '+items[index]["user"]),
                    title: Text(items[index]["phone"]),
                    subtitle: isSelected[0]?Text(items[index]["date"] +'\t\t'+items[index]["time"]) :Text(items[index]["timeAgo"]),
                  ),
                );
              },
            )
        )
    );
  }



  Future<void> ReadJsonData() async {
    //read json file
    final jsondata = await rootBundle.loadString('assets/files/AllContacts.json');
    //decode json data as list
    List data = await json.decode(jsondata);
    final timeformat = DateFormat('h:mm a');
    final dateformat = DateFormat('dd/MM/yyyy');
    String clockString;
    String dateString;
    var tmpArray;

    setState(() {
      realItemLength=data.length;

      data.sort((a,b) {
        var adate = a['check-in'];
        var bdate = b['check-in'];
        return bdate.compareTo(adate);
      });

      for(int i=0;i<data.length;i++){
        var parsedDateTime=DateTime.parse(data[i]['check-in']);
        clockString = timeformat.format(parsedDateTime);
        dateString = dateformat.format(parsedDateTime);
        tmpArray= {
          'user': data[i]['user'],
          'phone':data[i]['phone'],
          'date':dateString,
          'time':clockString,
          'timeAgo':convertToAgo(parsedDateTime)
        };
        items.add(tmpArray);
      }
    });

  }

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
          itemToShowLength=realItemLength;

        }

      });
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
      });
    }
  }


  String convertToAgo(DateTime input){
    Duration diff = DateTime.now().difference(input);

    if(diff.inDays >= 1){
      return '${diff.inDays} day(s) ago';
    } else if(diff.inHours >= 1){
      return '${diff.inHours} hour(s) ago';
    } else if(diff.inMinutes >= 1){
      return '${diff.inMinutes} minute(s) ago';
    } else if (diff.inSeconds >= 1){
      return '${diff.inSeconds} second(s) ago';
    } else {
      return 'just now';
    }
  }
}