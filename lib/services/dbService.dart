import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/customer.dart';
import '../models/eWallet.dart';
import '../models/delivery.dart';
import '../helpers/hash_helper.dart';

class DBService {
  final Firestore _db = Firestore.instance;

  Future<int> getTransactionId(String uid) async {
    var snap = await _db.collection("Orders").getDocuments();
    int counter = snap.documents.length;
    return ++counter;
  }

  Future<int> getTopUpId() async {
    var snap = await _db.collection("TopUp").getDocuments();
    int counter = snap.documents.length;
    return ++counter;
  }

  Future<int> getPointsId() async {
    var snap = await _db.collection("Points").getDocuments();
    int counter = snap.documents.length;
    print(counter);
    return ++counter;
  }

  Future<EWallet> getEWalletData(String uid) async {
    var snap = await _db.collection("users").document(uid).get();
    EWallet eWallet = EWallet.fromMap(snap.data);

    return eWallet;
  }

  Future<Customer> getCustomerData(String uid) async {
    var snap = await _db.collection("users").document(uid).get();
    Customer customer = Customer.fromMap(snap.data);

    return customer;
  }

  Future<QuerySnapshot> getTransaction(String uid) async {
    var snap = await _db
        .collection("users")
        .document(uid)
        .collection("Delivery")
        .getDocuments();
    return snap;
  }

  void redeem(Customer customer, int pointsDeducted, double amount) {
    DateTime dt = DateTime.now();

    Firestore.instance
      ..collection("users").document(customer.id).updateData({
        "points": customer.eWallet.points,
      });

    getPointsId().then((pointId) {
      String finalID = pointId.toString().padLeft(8, "0");
      HashCash.hash(finalID + (dt.toString())).then((pointHash) {
        Firestore.instance
          ..collection("Points").document(finalID).setData({
            "type": "deduct",
            "pointsDeducted": pointsDeducted,
            "dateOfTransaction": dt,
            "pointsId": finalID,
            "pointHash": pointHash
          });

        Firestore.instance
          ..collection("users")
              .document(customer.id)
              .collection("Points")
              .document(finalID)
              .setData({
            "type": "deduct",
            "pointsDeducted": pointsDeducted,
            "dateOfTransaction": dt,
            "pointsId": finalID,
            "pointHash": pointHash
          });
      });
    });

    updateECredit(customer, amount, "Top Up through redemption");
  }

  void writeNewCustomer(Customer customer) {
    Firestore.instance
      ..collection("users").document(customer.id).setData({
        "id": customer.id,
        "name": customer.name,
        "contactNum": customer.contactNum,
        "address": customer.address,
        "dob": customer.dob,
        "eCredit": customer.eWallet.eCreadits,
        "creditCards": customer.eWallet.creditCards,
        "points": customer.eWallet.points,
      });
  }

  void updateCreditCards(Customer customer) {
    Firestore.instance
      ..collection("users").document(customer.id).updateData({
        "creditCards": customer.eWallet.creditCards,
      });
  }

  void updateECredit(Customer customer, double topUpAmount, String bankInfo) {
    //double topUpID = double.parse(getTopUpId(customer.id).toString());
    getTopUpId().then((topUpID) {
      Firestore.instance
        ..collection("users").document(customer.id).updateData({
          "eCredit": customer.eWallet.eCreadits,
        });

      String finalID = topUpID.toString().padLeft(8, "0");
      DateTime dt = DateTime.now();
      String toHash = finalID + (dt.toString());
      HashCash.hash(toHash).then((transactionHash) {
        Firestore.instance
          ..collection("TopUp").document(finalID).setData({
            "dateOfTopUp": dt,
            "customerId": customer.id,
            "topUpAmount": topUpAmount,
            "topUpId": finalID,
            "transactionHash": transactionHash,
            "bankInfo": bankInfo,
            "type": "topUp",
          });

        Firestore.instance
          ..collection("users")
              .document(customer.id)
              .collection("TopUp")
              .document(finalID)
              .setData({
            "dateOfTopUp": dt,
            "customerId": customer.id,
            "topUpAmount": topUpAmount,
            "topUpId": finalID,
            "transactionHash": transactionHash,
            "bankInfo": bankInfo,
            "type": "topUp",
          });
      });
    });
  }

  Future<String> getCard(Customer customer) async {
    String bankName = "";
    try {
      List<dynamic> creditCard = new List<Map<String, dynamic>>();
      var snap = await _db
          .collection("users")
          .document(customer.id)
          .get()
          .then((snap) {
        Map<String, dynamic> data = snap.data;
        creditCard = data['creditCards'];
        String temp = creditCard[0]["bankName"];
        String temp2 = creditCard[0]["cardNum"];
        bankName = temp +
            ": XXXX XXXX XXXX" +
            temp2.substring(temp2.length - 4, temp2.length);
      });
    } catch (exception) {
      return bankName;
    }
    return bankName;
  }

