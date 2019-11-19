import 'package:flutter/material.dart';

class AddNewCreditCardPage extends StatefulWidget {
  AddNewCreditCardPage({Key key}) : super(key: key);

  @override
  _AddNewCreditCardPageState createState() => _AddNewCreditCardPageState();
}

class _AddNewCreditCardPageState extends State<AddNewCreditCardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).canvasColor,
          elevation: 0,
          shape: Border(
              bottom: BorderSide(
                  color: Theme.of(context).primaryColor, width: 0.2)),
          leading: IconButton(
              icon: Icon(Icons.arrow_back, size: 35, color: Colors.black),
              onPressed: () => Navigator.pop(context))),
      body:
          Container(child: Column(children: <Widget>[Text("cardholder name")])),
    );
  }
}
