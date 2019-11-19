import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:neutral_creep_dev/helpers/hash_helper.dart';
import 'package:neutral_creep_dev/models/models.dart';

import 'loading_dialog.dart';

class TopUpLogic {
  static final firestore = Firestore.instance;

  static void errorDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: new Text("Error"),
              content: new Text("Unable to top up your credits"),
              actions: <Widget>[
                new FlatButton(
                    child: new Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ]);
        });
  }

  static Future<bool> handleTopUpCreepDollars(
      {BuildContext context,
      Customer customer,
      double topUpAmount,
      String bankInfo}) async {
    bool isSuccessful;
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          addCreepDollar(customer, topUpAmount, bankInfo).then((_) {
            isSuccessful = true;
            Navigator.pop(context);
          }).catchError((error, stackTrace) {
            isSuccessful = false;
            Navigator.pop(context);
          });
          return LoadingDialog();
        });

    return isSuccessful;
  }

  static Future<void> addCreepDollar(
      Customer customer, double topUpAmount, String bankInfo) async {
    String topUpID = (await getTopUpId()).toString().padLeft(8, "0");
    DateTime timeNow = DateTime.now();

    firestore.collection("users").document(customer.id).updateData({
      "eCredit": customer.eWallet.eCreadits,
    });

    String transactionHash =
        await HashCash.hash(topUpID + (timeNow.toString()));

    firestore.collection("TopUp").document(topUpID).setData({
      "dateOfTopUp": timeNow,
      "customerId": customer.id,
      "topUpAmount": topUpAmount,
      "topUpId": topUpID,
      "transactionHash": transactionHash,
      "bankInfo": bankInfo,
      "type": "topUp",
    });

    firestore
        .collection("users")
        .document(customer.id)
        .collection("TopUp")
        .document(topUpID)
        .setData({
      "dateOfTopUp": timeNow,
      "customerId": customer.id,
      "topUpAmount": topUpAmount,
      "topUpId": topUpID,
      "transactionHash": transactionHash,
      "bankInfo": bankInfo,
      "type": "topUp",
    });
  }

  static Future<int> getTopUpId() async {
    var snap = await firestore.collection("TopUp").getDocuments();
    int counter = snap.documents.length;
    return ++counter;
  }
}
