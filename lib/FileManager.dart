import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

import 'package:intl/intl.dart';
import 'package:flutter/services.dart';


class FileManager {

/*  FileManager _instance=FileManager();

  FileManager._internal() {
  _instance = this;
  }

  factory FileManager() =>  FileManager._internal();*/

  Future<File> get _jsonFile async {
    return File('assets/files/AllContacts.json');
  }

  Future<List> ReadJsonData() async {
    //read json file
    final jsondata = await rootBundle.loadString('assets/files/AllContacts.json');
    //decode json data as list
    List data = await json.decode(jsondata);
    final timeformat = DateFormat('h:mm a');
    final dateformat = DateFormat('dd/MM/yyyy');
    String clockString;
    String dateString;
    var tmpArray;
    List items = [];

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
    return items;

  }

  Future<contact> writeJsonFile(String Name, String Phone,String CheckIn) async {
    final contact user = contact(Name, Phone, CheckIn);

    File file = await _jsonFile;
    await file.writeAsString(json.encode(user));
    return user;
  }
}

class contact {
  var name;
  var phone;
  var checkIn;

  contact(String Name, String Phone,String CheckIn);

  contact.fromJson(Map<String, dynamic> json)
      : name = json['user'],
        phone = json['phone'],
        checkIn = json['check-in'];

  Map<String, dynamic> toJson() => {
    'name': name,
    'phone': phone,
    'check-in': checkIn,
  };
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