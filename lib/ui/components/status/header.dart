import 'package:flutter/material.dart';

class StatusHeader extends StatelessWidget {
  const StatusHeader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 150,
        width: double.infinity,
        color: Theme.of(context).backgroundColor,
        padding: EdgeInsets.only(right: 30, top: 30),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.history, size: 40, color: Colors.black),
                  onPressed: () {}),
              Text("history", style: TextStyle(fontSize: 15))
            ]));
  }
}
