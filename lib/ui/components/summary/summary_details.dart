import 'package:flutter/material.dart';

import 'package:neutral_creep_dev/models/models.dart';
import 'package:neutral_creep_dev/ui/components/summary/components.dart';

class SummaryDetails extends StatelessWidget {
  final PurchaseTransaction transaction;
  final Map deliveryAndPaymentMethod, address, creditCard;
  const SummaryDetails(
      {Key key,
      this.transaction,
      this.deliveryAndPaymentMethod,
      this.address,
      this.creditCard})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Order ID: ${transaction.id}",
                  style: TextStyle(
                      fontSize: 20, decoration: TextDecoration.underline)),
              SizedBox(height: 30),
              subtotalText(),
              SizedBox(height: 10),
              gstText(),
              SizedBox(height: 10),
              grandtotalText(),
              SizedBox(height: 10),
              getCardOrPoints(),
              SizedBox(height: 40),
              collectionMethodText(),
              SizedBox(height: 10),
              deliveryAndPaymentMethod["deliveryMethod"] == "deliver"
                  ? addressAndTimeText()
                  : Container()
            ]));
  }

  Widget getCardOrPoints() {
    if (deliveryAndPaymentMethod["paymentMethod"] == "creep dollar") {
      return pointsEarnedText();
    } else {
      return creditCardText();
    }
  }

  Column addressAndTimeText() {
    Map date = deliveryAndPaymentMethod["deliveryTime"]["date"];
    String time = deliveryAndPaymentMethod["deliveryTime"]["time"];

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("address:", style: TextStyle(fontSize: 15)),
          Text("${address["street"]}", style: TextStyle(fontSize: 30)),
          Text("unit no.: ${address["unit"]}", style: TextStyle(fontSize: 20)),
          Text("S${address["postalCode"]}", style: TextStyle(fontSize: 20)),
          SizedBox(height: 10),
          Text("delivery timing:", style: TextStyle(fontSize: 15)),
          Text("${date["day"]}-${date["month"]}-${date["year"]}, $time",
              style: TextStyle(fontSize: 30))
        ]);
  }

  Column collectionMethodText() {
    String method;

    if (deliveryAndPaymentMethod["deliveryMethod"] == "deliver")
      method = "deliver to address";
    else
      method = "self-collection";

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("collection method:", style: TextStyle(fontSize: 15)),
          Text("$method", style: TextStyle(fontSize: 30)),
        ]);
  }

  Row creditCardText() {
    return Row(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
      Text("credit card no.:      "),
      Text("xxxx xxxx xxxx ${creditCard["cardNum"].toString().substring(12)}",
          style: TextStyle(fontSize: 20)),
    ]);
  }

  Row pointsEarnedText() {
    int points = SummaryLogic.getPointsEarned(transaction.cart.getGrandTotal());

    return Row(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
      Text("points earned:        "),
      Text("$points", style: TextStyle(fontSize: 40)),
      Text("pts", style: TextStyle(fontSize: 15))
    ]);
  }

  Row grandtotalText() {
    return Row(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
      Text("grand total:           "),
      Text("\$${transaction.cart.getGrandTotal().toStringAsFixed(2)}",
          style: TextStyle(fontSize: 40)),
      Text("cd", style: TextStyle(fontSize: 15))
    ]);
  }

  Row gstText() {
    return Row(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
      Text("7% GST:                                      ",
          style: TextStyle(fontSize: 15)),
      Text("\$${transaction.cart.getGST().toStringAsFixed(2)}")
    ]);
  }

  Row subtotalText() {
    return Row(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
      Text("subtotal:                                    ",
          style: TextStyle(fontSize: 15)),
      Text("\$${transaction.cart.getTotalCost().toStringAsFixed(2)}")
    ]);
  }
}
