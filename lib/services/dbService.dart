import 'package:cloud_firestore/cloud_firestore.dart';

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

  Future<int> getTopUpId(String uid) async {
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

  void updateECredit(Customer customer, int topUpAmount) {

    //double topUpID = double.parse(getTopUpId(customer.id).toString());
    getTopUpId(customer.id).then((topUpID) {
      Firestore.instance
        ..collection("users").document(customer.id).updateData({
          "eCredit": customer.eWallet.eCreadits,
        });

      String finalID = topUpID.toString().padLeft(8, "0");
      DateTime dt = DateTime.now();
      String toHash = finalID+(dt.toString());
      String transactionHash = hashCash.hash(toHash);
      Firestore.instance
        ..collection("TopUp").document(finalID).setData({
          "DateOfTopUp": dt,
          "customerId": customer.id,
          "TopUpAmount": topUpAmount,
          "TopUpId": topUpID,
          "transactionHash":transactionHash,
        });

      Firestore.instance
        ..collection("users")
            .document(customer.id)
            .collection("TopUp")
            .document(finalID)
            .setData({
          "DateOfTopUp": dt,
          "customerId": customer.id,
          "TopUpAmount": topUpAmount,
          "TopUpId": topUpID,
          "transactionHash":transactionHash,
        });
    });

  }

  void setHistory(Order order, String uid, String tid) {
    //Requires the hash here -> get transactionID + uid
    String toHash = tid + (order.date.toString());
    String hashVal = hashCash.hash(toHash);

    Firestore.instance
      ..collection("users")
          .document(uid)
          .collection("History")
          .document(tid)
          .setData({
        "dateOfTransaction": order.date,
        "transactionId": order.orderID,
        "type": "purchase",
        "items": order.items,
        "collectionMethod": "Delivery",
        "totalAmount": order.totalAmount,
        "customerId": order.customerId,
        "address": order.address,
        "status": "Delivered",
        "transactionHash": hashVal,
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
}
