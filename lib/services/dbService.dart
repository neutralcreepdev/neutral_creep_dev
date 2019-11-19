import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/customer.dart';
import '../models/eWallet.dart';
import '../models/delivery.dart';
import '../helpers/hash_helper.dart';

class DBService {
  final Firestore _db = Firestore.instance;

  Future<int> getTransactionId(String uid) async {
    /*var snap = await _db
        .collection("users")
        .document(uid)
        .collection("Self-Collect")
        .getDocuments();

    var snap2 = await _db
        .collection("users")
        .document(uid)
        .collection("Delivery")
        .getDocuments();

    int counter = snap.documents.length + snap2.documents.length;*/
    var snap = await _db.collection("Orders").getDocuments();
    int counter = snap.documents.length;
    return ++counter;
  }

  Future<int> getTopUpId() async {
    var snap = await _db.collection("TopUp").getDocuments();
    int counter = snap.documents.length;
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

  void writeNewCustomer(Customer customer) {
    Firestore.instance
      ..collection("users").document(customer.id).updateData({
        "id": customer.id,
        "firstName": customer.firstName,
        "lastName": customer.lastName,
        "contactNum": customer.contactNum,
        "address": customer.address,
        "dob": customer.dob,
        "eCredit": customer.eWallet.eCreadits,
        "creditCards": customer.eWallet.creditCards,
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
      hashCash.hash(toHash).then((transactionHash) {
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
        bankName = temp+": XXXX XXXX XXXX" +temp2.substring(temp2.length-4,temp2.length);
      });
    } catch (exception) {
      return bankName;
    }
    return bankName;
  }

  Future<void> transferCredit(
      String friendID, Customer customer, double transferVal) async {
    //Minus your own
    if (transferVal > customer.eWallet.eCreadits)
      Fluttertoast.showToast(msg: "Insufficient CreepDollars to transfer");
    else {
      DateTime dt = DateTime.now();

      String finalID = "";
      getTopUpId().then((topUpID) {
        String toHash = finalID + (dt.toString());
        hashCash.hash(toHash).then((transactionHash) async {
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
            await Firestore.instance
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
            await Firestore.instance
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
          } catch (exception) {
            Fluttertoast.showToast(msg: "Friend not found, top up failed.");
          }
        });
      });
    }
  }

  void setHistory(Order order, String uid, String tid) {
    //Requires the hash here -> get transactionID + uid
    String toHash = tid + (order.date.toString());
    hashCash.hash(toHash).then((hashVal) {
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
        });
    });
  }

  void setDeliveryStatus(String uid, String tid) async {
    Firestore.instance
      ..collection("users")
          .document(uid)
          .collection("Delivery")
          .document(tid)
          .delete();

    /*Firestore.instance
      ..collection("users")
          .document(uid)
          .collection("Delivery")
          .document(tid)
          .updateData({"status": "Delivered"});*/
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
