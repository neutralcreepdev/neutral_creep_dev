import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:neutral_creep_dev/services/dbService.dart';

import '../../../models/models.dart';
import '../../../helpers/hash_helper.dart';

class PaymentLogic {
  static int handleCreepDollarPayment({
    PurchaseTransaction transaction,
    String paymentType,
    Customer customer,
    String collectionMethod,
    EWallet eWallet,
    int counter,
    Map deliveryTime,
    int points,
    DBService db,
  }) {
    List<Map<String, Object>> items = new List<Map<String, Object>>();
    for (Grocery item in transaction.getCart().groceries) {
      items.add({
        "id": item.id,
        "cost": item.cost,
        "quantity": item.quantity,
        "description": item.description,
        "name": item.name
      });
    }

    customer.eWallet.eCreadits -= (customer.currentCart.getTotalCost() * 1.07);
    DateTime dt = DateTime.now();

    String toHash = transaction.id + (dt.toString());
    HashCash.hash(toHash).then((transactionHash) {
      paymentType = "CreepDollars";
      points = _pointSystem(db, transaction.getCart().getTotalCost(), dt, items,
          transactionHash, customer, transaction);
      Firestore.instance.collection("users").document(customer.id).updateData({
        "eCredit": customer.eWallet.eCreadits,
        "points": customer.eWallet.points
      });

      Firestore.instance
        ..collection("Orders").document(transaction.id).setData({
          "dateOfTransaction": dt,
          "customerId": customer.id,
          "totalAmount": transaction.getCart().getTotalCost(),
          "type": "purchase",
          "items": items,
          "status": "Waiting",
          "paymentType": paymentType,
          "counter": counter,
        });

      String collectType = "";

      //Self Collect
      if (collectionMethod == "1") {
        collectType = "Self-Collect";
        Firestore.instance
          ..collection("users")
              .document(customer.id)
              .collection("Self-Collect")
              .document(transaction.id)
              .setData({
            "collectType": collectType,
            "dateOfTransaction": dt,
            "transactionId": transaction.id,
            "totalAmount": transaction.getCart().getTotalCost(),
            "type": "purchase",
            "items": items,
            "lockerNum": "",
            "transactionHash": transactionHash,
            "status": "Waiting",
            "paymentType": paymentType,
            "counter": counter,
            "customerId": customer.id
          });

        Firestore.instance
          ..collection("Packaging").document(transaction.id).setData({
            "collectType": collectType,
            "dateOfTransaction": dt,
            "transactionId": transaction.id,
            "totalAmount": transaction.getCart().getTotalCost(),
            "type": "purchase",
            "items": items,
            "customerId": customer.id,
            "name": customer.name,
            "address": customer.address,
            "paymentType": paymentType,
            "counter": counter,
          });
      } else if (collectionMethod == "2") {
        collectType = "Delivery";
        Firestore.instance
          ..collection("users")
              .document(customer.id)
              .collection("Delivery")
              .document(transaction.id)
              .setData({
            "collectType": collectType,
            "dateOfTransaction": dt,
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
            "timeArrival": deliveryTime,
            "counter": counter,
            "actualTime": "",
          });

        //Print Transaction Delivery
        Firestore.instance
          ..collection("Packaging").document(transaction.id).setData({
            "collectType": collectType,
            "dateOfTransaction": dt,
            "transactionId": transaction.id,
            "totalAmount": transaction.getCart().getTotalCost(),
            "type": "purchase",
            "items": items,
            "customerId": customer.id,
            "name": customer.name,
            "address": customer.address,
            "paymentType": paymentType,
            "timeArrival": deliveryTime,
            "counter": counter,
            "actualTime": "",
          });
      }
      return points;
    });
  }

