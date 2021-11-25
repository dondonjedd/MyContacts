import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}



class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    double height = MediaQuery.of(context).size.height;
    double barheight =AppBar().preferredSize.height;
    double padding=20;
    // style
    var cardTextStyle = const TextStyle(
        fontFamily: "Montserrat Regular",
        fontSize: 20,);

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: StaggeredGridView.count(
          primary: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 20.0,
          crossAxisSpacing: 20.0,
          crossAxisCount:2,
          padding:  EdgeInsets.all(padding),
          children: [
            Card(shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 10,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[SvgPicture.asset('assets/images/contact.svg',height: 100,),Text('My Contacts', style: cardTextStyle)],
              )
            ),
            Card(shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[SvgPicture.asset('assets/images/contact.svg',height: 100,),Text('My Contacts', style: cardTextStyle)],
                )
            ),
            Card(shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[SvgPicture.asset('assets/images/contact.svg',height: 100,),Text('My Contacts', style: cardTextStyle)],
                )
            )
        ],
        staggeredTiles: [
          StaggeredTile.extent(2, (height-barheight-padding*6)*(2/3)),
          StaggeredTile.extent(1, (height-barheight-padding*6)*(1/3)),
          StaggeredTile.extent(1, (height-barheight-padding*6)*(1/3)),
        ],
      )
    );
  }
}
