import 'package:flutter/material.dart';
class Home extends StatefulWidget
{
  @override
  _home createState()=>_home();
}
class _home extends State<Home>
{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Homepage"),
      ),
      body: Center(
        child: Text("Home Page"),
      ),
    );
  }
}