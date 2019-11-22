import 'package:flutter/material.dart';

class HistoryList extends StatelessWidget {
  final Map history;
  final Function onTap;
  const HistoryList({Key key, this.history, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double topUpAmount = history["topUpAmount"];

    return Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        height: 100,
        width: double.infinity,
        child: InkWell(
          onTap: onTap,
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.black),
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(getHistoryType(history["type"]),
                        style: TextStyle(fontSize: 30)),
                    Text("\$${topUpAmount.toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 30))
                  ])),
        ));
  }

  String getHistoryType(String type) {
    return type == "topUp" ? "Top Up" : "Transfer";
  }
}
