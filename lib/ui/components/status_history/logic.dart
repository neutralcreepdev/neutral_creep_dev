import 'package:barcode_scan/barcode_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neutral_creep_dev/helpers/hash_helper.dart';
import 'package:neutral_creep_dev/models/models.dart';
import 'package:neutral_creep_dev/services/dbService.dart';
import 'package:provider/provider.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class StatusHistoryLogic {
  static final firestore = Firestore.instance;
  static final _db = DBService();

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
                height: 300,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("method: ${order["collectType"]}"),
                      Text("total cost: \$${totalCost.toStringAsFixed(2)}"),
                      SizedBox(height: 20),
                      Row(children: <Widget>[
                        SizedBox(width: 20, child: Center(child: Text("no."))),
                        SizedBox(width: 150, child: Text("item")),
                        SizedBox(width: 40, child: Center(child: Text("cost"))),
                        SizedBox(width: 40, child: Center(child: Text("qty"))),
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
                                        width: 20,
                                        child: Center(
                                            child: Text("${index + 1}."))),
                                    SizedBox(
                                        width: 150,
                                        child: Text("${item["name"]}")),
                                    SizedBox(
                                        width: 40,
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
                    child: new Text("return", style: TextStyle(fontSize: 20)),
                    onPressed: () => Navigator.of(context).pop())
              ]);
        });
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
