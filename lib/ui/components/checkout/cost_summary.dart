import 'package:flutter/material.dart';
import 'package:neutral_creep_dev/models/models.dart';

class CostSummary extends StatelessWidget {
  final PurchaseTransaction transaction;
  const CostSummary({Key key, this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
            right: 30, left: MediaQuery.of(context).size.width - 225),
        child: Column(children: <Widget>[
          Row(children: <Widget>[
            Text("subtotal:           ", style: TextStyle(fontSize: 15)),
            Text("\$${transaction.cart.getTotalCost().toStringAsFixed(2)}")
          ]),
          SizedBox(height: 5),
          Row(children: <Widget>[
            Text("GST:                    ", style: TextStyle(fontSize: 15)),
            Text("\$${transaction.cart.getGST().toStringAsFixed(2)}")
          ]),
          SizedBox(height: 15),
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
            Text("grand total:     ", style: TextStyle(fontSize: 15)),
            Text("\$${transaction.cart.getGrandTotal().toStringAsFixed(2)}",
                style: TextStyle(fontSize: 40, height: 0.7)),
            Text("cd", style: TextStyle(fontSize: 15)),
          ]),
        ]));
  }
}
