import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:neutral_creep_dev/models/models.dart';

class TopUpTransferHistoryLogic {
  static final firestore = Firestore.instance;

  static void historyDialog(BuildContext context, Map data) {
    Timestamp ts = data["dateOfTopUp"];
    DateTime historyDate = ts.toDate();
    String date =
        "${historyDate.day}-${historyDate.month}-${historyDate.year}, ${historyDate.hour}:${historyDate.minute}";
    double amount = data["topUpAmount"];

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(getTransactionType(data["type"]),
                  style: TextStyle(fontSize: 40)),
              content: Container(
                height: 150,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Amount:", style: TextStyle(fontSize: 13)),
                            Text("\$${amount.toStringAsFixed(2)}")
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Date & Time:",
                                style: TextStyle(fontSize: 13)),
                            Text(date)
                          ]),
                      data["type"] == "topUp"
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                  Text("Card:", style: TextStyle(fontSize: 13)),
                                  Text(data["cardNum"])
                                ])
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                  Text("To whom:",
                                      style: TextStyle(fontSize: 13)),
                                  Text(
                                      "...${data["toWhom"].toString().substring(20)}")
                                ]),
                    ]),
              ),
              actions: <Widget>[
                FlatButton(
                    child: new Text("Close", style: TextStyle(fontSize: 20)),
                    onPressed: () => Navigator.of(context).pop())
              ]);
        });
  }

  static String getTransactionType(String type) {
    return type == "topUp" ? "Top Up" : "Transfer";
  }

  static Future<List<Map>> getHistory(Customer customer) async {
    List<Map> transactions = List<Map>();
    var docs = await firestore
        .collection("users")
        .document(customer.id)
        .collection("TopUp")
        .getDocuments();

    for (DocumentSnapshot doc in docs.documents) {
      var data = doc.data;

      if (data["type"] == "transfer") {
        transactions.add({
          "type": data["type"],
          "topUpAmount": data["topUpAmount"],
          "dateOfTopUp": data["dateOfTopUp"],
          "toWhom": data["to"]
        });
      } else {
        String bankInfo = data["bankInfo"];
        List<String> bankData = bankInfo.split("|");

        transactions.add({
          "type": data["type"],
          "topUpAmount": data["topUpAmount"],
          "dateOfTopUp": data["dateOfTopUp"],
          "cardNum": bankData[1]
        });
      }
    }
    return transactions;
  }
}
