import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:neutral_creep_dev/helpers/color_helper.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:neutral_creep_dev/models/delivery.dart';

class DeliveryConfirmaton extends StatelessWidget {
  var date;
  String id;
  Order order;

  DeliveryConfirmaton({this.order, this.date, this.id});

  @override
  Widget build(BuildContext context) {
    String dateString =
        date.toString().substring(0, date.toString().length - 1);
    String hash = _hashVal(id + dateString);

    print('$id$dateString');
    return Scaffold(
      appBar: AppBar(
        //Back button
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
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
      body: Column(
        children: <Widget>[
          Text("Order ID: ${order.orderID}"),
          Expanded(
              child: ListView.builder(
                  itemCount: order.items.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: <Widget>[
                        Text("${order.items[index]['name']}"),
                        Text("${order.items[index]['description']}"),
                        Text("${order.items[index]['quantity']}")
                      ],
                    );
                  })),
          Text("\$${order.totalAmount}"),
          RaisedButton(
            color: alablaster,
            onPressed: () async {
              String compare = await _scanQR();
              String compare2 = compare.toString();
              print('$compare2');
              //String compare = "e7465a87ca50f1cc038489f1fc76a0a1deeaa1801a3792ef1ff00eb77c958c18";
              bool result = _compareHash(hash, compare2);
              if (result) {
                Fluttertoast.showToast(msg: "Same + $hash");
                Navigator.pop(context, {'Result': result});
              } else {
                Fluttertoast.showToast(msg: "Different + $hash");
              }
            },
          ),
        ],
      ),
    );
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
