import 'package:flutter/material.dart';

class SelectorRow extends StatelessWidget {
  final int selectorIndex;
  final Function allOnPressed, selfOnPressed, deliveryOnPressed;
  const SelectorRow(
      {Key key,
      this.selectorIndex,
      this.allOnPressed,
      this.selfOnPressed,
      this.deliveryOnPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          selectorButton(context, "All", 0, allOnPressed, 25),
          selectorButton(context, "Self-Collect", 1, selfOnPressed, 100),
          selectorButton(context, "Delivery", 2, deliveryOnPressed, 65),
        ],
      ),
    );
  }

  Column selectorButton(BuildContext context, String title, int index,
      Function onPressed, double length) {
    return Column(children: <Widget>[
      SizedBox(
          height: 23,
          child: FlatButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Text(title,
                  style: TextStyle(
                      fontSize: 20,
                      color: selectorIndex == index
                          ? Theme.of(context).primaryColor
                          : Colors.black)),
              onPressed: onPressed)),
      selectorIndex == index
          ? Container(
              color: Theme.of(context).primaryColor,
              height: 2,
              width: length,
            )
          : Container()
    ]);
  }
}
