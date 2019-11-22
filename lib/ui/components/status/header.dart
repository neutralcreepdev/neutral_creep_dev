import 'package:flutter/material.dart';
import 'package:neutral_creep_dev/ui/status_history_page.dart';

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
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StatusHistoryPage()))),
              Padding(
                padding: const EdgeInsets.only(right: 3.0),
                child: Text("History",
                    style: TextStyle(
                        fontSize: 10, color: Theme.of(context).primaryColor)),
              )
            ]));
  }
}
