import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:neutral_creep_dev/models/cart.dart';
import 'package:neutral_creep_dev/models/eWallet.dart';

import '../models/customer.dart';
import '../models/transaction.dart';

import '../helpers/color_helper.dart';
import '../helpers/hash_helper.dart' as hash_helper;

import './paymentMadePage.dart';

class PaymentPage extends StatefulWidget {
  final Customer customer;
  final PurchaseTransaction transaction;
  final String collectionMethod;
  final EWallet eWallet;

  PaymentPage(
      {this.customer, this.transaction, this.collectionMethod, this.eWallet});

  _PaymentPageState createState() => _PaymentPageState(
      customer: customer,
      transaction: transaction,
      collectionMethod: collectionMethod,
      eWallet: eWallet);
}

class _PaymentPageState extends State<PaymentPage> {
  final Customer customer;
  final PurchaseTransaction transaction;
  final String collectionMethod;
  final EWallet eWallet;

  _PaymentPageState(
      {this.customer, this.transaction, this.collectionMethod, this.eWallet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: alablaster,
        iconTheme: IconThemeData(color: heidelbergRed, size: 30),
        centerTitle: true,
        title: Text(
          "Payment",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 30,
              letterSpacing: 3),
        ),
        elevation: 0.2,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: whiteSmoke,
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: gainsboro,
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Order #${transaction.id}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Container(
                    height: 1,
                    width: 180,
                    color: Colors.black,
                  ),
                  SizedBox(height: 30),
                  Text(
                    "Total Cost: #${transaction.getCart().getTotalCost().toStringAsFixed(2)}",
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
                  ),
                  Text(
                    "7% GST: #${(transaction.getCart().getTotalCost() * 0.07).toStringAsFixed(2)}",
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
                  ),
                  Text(
                    "Grand Total: #${(transaction.getCart().getTotalCost() * 1.07).toStringAsFixed(2)}",
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
                  ),
                  SizedBox(height: 30),
                  Text(
                    "Delievery Method: ${collectionMethod == "1" ? "Self-Collect" : "Deliever to address"}",
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
                  ),
                  collectionMethod == "1"
                      ? Container()
                      : Text(
                          "Address: blk 33 Some Stree Road\nUnit: 02-1234\nPostal Code: 112233",
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 15),
                          textAlign: TextAlign.center,
                        )
                ],
              ),
            ),
            Text(
              "Creep-Dollars Available: \$${eWallet.eCreadits.toStringAsFixed(2)}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            ButtonTheme(
              height: 60,
              minWidth: 250,
              child: RaisedButton(
                  color: heidelbergRed,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35)),
                  child: Text(
                    "PAY BY CREEP-DOLLARS",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  onPressed: () {
                    List<Map<String, Object>> items =
                        new List<Map<String, Object>>();
                    for (Grocery item in transaction.getCart().groceries) {
                      items.add({"id": item.id,"cost":item.cost, "quantity": item.quantity, "description":item.description, "name":item.name});
                    }

                    eWallet.eCreadits -=
                        (customer.currentCart.getTotalCost() * 1.07);
                    DateTime dt = DateTime.now();


                    String toHash = transaction.id+(dt.toString());
                    String transactionHash = hash_helper.hashCash.hash(toHash);



                    Firestore.instance
                        .collection("users")
                        .document(customer.id)
                        .updateData({"eCredit": eWallet.eCreadits});


                    Firestore.instance
                      ..collection("Orders")
                          .document(transaction.id)
                          .setData({
                        "dateOfTransaction": dt,
                        "customerId": customer.id,
                        "totalAmount": transaction.getCart().getTotalCost(),
                        "type": "purchase",
                        "items": items,

                        "status": "Waiting",
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
                          "dateOfTransaction": dt,
                          "transactionId": transaction.id,
                          "totalAmount": transaction.getCart().getTotalCost(),
                          "type": "purchase",
                          "items": items,
                          "lockerNum": "",
                          "transactionHash":transactionHash,

                          "status": "Waiting",
                        });

                      // WIll move to another location when qr scanned on the locker. (Status collected)
                      Firestore.instance
                        ..collection("users")
                            .document(customer.id)
                            .collection("History")
                            .document(transaction.id)
                            .setData({
                          "dateOfTransaction": dt,
                          "transactionId": transaction.id,
                          "totalAmount": transaction.getCart().getTotalCost(),
                          "type": "purchase",
                          "items": items,
                          "collectionMethod": "Self-Collect",
                          "transactionHash":transactionHash,

                          "status": "Waiting",
                        });

                      Firestore.instance
                        ..collection("Packaging")
                            .document(transaction.id)
                            .setData({
                          "collectType": collectType,
                          "dateOfTransaction": dt,
                          "transactionId": transaction.id,
                          "totalAmount": transaction.getCart().getTotalCost(),
                          "type": "purchase",
                          "items": items,
                          "customerId": customer.id,
                          "name": customer.firstName+" "+customer.lastName,
                          "address": customer.address,
                        });
                    } else if (collectionMethod == "2") {
                      collectType = "Delivery";
                      Firestore.instance
                        ..collection("users")
                            .document(customer.id)
                            .collection("Delivery")
                            .document(transaction.id)
                            .setData({
                          "dateOfTransaction": dt,
                          "transactionId": transaction.id,
                          "totalAmount": transaction.getCart().getTotalCost(),
                          "type": "purchase",
                          "items": items,
                          "customerId": customer.id,
                          "name": customer.firstName+" "+customer.lastName,
                          "address": customer.address,
                          "transactionHash":transactionHash,

                          "status": "Waiting",
                        });

                      //Print Transaction Delivery
                      Firestore.instance
                        ..collection("Packaging")
                            .document(transaction.id)
                            .setData({
                          "collectType": collectType,
                          "dateOfTransaction": dt,
                          "transactionId": transaction.id,
                          "totalAmount": transaction.getCart().getTotalCost(),
                          "type": "purchase",
                          "items": items,
                          "customerId": customer.id,
                          "name": customer.firstName+" "+customer.lastName,
                          "address": customer.address,
                        });
                    }
                    customer.clearCart();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => PaymentMadePage(
                                eWallet: eWallet,
                              )),
                      ModalRoute.withName("home"),
                    );
                  }),
            ),
            eWallet.creditCards.length != 0
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height / 6,
                        width: MediaQuery.of(context).size.width -
                            (eWallet.creditCards.length > 1 ? 100 : 50),
                        decoration: BoxDecoration(
                            color: gainsboro,
                            borderRadius:
                                BorderRadius.all(Radius.circular(16))),
                        padding: EdgeInsets.only(left: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "${eWallet.creditCards[0]["cardNum"]}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: <Widget>[
                                Text("${eWallet.creditCards[0]["fullName"]}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                                SizedBox(width: 30),
                                Text(
                                    "Exp: ${eWallet.creditCards[0]["expiryMonth"]}/${eWallet.creditCards[0]["expiryYear"]}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                              ],
                            )
                          ],
                        ),
                      ),
                      eWallet.creditCards.length > 1
                          ? IconButton(
                              icon: Icon(Icons.arrow_forward_ios),
                              onPressed: () {},
                            )
                          : Container()
                    ],
                  )
                : Container(),
            ButtonTheme(
              height: 60,
              minWidth: 250,
              child: RaisedButton(
                  color: heidelbergRed,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35)),
                  child: Text(
                    "PAY BY CREDIT CARD",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  onPressed: () {}),
            ),
            SizedBox(height: 30)
          ],
        ),
      ),
    );
  }

  void hashCash(){
    bool fake = true;
    String plaintext = "ABC";
    while(fake){
      String ptBinary = plaintext.toString();

    }
  }
}
