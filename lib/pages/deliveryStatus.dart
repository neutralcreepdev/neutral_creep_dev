import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:neutral_creep_dev/services/dbService.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../models/customer.dart';
import '../models/delivery.dart';

import '../helpers/color_helper.dart';
import '../helpers/hash_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryStatusPage extends StatefulWidget {
  final Order order;
  final Customer customer;
  final String status;
  final DBService db;

  DeliveryStatusPage({this.order, this.customer, this.status, this.db});

  _DeliveryStatusPageState createState() => _DeliveryStatusPageState(
      customer: customer, order: order, status: status, db: db);
}

class _DeliveryStatusPageState extends State<DeliveryStatusPage> {
  final Order order;
  final Customer customer;
  final String status;
  final DBService db;

  _DeliveryStatusPageState({this.order, this.customer, this.status, this.db});

  String result = "";

  String hashedlockNo = "";

  Future getData() async {
    var firestore = Firestore.instance;
    //to change if else
    QuerySnapshot qn = await firestore
        .collection('users')
        .document(customer.id)
        .collection(order.collectType)
        .getDocuments();
    return qn;
  }

  Future _scanQR(String hashedlockNo, String lockerNo) async {
    try {
      String qrResult = await BarcodeScanner.scan();

      setState(() {
        result = qrResult;

        if (result == hashedlockNo) {
          Fluttertoast.showToast(msg: "Thank you for using Neutral Creep!");

          /************Delete from Self-Collect, Add to History, Update user status to received*******************/

          String toHash = order.orderID + (order.date).toString();
          HashCash.hash(toHash).then((transactionHash) {
            if (order.paymentType == "CreditCard") {
              // WIll move to another location when qr scanned on the locker. (Status collected)
              Firestore.instance
                ..collection("users")
                    .document(customer.id)
                    .collection("History")
                    .document(order.orderID)
                    .setData({
                  "collectType": order.collectType,
                  "dateOfTransaction": order.date,
                  "transactionId": order.orderID,
                  "totalAmount": order.totalAmount,
                  "type": "purchase",
                  "items": order.items,
                  "transactionHash": transactionHash,
                  "status": "Collected",
                  "paymentType": order.paymentType,
                  "creditCard": customer.eWallet.creditCards[order.counter],
                  "lockerNum": lockerNo,
                  "customerId": customer.id
                });
            } else if (order.paymentType == "CreepDollars") {
              Firestore.instance
                ..collection("users")
                    .document(customer.id)
                    .collection("History")
                    .document(order.orderID)
                    .setData({
                  "collectType": order.collectType,
                  "dateOfTransaction": order.date,
                  "transactionId": order.orderID,
                  "totalAmount": order.totalAmount,
                  "type": "purchase",
                  "items": order.items,
                  "transactionHash": transactionHash,
                  "status": "Collected",
                  "paymentType": order.paymentType,
                  "lockerNum": lockerNo,
                  "customerId": customer.id
                });
            }
            db.delete(customer.id, order.orderID, "Self-Collect");
            Navigator.pop(context);
          });
        } else {
          Fluttertoast.showToast(msg: "chou ji dan");
        }
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "Camera permission was denied";
          print("$result");
        });
      } else {
        setState(() {
          result = "Unknown Error $ex";
          print("$result");
        });
      }
    } on FormatException {
      setState(() {
        result = "You pressed the back button before scanning anything";
        print("$result");
      });
    } catch (ex) {
      setState(() {
        result = "Unknown Error $ex";
        print("$result");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: alablaster,
        iconTheme: IconThemeData(color: heidelbergRed, size: 30),
        centerTitle: true,
        title: Text(
          "Summary",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 30,
              letterSpacing: 3),
        ),
        elevation: 0.2,
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          String status = "";
          String lockerNo = "";
          if (!snapshot.hasData) return Text("Loading");
          for (int i = 0; i < snapshot.data.documents.length; i++) {
            if (snapshot.data.documents[i]['transactionId'] == order.orderID) {
              status = snapshot.data.documents[i]['status'];
              if (snapshot.data.documents[i]['collectType'] == "Self-Collect")
                lockerNo = snapshot.data.documents[i]['lockerNum'];

              var bytes1 = utf8.encode(lockerNo); // data being hashed
              hashedlockNo = sha256.convert(bytes1).toString();
              // Fluttertoast.showToast(msg: hashedlockNo);
            }
          }
          if (status == "Self-Collect") {
            status = "Ready for collection";
          }
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: whiteSmoke,
            child: Column(
              children: <Widget>[
                SizedBox(height: 10),
                Text(
                  "Order #${order.orderID}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    SizedBox(width: 10),
                    Container(
                        width: MediaQuery.of(context).size.width / 8,
                        child: Text("No.",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20))),
                    Container(
                      width: MediaQuery.of(context).size.width / 8 * 4 - 40,
                      child: Text("Item",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: MediaQuery.of(context).size.width / 8 + 10,
                      child: Text("Qty",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Container(
                  width: MediaQuery.of(context).size.width - 10,
                  height: 1,
                  color: Colors.black,
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: order.items.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              SizedBox(width: 10),
                              Container(
                                  width: MediaQuery.of(context).size.width / 8,
                                  child: Text("${index + 1}",
                                      style: TextStyle(fontSize: 18))),
                              Container(
                                width:
                                    MediaQuery.of(context).size.width / 8 * 4 -
                                        30,
                                child: Text("${order.items[index]['name']}",
                                    style: TextStyle(fontSize: 18)),
                              ),
                              SizedBox(width: 10),
                              Container(
                                width:
                                    MediaQuery.of(context).size.width / 8 + 10,
                                child: Text("${order.items[index]['quantity']}",
                                    style: TextStyle(fontSize: 18)),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: 30),
                Text("Status : $status", style: TextStyle(fontSize: 24)),
                SizedBox(height: 10),
                Visibility(
                  child: Column(
                    children: <Widget>[
                      Text("Locker No. : $lockerNo",
                          style: TextStyle(fontSize: 24)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Scan the locker -> '),
                          SizedBox(width: 10),
                          IconButton(
                            icon: Icon(
                              FontAwesomeIcons.qrcode,
                              size: 30,
                              color: heidelbergRed,
                            ),
                            onPressed: () {
                              _scanQR(hashedlockNo, lockerNo);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  visible: status == "Ready for collection" ? true : false,
                ),
                SizedBox(height: 10),
                ButtonTheme(
                  height: 60,
                  minWidth: 250,
                  child: RaisedButton(
                      color: heidelbergRed,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35)),
                      child: Text(
                        "OK",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
                SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }
}
