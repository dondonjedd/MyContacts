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
        return adate.compareTo(bdate);
      });

      for(int i=0;i<data.length;i++){
        var parsedDateTime=DateTime.parse(data[i]['check-in']);
        clockString = timeformat.format(parsedDateTime);
        dateString = dateformat.format(parsedDateTime);
        tmpArray= {
          'user': data[i]['user'],
          'phone':data[i]['phone'],
          'date':dateString,
          'time':clockString
        };
        items.add(tmpArray);
      }
    });

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ReadJsonData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("All Contacts")),
        body: Center(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: Text(items[index]["user"]),
                    title: Text(items[index]["phone"]),
                    subtitle: Text(items[index]["date"] +'\n'+items[index]["time"]),
                  ),
                );
              },
            )
        )
    );
  }
}