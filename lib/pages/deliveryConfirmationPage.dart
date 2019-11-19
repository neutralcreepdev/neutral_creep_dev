import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:neutral_creep_dev/helpers/color_helper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:neutral_creep_dev/models/delivery.dart';

class DeliveryConfirmation extends StatelessWidget {
  var date;
  final String id;
  final Order order;

  DeliveryConfirmation({this.order, this.date, this.id});

  @override
  Widget build(BuildContext context) {
    bool result = false;
    String dateString = date.toString().substring(0, date.toString().length);
    String hash = _hashVal(id + dateString);

    print('$id$dateString');
    Map falseResult = {"Result": false};

    return Scaffold(
        appBar: AppBar(
          //Back button
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, falseResult),
          ),
          backgroundColor: alablaster,
          centerTitle: true,
          title: Text(
            "Delivery Info",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 30,
                letterSpacing: 3),
          ),
          elevation: 0.2,
        ),
        body: Container(
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
                  Container(
                    child: Text("Cost",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                  )
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
                flex: 4,
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
                              width: MediaQuery.of(context).size.width / 8 * 4 -
                                  30,
                              child: Text("${order.items[index]['name']}",
                                  style: TextStyle(fontSize: 18)),
                            ),
                            SizedBox(width: 10),
                            Container(
                              width: MediaQuery.of(context).size.width / 8 + 10,
                              child: Text("${order.items[index]['quantity']}",
                                  style: TextStyle(fontSize: 18)),
                            ),
                            Container(
                              child: Text(
                                  "\$${order.items[index]['cost'].toStringAsFixed(2)}",
                                  style: TextStyle(fontSize: 18)),
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        index + 1 != order.items.length
                            ? Container(
                                width: MediaQuery.of(context).size.width - 30,
                                height: 1,
                                color: Colors.grey,
                              )
                            : Container(),
                        SizedBox(height: 10),
                      ],
                    );
                  },
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Total Cost:", style: TextStyle(fontSize: 20),),
                        Text("\$${order.totalAmount.toStringAsFixed(2)}",style: TextStyle(fontSize: 20,color: heidelbergRed)),
                      ],
                    ),
                    SizedBox(height: 30),
                    Text("Status : ${order.status}",
                        style: TextStyle(fontSize: 20)),
                    SizedBox(height: 40),
                    GestureDetector(
                      onTap: () async {
                        String compare = await _scanQR();
                        String compare2 = compare.toString();
                        print('$compare2');
                        //String compare = "e7465a87ca50f1cc038489f1fc76a0a1deeaa1801a3792ef1ff00eb77c958c18";
                        result = _compareHash(hash, compare2);

                        if (result) {
                          Fluttertoast.showToast(msg: "Same + $hash");
                          Navigator.pop(context, {'Result': result});
                        } else {
                          Fluttertoast.showToast(msg: "Different + $hash");
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 128.1,
                        decoration: BoxDecoration(
                          color: heidelbergRed,

                            border: Border(top: BorderSide(width: 2.0, color: Colors.black),)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.qrcode,
                              size: 50,
                              color: alablaster,
                            ),
                            SizedBox(width: 20,),
                            Text(
                              "Confirm Delivery",
                              style: TextStyle(color: alablaster,fontSize: 30),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Future<String> _scanQR() async {
    String qrResult = await BarcodeScanner.scan();
    return qrResult.toString();
  }

  String _hashVal(String val) {
    var bytes1 = utf8.encode("$val"); // data being hashed
    var digest1 = sha256.convert(bytes1); // Hashing Process
    return digest1.toString(); // Print After Hashing
  }

  bool _compareHash(String val, String compare) {
    return compare == val ? true : false;
  }
}
