import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:neutral_creep_dev/helpers/hash_helper.dart';
import 'package:neutral_creep_dev/models/models.dart';
import 'package:neutral_creep_dev/services/dbService.dart';
import 'package:provider/provider.dart';

import 'loading_dialog.dart';

class RewardsLogic {
  static final firestore = Firestore.instance;
  static final DBService _db = DBService();

  static void errorDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: new Text("Error"),
              content: new Text("Unable to redeem"),
              actions: <Widget>[
                new FlatButton(
                    child: new Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ]);
        });
  }

  static Future<bool> handleRedeem(BuildContext context, double reward) async {
    bool isSuccessful;
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          redeem(context, reward).then((_) {
            isSuccessful = true;
            Navigator.pop(context);
          }).catchError((error, stackTrace) {
            print("$error $stackTrace");
            isSuccessful = false;
            Navigator.pop(context);
          });

          return LoadingDialog();
        });

    return isSuccessful;
  }

  static Future<void> redeem(BuildContext context, double reward) async {
    DateTime timeNow = DateTime.now();
    int pointsDeducted = reward.toInt() * 50;

    Provider.of<Customer>(context).eWallet.addCreepDollar(reward);
    Provider.of<Customer>(context).eWallet.subtractPoints(pointsDeducted);

    Customer customer = Provider.of<Customer>(context);

    await firestore.collection("users").document(customer.id).updateData({
      "points": customer.eWallet.points,
      "eCredit": customer.eWallet.eCreadits,
    });

    String pointsID = (await _db.getPointsId()).toString().padLeft(8, "0");
    String pointsHash = await HashCash.hash(pointsID + (timeNow.toString()));

    await firestore.collection("Points").document(pointsID).setData({
      "type": "deduct",
      "pointsDeducted": pointsDeducted,
      "dateOfTransaction": timeNow,
      "pointsId": pointsID,
      "pointHash": pointsHash
    });

    await firestore
        .collection("users")
        .document(customer.id)
        .collection("Points")
        .document(pointsID)
        .setData({
      "type": "deduct",
      "pointsDeducted": pointsDeducted,
      "dateOfTransaction": timeNow,
      "pointsId": pointsID,
      "pointHash": pointsHash
    });
  }
}
