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
              gstText(),
              divider(),
              grandtotalText(),
              getCardOrPoints(),
              divider(),
              SizedBox(height: 40),
              collectionMethodText(),
              SizedBox(height: 10),
              deliveryAndPaymentMethod["deliveryMethod"] == "deliver"
                  ? addressAndTimeText()
                  : Container()
            ]));
  }

  Padding divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        height: 1,
        color: Colors.black,
      ),
    );
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
          Text("Address:", style: TextStyle(fontSize: 15)),
          Text("${address["street"]}", style: TextStyle(fontSize: 30)),
          Text("Unit No.: ${address["unit"]}", style: TextStyle(fontSize: 15)),
          Text("S${address["postalCode"]}", style: TextStyle(fontSize: 15)),
          SizedBox(height: 20),
          Text("Delivery Timing:", style: TextStyle(fontSize: 15)),
          Text("${date["day"]}-${date["month"]}-${date["year"]}, $time",
              style: TextStyle(fontSize: 30))
        ]);
  }

  Column collectionMethodText() {
    String method;

    if (deliveryAndPaymentMethod["deliveryMethod"] == "deliver")
      method = "Deliver to address";
    else
      method = "Self-Collection";

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Collection Method:", style: TextStyle(fontSize: 15)),
          Text("$method", style: TextStyle(fontSize: 30)),
        ]);
  }

  Row creditCardText() {
    return Row(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
      Text("Credit Card No.:    ", style: TextStyle(fontSize: 20)),
      Text("xxxx xxxx xxxx ${creditCard["cardNum"].toString().substring(12)}",
          style: TextStyle(fontSize: 15)),
    ]);
  }

  Row pointsEarnedText() {
    int points = SummaryLogic.getPointsEarned(transaction.cart.getGrandTotal());

    return Row(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
      Text("Points earned:       ", style: TextStyle(fontSize: 20)),
      Text("$points", style: TextStyle(fontSize: 40)),
      Text("Pts", style: TextStyle(fontSize: 15))
    ]);
  }

  Row grandtotalText() {
    return Row(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
      Text("Grand Total:           ", style: TextStyle(fontSize: 20)),
      Text("\$${transaction.cart.getGrandTotal().toStringAsFixed(2)}",
          style: TextStyle(fontSize: 30)),
      Text("CD", style: TextStyle(fontSize: 15))
    ]);
  }

  Row gstText() {
    return Row(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
      Text("7% GST:                              ",
          style: TextStyle(fontSize: 15)),
      Text("\$${transaction.cart.getGST().toStringAsFixed(2)}",
          style: TextStyle(fontSize: 20))
    ]);
  }

  Row subtotalText() {
    return Row(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
      Text("Subtotal:                            ",
          style: TextStyle(fontSize: 15)),
      Text("\$${transaction.cart.getTotalCost().toStringAsFixed(2)}",
          style: TextStyle(fontSize: 20))
    ]);
  }
}
