import 'dart:convert';
import 'package:flutter/material.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Contacts"),),
      body: Center(
        child: FutureBuilder(
          future: DefaultAssetBundle.of(context).loadString("assets/files/AllContacts.json"),
          builder: (context, snapshot){
          var showData=json.decode(snapshot.data.toString());
          return ListView.builder(
            itemBuilder: (BuildContext context, int index){
              return ListTile(
                title: Text(showData[index]['user']),
                subtitle: Text(showData[index]['phone']),
              );
            },
            itemCount: showData.length,
          );
        },

        ),
      ),

    );
  }
}