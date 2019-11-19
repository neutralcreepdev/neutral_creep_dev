import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:neutral_creep_dev/helpers/hash_helper.dart';
import 'package:neutral_creep_dev/services/dbService.dart';
import 'package:provider/provider.dart';

import 'package:neutral_creep_dev/models/models.dart';

import 'loading_dialog.dart';

class SummaryLogic {
  static final DBService _db = DBService();

  static void errorDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: new Text("Error"),
              content: new Text("Unable to confirm your purchase"),
              actions: <Widget>[
                new FlatButton(
                    child: new Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ]);
        });
  }

  static Future<bool> handleConfirmPurchase(
      BuildContext context, Map deliveryAndPaymentMethod) async {
    bool isSuccessful;
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          confirmPurchase(context, deliveryAndPaymentMethod).then((_) {
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

  static Future<void> confirmPurchase(
    BuildContext context,
    Map deliveryAndPaymentMethod,
  ) async {
    final firestore = Firestore.instance;
    Customer customer = Provider.of<Customer>(context);
    PurchaseTransaction transaction = Provider.of<PurchaseTransaction>(context);

    List<Map<String, dynamic>> items = getItems(transaction.cart.groceries);
    DateTime timeNow = DateTime.now();
    String paymentMethod = deliveryAndPaymentMethod["paymentMethod"];

    String transactionHash =
        await HashCash.hash(transaction.id + timeNow.toString());

    int pointsEarned = getPointsEarned(transaction.cart.getGrandTotal());
    String pointsID = (await _db.getPointsId()).toString().padLeft(8, "0");
    String pointsHash = await HashCash.hash(pointsID + timeNow.toString());

    if (paymentMethod == "credit card") {
      int cardIndex = deliveryAndPaymentMethod["cardIndex"];
      String collectionMethod = deliveryAndPaymentMethod["deliveryMethod"];
      String paymentType = "CreditCard";

      await firestore.collection("Orders").document(transaction.id).setData({
        "dateOfTransaction": timeNow,
        "customerId": customer.id,
        "totalAmount": transaction.getCart().getGrandTotal(),
        "type": "purchase",
        "items": items,
        "status": "Waiting",
        "paymentType": paymentType,
        "creditCard": customer.eWallet.creditCards[cardIndex],
        "counter": cardIndex,
      });

      if (collectionMethod == "deliver") {
        String collectionType = "Delivery";
        Map timeArrival = deliveryAndPaymentMethod["deliveryTime"];

        await firestore
            .collection("users")
            .document(customer.id)
            .collection("Delivery")
            .document(transaction.id)
            .setData({
          "collectType": collectionType,
          "dateOfTransaction": timeNow,
          "transactionId": transaction.id,
          "totalAmount": transaction.getCart().getGrandTotal(),
          "type": "purchase",
          "items": items,
          "customerId": customer.id,
          "name": customer.name,
          "address": customer.address,
          "transactionHash": transactionHash,
          "status": "Waiting",
          "paymentType": paymentType,
          "creditCard": customer.eWallet.creditCards[cardIndex],
          "timeArrival": timeArrival,
          "counter": cardIndex,
          "actualTime": "",
        });

        await firestore
            .collection("Packaging")
            .document(transaction.id)
            .setData({
          "collectType": collectionType,
          "dateOfTransaction": timeNow,
          "transactionId": transaction.id,
          "totalAmount": transaction.getCart().getTotalCost(),
          "type": "purchase",
          "items": items,
          "customerId": customer.id,
          "name": customer.name,
          "address": customer.address,
          "paymentType": paymentType,
          "creditCard": customer.eWallet.creditCards[cardIndex],
          "timeArrival": timeArrival,
          "counter": cardIndex,
          "actualTime": "",
        });
      } else {
        String collectionType = "Self-Collect";

        await firestore
            .collection("users")
            .document(customer.id)
            .collection("Self-Collect")
            .document(transaction.id)
            .setData({
          "collectType": collectionType,
          "dateOfTransaction": timeNow,
          "transactionId": transaction.id,
          "totalAmount": transaction.getCart().getTotalCost(),
          "type": "purchase",
          "items": items,
          "lockerNum": "",
          "transactionHash": transactionHash,
          "status": "Waiting",
          "paymentType": paymentType,
          "creditCard": customer.eWallet.creditCards[cardIndex],
          "counter": cardIndex,
        });

        await firestore
            .collection("Packaging")
            .document(transaction.id)
            .setData({
          "collectType": collectionType,
          "dateOfTransaction": timeNow,
          "transactionId": transaction.id,
          "totalAmount": transaction.getCart().getTotalCost(),
          "type": "purchase",
          "items": items,
          "customerId": customer.id,
          "name": customer.name,
          "address": customer.address,
          "paymentType": paymentType,
          "creditCard": customer.eWallet.creditCards[cardIndex],
          "counter": cardIndex,
        });
      }
    } else {
      String collectionMethod = deliveryAndPaymentMethod["deliveryMethod"];
      String paymentType = "CreepDollars";

      Firestore.instance
        ..collection("Orders").document(transaction.id).setData({
          "dateOfTransaction": timeNow,
          "customerId": customer.id,
          "totalAmount": transaction.getCart().getTotalCost(),
          "type": "purchase",
          "items": items,
          "status": "Waiting",
          "paymentType": paymentType,
        });

      Provider.of<Customer>(context)
          .eWallet
          .subtractECredit(transaction.getCart().getGrandTotal());
      Provider.of<Customer>(context).eWallet.addPoints(pointsEarned);

      await firestore.collection("users").document(customer.id).updateData({
        "eCredit": customer.eWallet.eCreadits,
        "points": customer.eWallet.points
      });

      await firestore.collection("Points").document(pointsID).setData({
        "type": "add",
        "pointsEarned": pointsEarned,
        "dateOfTransaction": timeNow,
        "pointsId": pointsID,
        "totalAmount": transaction.getCart().getGrandTotal(),
        "items": items,
        "pointHash": pointsHash
      });

      await firestore
          .collection("users")
          .document(customer.id)
          .collection("Points")
          .document(pointsID)
          .setData({
        "type": "add",
        "pointsEarned": pointsEarned,
        "dateOfTransaction": timeNow,
        "pointsId": pointsID,
        "totalAmount": transaction.getCart().getGrandTotal(),
        "items": items,
        "pointHash": pointsHash
      });

      if (collectionMethod == "deliver") {
        String collectionType = "Delivery";
        Map timeArrival = deliveryAndPaymentMethod["deliveryTime"];

        await firestore
            .collection("users")
            .document(customer.id)
            .collection("Delivery")
            .document(transaction.id)
            .setData({
          "collectType": collectionType,
          "dateOfTransaction": timeNow,
          "transactionId": transaction.id,
          "totalAmount": transaction.getCart().getTotalCost(),
          "type": "purchase",
          "items": items,
          "customerId": customer.id,
          "name": customer.name,
          "address": customer.address,
          "transactionHash": transactionHash,
          "status": "Waiting",
          "paymentType": paymentType,
          "timeArrival": timeArrival,
          "actualTime": "",
        });

        await firestore
            .collection("Packaging")
            .document(transaction.id)
            .setData({
          "collectType": collectionType,
          "dateOfTransaction": timeNow,
          "transactionId": transaction.id,
          "totalAmount": transaction.getCart().getTotalCost(),
          "type": "purchase",
          "items": items,
          "customerId": customer.id,
          "name": customer.name,
          "address": customer.address,
          "paymentType": paymentType,
          "timeArrival": timeArrival,
          "actualTime": "",
        });
      } else {
        String collectionType = "Self-Collect";

        await firestore
            .collection("users")
            .document(customer.id)
            .collection("Self-Collect")
            .document(transaction.id)
            .setData({
          "collectType": collectionType,
          "dateOfTransaction": timeNow,
          "transactionId": transaction.id,
          "totalAmount": transaction.getCart().getTotalCost(),
          "type": "purchase",
          "items": items,
          "lockerNum": "",
          "transactionHash": transactionHash,
          "status": "Waiting",
          "paymentType": paymentType,
          "customerId": customer.id
        });

        Firestore.instance
          ..collection("Packaging").document(transaction.id).setData({
            "collectType": collectionType,
            "dateOfTransaction": timeNow,
            "transactionId": transaction.id,
            "totalAmount": transaction.getCart().getTotalCost(),
            "type": "purchase",
            "items": items,
            "customerId": customer.id,
            "name": customer.name,
            "address": customer.address,
            "paymentType": paymentType,
          });
      }
    }
  }

  static List<Map<String, dynamic>> getItems(List<Grocery> groceries) {
    List<Map<String, dynamic>> items = new List<Map<String, dynamic>>();

    for (Grocery item in groceries) {
      items.add({
        "id": item.id,
        "cost": item.cost,
        "quantity": item.quantity,
        "description": item.description,
        "name": item.name
      });

      return items;
    }
  }

  static int getPointsEarned(double totalCost) {
    int val = 0;
    if (totalCost >= 20) val = (2 * totalCost).round();
    return val;
  }
}
