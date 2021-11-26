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

  @override
  Widget build(BuildContext context) {
    ReadJsonData();
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
                    subtitle: Text(items[index]["check-in"]),
                  ),
                );
              },
            )
        )
    );
  }


  Future<void> ReadJsonData() async {
    //read json file
    final jsondata = await rootBundle.loadString(
        'assets/files/AllContacts.json');
    //decode json data as list
    final data = await json.decode(jsondata);

    setState(() {
      items=data;
      items.sort((a,b) {
        var adate = a['check-in'] ;
        var bdate = b['check-in'];
        return -adate.compareTo(bdate);
      });
    });

  }
}





// class contact{
//   var user;
//   var phone;
//   var checkIn;
//
//   contact(String Name,String Tel,String Date){
//     user=Name;
//     phone=Tel;
//     checkIn=Date;
//   }
//
//   getUser(){
//     return user;
//   }
//   getPhone(){
//     return phone;
//   }
//   getCheckIn(){
//     return checkIn;
//   }
//
//   //method that assign values to respective datatype vairables
//   contact.fromJson(Map<String,dynamic> json)
//   {
//     user = json['user'];
//     phone =json['phone'];
//     checkIn = json['check-in'];
//   }
//
// }