  Future<dynamic> addCCIntoCustomer(Customer customer) async {
    List<dynamic> creditCard = new List<dynamic>();
    List<Map<String, dynamic>> test = new List<Map<String, dynamic>>();
    try {
      var snap = await _db
          .collection("users")
          .document(customer.id)
          .get()
          .then((snap) {
        Map<String, dynamic> data = snap.data;
        creditCard = data['creditCards'];

        for (int i = 0; i < creditCard.length; i++) {
          Map<String, dynamic> temporary = {
            "fullName": creditCard[i]["fullName"],
            "cardNum": creditCard[i]["cardNum"],
            "expiryMonth": creditCard[i]["expiryMonth"],
            "expiryYear": creditCard[i]["expiryYear"],
            "bankName": creditCard[i]["bankName"]
          };
          test.add(temporary);
        }
      });
    } catch (exception) {
      print("goodbye");
      return test;
    }
    return test;
  }

  Future<void> transferCredit(
      String friendID, Customer customer, double transferVal) async {
    //Minus your own
    print("transVal $transferVal ++++++ Ecredit${customer.eWallet.eCreadits}");
    try {
      if (transferVal > customer.eWallet.eCreadits) {
        print("here?");
        Fluttertoast.showToast(msg: "Insufficient CreepDollars to transfer");
      } else {
        DateTime dt = DateTime.now();

        String finalID = "";
        getTopUpId().then((topUpID) {
          String toHash = finalID + (dt.toString());
          HashCash.hash(toHash).then((transactionHash) async {
            try {
              finalID = topUpID.toString().padLeft(8, "0");
              Firestore.instance
                ..collection("TopUp").document(finalID).setData({
                  "dateOfTopUp": dt,
                  "customerId": customer.id,
                  "topUpAmount": transferVal,
                  "topUpId": finalID,
                  "transactionHash": transactionHash,
                  "from": customer.id,
                  "to": friendID,
                  "type": "transfer",
                });
              //Find Friend and add to his
              double friendInitECredits = 0;
              var snap = await _db
                  .collection("users")
                  .document(friendID)
                  .get()
                  .then((snap) {
                Map<String, dynamic> data = snap.data;
                friendInitECredits = data['eCredit'];
              });

              friendInitECredits += transferVal;
              print("FriendEcredit: $friendInitECredits");
              Firestore.instance
                ..collection("users").document(friendID).updateData({
                  "eCredit": friendInitECredits,
                });

              //For transaction History
              Firestore.instance
                ..collection("users")
                    .document(friendID)
                    .collection("TopUp")
                    .document(finalID)
                    .setData({
                  "dateOfTopUp": dt,
                  "customerId": friendID,
                  "topUpAmount": transferVal,
                  "topUpId": finalID,
                  "transactionHash": transactionHash,
                  "from": customer.id,
                  "to": friendID,
                  "type": "transfer",
                });

              //Update Own
              customer.eWallet.eCreadits -= transferVal;
              Firestore.instance
                ..collection("users").document(customer.id).updateData({
                  "eCredit": customer.eWallet.eCreadits,
                });

              //For transaction History
              Firestore.instance
                ..collection("users")
                    .document(customer.id)
                    .collection("TopUp")
                    .document(finalID)
                    .setData({
                  "dateOfTopUp": dt,
                  "customerId": customer.id,
                  "topUpAmount": transferVal,
                  "topUpId": finalID,
                  "transactionHash": transactionHash,
                  "from": customer.id,
                  "to": friendID,
                  "type": "transfer",
                });
              Fluttertoast.showToast(msg: "Transfer to $friendID completed!");
            } catch (exception) {
              Fluttertoast.showToast(msg: "Friend not found, top up failed.");
            }
          });
        });
      }
    } catch (x) {}
  }

  void setHistory(Order order, String uid, String tid) {
    //Requires the hash here -> get transactionID + uid
    String toHash = tid + (order.date.toString());
    HashCash.hash(toHash).then((hashVal) {
      Firestore.instance
        ..collection("users")
            .document(uid)
            .collection("History")
            .document(tid)
            .setData({
          "paymentType": order.paymentType,
          "dateOfTransaction": order.date,
          "transactionId": order.orderID,
          "type": "purchase",
          "items": order.items,
          "collectType": "Delivery",
          "totalAmount": order.totalAmount,
          "customerId": order.customerId,
          "address": order.address,
          "status": "Delivered",
          "transactionHash": hashVal,
          "timeArrival": order.timeArrival,
          "actualTime": "",
        });
    });
  }

  Future<void> updateProfile(Customer customer) async {
    Firestore.instance
      ..collection("users").document(customer.id).updateData({
        "name": customer.name,
        "contactNum": customer.contactNum,
        "address": customer.address,
      });
  }

  void delete(String uid, String tid, String mode) async {
    Firestore.instance
      ..collection("users")
          .document(uid)
          .collection(mode)
          .document(tid)
          .delete();
  }

  Future<QuerySnapshot> getTopUpHistory(String uid) async {
    var snap = await _db
        .collection("users")
        .document(uid)
        .collection("TopUp")
        .getDocuments();
    return snap;
  }

  Future<QuerySnapshot> getTransactionHistory(String uid) async {
    var snap = await _db
        .collection("users")
        .document(uid)
        .collection("History")
        .getDocuments();
    return snap;
  }
}
