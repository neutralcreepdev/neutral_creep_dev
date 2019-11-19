import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as prefix0;

import '../models/customer.dart';
import '../models/eWallet.dart';
import 'package:neutral_creep_dev/models/delivery.dart';

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

  void updateECredit(Customer customer){
    Firestore.instance
      ..collection("users").document(customer.id).updateData({
        "eCredit": customer.eWallet.eCreadits,
      });
  }

  void setHistory(Order order, String uid, String tid) {
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
