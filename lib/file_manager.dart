import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:username_gen/username_gen.dart';

/*
Class which manages all the app's interaction with json files
*/
class FileManager {

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

  /*
  If jsonfile exists, read data from json file.
  If not, create json file, generate 30 random contacts and then read the file
  */
  Future<List> ReadJsonData() async {
    //read json file
    List data=[];
    final directory = await getExternalStorageDirectory(); //get the path to the external directory
    dir = directory!;
    jsonFile = File(dir.path + "/" + fileName);//get the jsonfile
    if(!(jsonFile.existsSync())){ //verify if file exitst
      print("File does not exist!");

      createFile(data, dir, fileName);
      fileExists=true;
      for(int i=0;i<30;i++){
        Map generatedUser=generateUser();
        writeToFile(generatedUser["user"], "01"+generatedUser["phone"],generatedUser["check-in"]);//add a new user to the file
      }
    }
    data = await json.decode(await jsonFile.readAsString());

    final timeformat = DateFormat('h:mm a');
    final dateformat = DateFormat('dd/MM/yyyy');
    String clockString;
    String dateString;
    var tmpArray;
    List items = [];

    /*
    Sort file from according to the check in time
     */
    data.sort((a,b) {
      var adate = a['check-in'];
      var bdate = b['check-in'];
      return bdate.compareTo(adate);
    });

    //create a list of users to be fed to the List View
    for(int i=0;i<data.length;i++){
      var parsedDateTime=DateTime.parse(data[i]['check-in']);
      clockString = timeformat.format(parsedDateTime);
      dateString = dateformat.format(parsedDateTime);
      tmpArray= {
        'user': data[i]['user'],
        'phone':data[i]['phone'],
        'date':dateString,
        'time':clockString,
        'timeAgo':convertToTimeAgoFormat(parsedDateTime)
      };
      items.add(tmpArray);
    }
    return items;
  }

  /*
  Generate a random user with attribute name from a list of name, phone number and check-in time
  returns a map
   */
  generateUser<Map>(){
    //generate random name
    String username = UsernameGen.generateWith(data: UsernameGenData(adjectives: ['Chan Saw Lin','Lee Saw Loy',"Khaw Tong Lin", "Lim Kok Lin","Low Jun Wei",
      "Yong Weng Kai","Jayden Lee","Kong Kah Yan","Jasmine Lau","Chan Saw Lin"], names: ["none"]),seperator: '-');
    username=(username.split("-"))[0];

    //generate random 8 digit number
    int min = 10000000;
    int max = 99999999;
    var randomizer = Random();
    var rNum = min + randomizer.nextInt(max - min);

    //generate random date
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

  /*
  Create a new json file to the specified directory
   */
  void createFile(List content , Directory dir, String fileName) {
    print("Creating file!");
    File file = File(dir.path + "/" + fileName);
    file.createSync();
    fileExists = true;
    file.writeAsStringSync(json.encode(content));
  }

  /*
  Compare DateTime in arg to the current DateTime
  Returns the difference in time ago format
   */
  String convertToTimeAgoFormat(DateTime input){
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
