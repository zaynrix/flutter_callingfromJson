import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';

class HomePage extends StatefulWidget {
  final  username;

  const HomePage({Key key, this.username}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.username}"),
      ),
    );
  }
}
