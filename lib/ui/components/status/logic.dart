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

class StatusLogic {
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
                  style: TextStyle(fontSize: 25)),
              content: Container(
                height: 340,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Method: ${order["collectType"]}",
                          style: TextStyle(fontSize: 15)),
                      Text("Total Cost: \$${totalCost.toStringAsFixed(2)}",
                          style: TextStyle(fontSize: 15)),
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
                    child: new Text("Scan", style: TextStyle(fontSize: 20)),
                    onPressed: () => handleScanQR(context, order, customer)),
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

  static Future<void> handleScanQR(
      BuildContext context, Map orderMap, Customer customer) async {
    Navigator.pop(context);
    String result = await scanQR();

    if (orderMap["collectType"] == "Delivery") {
      Order order = Order.fromMap(orderMap);
      String compare = result;
      String compare2 = compare.toString();
      String hash = hashVal(order.orderID + order.date.toString());
      bool isValid = compareHash(hash, compare2);

      if (isValid) {
        _db.setHistory(order, order.customerId, order.orderID);
        _db.delete(order.customerId, order.orderID, "Delivery");
      } else {
        Fluttertoast.showToast(msg: "Different + $hash");
      }
    } else {
      String lockerNo = orderMap["lockerNum"];
      var bytes1 = utf8.encode(lockerNo);
      String hashedlockerNum = sha256.convert(bytes1).toString();

      if (result == hashedlockerNum) {
        Timestamp ts = orderMap["dateOfTransaction"];
        String transactionHash = await HashCash.hash(
            orderMap["transactionId"] + ts.toDate().toString());

        if (orderMap["paymentType"] == "CreditCard") {
          firestore
              .collection("users")
              .document(customer.id)
              .collection("History")
              .document(orderMap["transactionId"])
              .setData({
            "collectType": orderMap["collectType"],
            "dateOfTransaction": ts.toDate(),
            "transactionId": orderMap["transactionId"],
            "totalAmount": orderMap["totalAmount"],
            "type": "purchase",
            "items": orderMap["items"],
            "transactionHash": transactionHash,
            "status": "Collected",
            "paymentType": orderMap["paymentType"],
            "creditCard": customer.eWallet.creditCards[orderMap["counter"]],
            "lockerNum": lockerNo,
            "customerId": customer.id
          });
        } else {
          firestore
              .collection("users")
              .document(customer.id)
              .collection("History")
              .document(orderMap["transactionId"])
              .setData({
            "collectType": orderMap["collectType"],
            "dateOfTransaction": ts.toDate(),
            "transactionId": orderMap["transactionId"],
            "totalAmount": orderMap["totalAmount"],
            "type": "purchase",
            "items": orderMap["items"],
            "transactionHash": transactionHash,
            "status": "Collected",
            "paymentType": orderMap["paymentType"],
            "lockerNum": lockerNo,
            "customerId": customer.id
          });
        }
        _db.delete(customer.id, orderMap["transactionId"], "Self-Collect");
      } else {
        Fluttertoast.showToast(msg: "Invalid locker number");
      }
    }
  }

  static String hashVal(String val) {
    var bytes1 = utf8.encode("$val"); // data being hashed
    var digest1 = sha256.convert(bytes1); // Hashing Process
    return digest1.toString(); // Print After Hashing
  }

  static bool compareHash(String val, String compare) {
    return compare == val ? true : false;
  }

  static Future<String> scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      return qrResult.toString();
    } catch (e) {
      print("$e");
    }
  }

  static Future<List<Map>> getItems(BuildContext context) async {
    List<Map> orders = List<Map>();
    String id = Provider.of<Customer>(context).id;

    var deliverySnap = await firestore
        .collection('users')
        .document(id)
        .collection("Delivery")
        .getDocuments();

    for (DocumentSnapshot doc in deliverySnap.documents) {
      orders.add(doc.data);
    }

    var selfCollectSnap = await firestore
        .collection('users')
        .document(id)
        .collection("Self-Collect")
        .getDocuments();

    for (DocumentSnapshot doc in selfCollectSnap.documents) {
      orders.add(doc.data);
    }

    return orders;
  }
}
