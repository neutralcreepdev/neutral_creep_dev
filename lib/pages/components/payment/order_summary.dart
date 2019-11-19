import 'package:flutter/material.dart';

import '../../../helpers/color_helper.dart';
import '../../../models/models.dart';

class OrderSummary extends StatelessWidget {
  final PurchaseTransaction transaction;
  final String collectionMethod;
  final Map deliveryTime;
  const OrderSummary(
      {Key key, this.transaction, this.collectionMethod, this.deliveryTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: gainsboro,
          borderRadius: BorderRadius.all(Radius.circular(16))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Order #${transaction.id}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          Container(height: 1, width: 180, color: Colors.black),
          SizedBox(height: 30),
          label(
              "Total Cost: #${transaction.getCart().getTotalCost().toStringAsFixed(2)}"),
          label(
              "7% GST: #${(transaction.getCart().getTotalCost() * 0.07).toStringAsFixed(2)}"),
          label(
              "Grand Total: #${(transaction.getCart().getTotalCost() * 1.07).toStringAsFixed(2)}"),
          SizedBox(height: 30),
          label(
              "Delievery Method: ${collectionMethod == "1" ? "Self-Collect" : "Deliever to address"}"),
          collectionMethod == "1"
              ? Container()
              : Column(children: [
                  label(
                      "Address: blk 33 Some Stree Road\nUnit: 02-1234\nPostal Code: 112233"),
                  label(
                      "\nDelivery Time: ${deliveryTime['date']['day']}/${deliveryTime['date']['month']}/${deliveryTime['date']['year']} ${deliveryTime['time']}")
                ]),
        ],
      ),
    );
  }

  Text label(String title) {
    return Text(
      title,
      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
      textAlign: TextAlign.center,
    );
  }
}
