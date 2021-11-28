import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:username_gen/username_gen.dart';


class FileManager {
  TextEditingController keyInputController = new TextEditingController();
  TextEditingController valueInputController = new TextEditingController();

  late File jsonFile;
  late Directory dir;
  String fileName = "AllContacts.json";
  bool fileExists = false;
  late Future<List> fileContent;

  Future<void> initState() async {
    final directory = await getExternalStorageDirectory();
    dir = directory!;
    jsonFile = File(dir.path + "/" + fileName);
    fileExists = jsonFile.existsSync();
    if (fileExists) { fileContent = json.decode(jsonFile.readAsStringSync());
    }
  }

  Future<List> ReadJsonData() async {
    //read json file
    List data=[];
    final directory = await getExternalStorageDirectory();
    dir = directory!;
    jsonFile = File(dir.path + "/" + fileName);
    if(!(jsonFile.existsSync())){
      print("File does not exist!");

      createFile(data, dir, fileName);
      fileExists=true;
      for(int i=0;i<30;i++){
        Map generatedUser=generateUser();
        writeToFile(generatedUser["user"], "01"+generatedUser["phone"],generatedUser["check-in"]);
      }
    }
    data = await json.decode(await jsonFile.readAsString());

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

  generateUser<Map>(){
    String username = UsernameGen.generateWith(seperator: ' ');
    username=(username.split(" "))[0];

    int min = 10000000; //min and max values act as your 8 digit range
    int max = 99999999;
    var randomizer = Random();
    var rNum = min + randomizer.nextInt(max - min);

    var CurrentDateTime=DateTime.now();
    return {"user":username,"phone":rNum.toString(),"check-in":CurrentDateTime.toString()};
  }

  Future<void> writeToFile(String Name, String Phone,String CheckIn) async {
    if (kDebugMode) {
      print("Writing to file!");
    }
    Map<String, dynamic> content = {'user': Name,'phone': Phone,'check-in': CheckIn};

    if (fileExists) {
      print("File exists");
      List jsonFileContent = json.decode(jsonFile.readAsStringSync());
      jsonFileContent.add(content);
      jsonFile.writeAsStringSync(json.encode(jsonFileContent));
    }
  }

  void createFile(List content , Directory dir, String fileName) {
    print("Creating file!");
    File file = File(dir.path + "/" + fileName);
    file.createSync();
    fileExists = true;
    file.writeAsStringSync(json.encode(content));
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
