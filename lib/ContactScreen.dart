import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter/services.dart';
class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  List items = [];
  late ScrollController _controller;
  var itemLength=15;


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
            itemLength=30;
          });
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
          setState(() {
          });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ReadJsonData();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("All Contacts")),
        body: Center(
            child: ListView.builder(
              controller: _controller,
              itemCount: itemLength,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: Text((index+1).toString()+'. '+items[index]["user"]),
                    title: Text(items[index]["phone"]),
                    subtitle: Text(items[index]["date"] +'\n'+items[index]["time"]+'\n'+items[index]["timeAgo"]),
                  ),
                );
              },
            )
        )
    );
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