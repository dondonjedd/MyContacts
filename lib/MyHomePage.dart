import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
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
        title: Text(widget.title),
      ),
      body: Container(
        child: StaggeredGridView.countBuilder(
          primary: true,
          itemCount: 3,
          /*physics: const NeverScrollableScrollPhysics(),*/
          mainAxisSpacing: 20.0,
          crossAxisSpacing: 20.0,
          crossAxisCount:2,
          itemBuilder: (BuildContext context, int index) => GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => index==0? const ContactScreen() :const Text('not configured yet'),
                ),
              );
            },
            child: AnimationConfiguration.staggeredGrid(
              position: index, columnCount: 2, child: ScaleAnimation(

                duration: index==0? const Duration(milliseconds: 500) : index==1?const Duration(milliseconds: 1000) : const Duration(milliseconds: 1500) ,
                child:FadeInAnimation(
                    child: Card(shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 10,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[SvgPicture.asset('assets/images/contact.svg',height: 100,),Text('My Contacts', style: cardTextStyle),],

                        )
                    )
                )
            )
            ),
          ),
          staggeredTileBuilder: (int index) =>
              StaggeredTile.extent(index>0 ? 1 : 2,index>0 ? (height-barheight-padding*6)*(1/3) :(height-barheight-padding*6)*(2/3))
        ),
      ),
    );
  }
}

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}



