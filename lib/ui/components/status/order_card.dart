import 'package:flutter/material.dart';
import 'logic.dart';

class OrderItemCard extends StatelessWidget {
  final Map order;
  const OrderItemCard({Key key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalCost = order["totalAmount"];
    return Container(
        height: 150,
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        child: InkWell(
            onTap: () {
              StatusLogic.itemDialog(context, order);
            },
            child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 1, color: Colors.black)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("order ${order["transactionId"]}",
                          style: TextStyle(fontSize: 30)),
                      Text("Method: ${order["collectType"]}",
                          style: TextStyle(fontSize: 20)),
                      Text("total cost: \$${totalCost.toStringAsFixed(2)}",
                          style: TextStyle(fontSize: 20)),
                      SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text("status: ", style: TextStyle(fontSize: 15)),
                            Text("${order["status"]}",
                                style: TextStyle(fontSize: 25))
                          ])
                    ]))));
  }
}