  static int _pointSystem(
    DBService db,
    double totalAmount,
    DateTime dt,
    List<Map<String, Object>> items,
    String transactionHash,
    Customer customer,
    PurchaseTransaction transaction,
  ) {
    int val = 0;
    if (totalAmount < 20) {
      print("no get points");
      return val;
    } else {
      val = (2 * totalAmount).round();
      customer.eWallet.points += val;
      print("gotten $val");

      db.getPointsId().then((pointId) {
        String finalID = pointId.toString().padLeft(8, "0");
        HashCash.hash(finalID + dt.toString()).then((pointHash) {
          print("value check: $finalID, ${dt.toString()} $pointHash");
          Firestore.instance
            ..collection("Points").document(finalID).setData({
              "type": "add",
              "pointsEarned": val,
              "dateOfTransaction": dt,
              "pointsId": finalID,
              "totalAmount": transaction.getCart().getTotalCost(),
              "items": items,
              "pointHash": pointHash
            });

          Firestore.instance
            ..collection("users")
                .document(customer.id)
                .collection("Points")
                .document(finalID)
                .setData({
              "type": "add",
              "pointsEarned": val,
              "dateOfTransaction": dt,
              "pointsId": finalID,
              "totalAmount": transaction.getCart().getTotalCost(),
              "items": items,
              "pointHash": pointHash
            });
        });
      });

      return val;
    }
  }

  static void handleCreditCardPayment({
    PurchaseTransaction transaction,
    String paymentType,
    Customer customer,
    String collectionMethod,
    EWallet eWallet,
    int counter,
    Map deliveryTime,
  }) {
    List<Map<String, Object>> items = new List<Map<String, Object>>();
    for (Grocery item in transaction.getCart().groceries) {
      items.add({
        "id": item.id,
        "cost": item.cost,
        "quantity": item.quantity,
        "description": item.description,
        "name": item.name
      });
    }

    DateTime dt = DateTime.now();
    paymentType = "CreditCard";

    String toHash = transaction.id + (dt.toString());
    HashCash.hash(toHash).then((transactionHash) {
      Firestore.instance
        ..collection("Orders").document(transaction.id).setData({
          "dateOfTransaction": dt,
          "customerId": customer.id,
          "totalAmount": transaction.getCart().getTotalCost(),
          "type": "purchase",
          "items": items,
          "status": "Waiting",
          "paymentType": paymentType,
          "creditCard": eWallet.creditCards[counter],
          "counter": counter,
        });

      String collectType = "";

      //Self Collect
      if (collectionMethod == "1") {
        collectType = "Self-Collect";
        Firestore.instance
          ..collection("users")
              .document(customer.id)
              .collection("Self-Collect")
              .document(transaction.id)
              .setData({
            "collectType": collectType,
            "dateOfTransaction": dt,
            "transactionId": transaction.id,
            "totalAmount": transaction.getCart().getTotalCost(),
            "type": "purchase",
            "items": items,
            "lockerNum": "",
            "transactionHash": transactionHash,
            "status": "Waiting",
            "paymentType": paymentType,
            "creditCard": eWallet.creditCards[counter],
            "counter": counter,
          });

        Firestore.instance
          ..collection("Packaging").document(transaction.id).setData({
            "collectType": collectType,
            "dateOfTransaction": dt,
            "transactionId": transaction.id,
            "totalAmount": transaction.getCart().getTotalCost(),
            "type": "purchase",
            "items": items,
            "customerId": customer.id,
            "name": customer.name,
            "address": customer.address,
            "paymentType": paymentType,
            "creditCard": eWallet.creditCards[counter],
            "counter": counter,
          });
      } else if (collectionMethod == "2") {
        collectType = "Delivery";
        Firestore.instance
          ..collection("users")
              .document(customer.id)
              .collection("Delivery")
              .document(transaction.id)
              .setData({
            "collectType": collectType,
            "dateOfTransaction": dt,
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
            "creditCard": eWallet.creditCards[counter],
            "timeArrival": deliveryTime,
            "counter": counter,
            "actualTime": "",
          });

        //Print Transaction Delivery
        Firestore.instance
          ..collection("Packaging").document(transaction.id).setData({
            "collectType": collectType,
            "dateOfTransaction": dt,
            "transactionId": transaction.id,
            "totalAmount": transaction.getCart().getTotalCost(),
            "type": "purchase",
            "items": items,
            "customerId": customer.id,
            "name": customer.name,
            "address": customer.address,
            "paymentType": paymentType,
            "creditCard": eWallet.creditCards[counter],
            "timeArrival": deliveryTime,
            "counter": counter,
            "actualTime": "",
          });
      }
    });
  }
}
