import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:neutral_creep_dev/models/models.dart';
import 'package:provider/provider.dart';

class StatusHistoryLogic {
  static final firestore = Firestore.instance;

  static void itemDialog(BuildContext context, Map order, Customer customer) {
    double totalCost = order["totalAmount"];
    List<dynamic> items = order["items"];
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Order ${order["transactionId"]}",
                  style: TextStyle(fontSize: 30)),
              content: Container(
                height: 340,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Method: ${order["collectType"]}"),
                      Text("Total Cost: \$${totalCost.toStringAsFixed(2)}"),
                      getLockerNumber(order),
                      SizedBox(height: 20),
                      Row(children: <Widget>[
                        SizedBox(width: 35, child: Center(child: Text("No."))),
                        SizedBox(width: 120, child: Text("Item")),
                        SizedBox(width: 50, child: Center(child: Text("Cost"))),
                        SizedBox(width: 40, child: Center(child: Text("Qty"))),
                      ]),
                      Container(height: 1, color: Colors.black),
                      Container(
                          height: 230,
                          width: 260,
                          child: ListView.builder(
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                Map item = items[index];
                                double cost = item["cost"];
                                return Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Row(children: <Widget>[
                                    SizedBox(
                                        width: 35,
                                        child: Center(
                                            child: Text("${index + 1}."))),
                                    SizedBox(
                                        width: 120,
                                        child: Text(
                                          "${item["name"]}",
                                          style: TextStyle(fontSize: 13),
                                        )),
                                    SizedBox(
                                        width: 50,
                                        child: Center(
                                            child: Text(
                                                "\$${cost.toStringAsFixed(2)}"))),
                                    SizedBox(
                                        width: 40,
                                        child: Center(
                                            child:
                                                Text("${item["quantity"]}"))),
                                  ]),
                                );
                              })),
                    ]),
              ),
              actions: <Widget>[
                FlatButton(
                    child: new Text("Close", style: TextStyle(fontSize: 20)),
                    onPressed: () => Navigator.of(context).pop())
              ]);
        });
  }

  static Widget getLockerNumber(Map order) {
    if (order["collectType"] == "Self-Collect") {
      if (order["lockerNum"].toString().isNotEmpty)
        return Text("Locker #${order["lockerNum"]}",
            style: TextStyle(fontSize: 15));
    }
    return Container();
  }

  static Future<List<Map>> getItems(BuildContext context) async {
    List<Map> orders = List<Map>();
    String id = Provider.of<Customer>(context).id;

    var deliverySnap = await firestore
        .collection('users')
        .document(id)
        .collection("History")
        .getDocuments();

    for (DocumentSnapshot doc in deliverySnap.documents) {
      orders.add(doc.data);
    }

    return orders;
  }
}
