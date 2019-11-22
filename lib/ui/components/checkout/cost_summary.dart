import 'package:flutter/material.dart';
import 'package:neutral_creep_dev/models/models.dart';

class CostSummary extends StatelessWidget {
  final PurchaseTransaction transaction;
  const CostSummary({Key key, this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 200, top: 10),
        child: Column(children: <Widget>[
          Row(children: <Widget>[
            Text("Subtotal:           ", style: TextStyle(fontSize: 13)),
            Text("\$${transaction.cart.getTotalCost().toStringAsFixed(2)}")
          ]),
          SizedBox(height: 5),
          Row(children: <Widget>[
            Text("GST:                    ", style: TextStyle(fontSize: 13)),
            Text("\$${transaction.cart.getGST().toStringAsFixed(2)}")
          ]),
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
            Text("Grand Total:  ", style: TextStyle(fontSize: 15)),
            Text("\$${transaction.cart.getGrandTotal().toStringAsFixed(2)}",
                style: TextStyle(fontSize: 30)),
            Text(" CD", style: TextStyle(fontSize: 15)),
          ]),
        ]));
  }
}
