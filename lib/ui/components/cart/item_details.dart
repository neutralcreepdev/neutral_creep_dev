import 'package:flutter/material.dart';
import 'package:neutral_creep_dev/models/cart.dart';

class ItemDetails extends StatelessWidget {
  final Grocery grocery;
  final Function upOnPressed, downOnPressed, removeOnTap;
  const ItemDetails(
      {Key key,
      this.grocery,
      this.upOnPressed,
      this.downOnPressed,
      this.removeOnTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <
        Widget>[
      Row(children: <Widget>[
        SizedBox(height: 100, width: 100, child: grocery.image),
        SizedBox(width: 20),
        Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                  width: 150,
                  child: Text(grocery.name, style: TextStyle(fontSize: 15))),
              Text(grocery.supplier, style: TextStyle(fontSize: 10)),
              SizedBox(height: 5),
              Text("Cost: \$${grocery.cost.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 20)),
            ])
      ]),
      Row(children: <Widget>[
        Text("Qty:", style: TextStyle(fontSize: 10)),
        Column(children: <Widget>[
          IconButton(icon: Icon(Icons.arrow_drop_up), onPressed: upOnPressed),
          Text("${grocery.quantity}", style: TextStyle(fontSize: 20)),
          grocery.quantity == 1
              ? Column(children: <Widget>[
                  SizedBox(height: 15),
                  GestureDetector(
                      child: Text("Remove", style: TextStyle(fontSize: 10)),
                      onTap: removeOnTap),
                ])
              : IconButton(
                  icon: Icon(Icons.arrow_drop_down), onPressed: downOnPressed)
        ])
      ])
    ]);
  }
}
