import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:neutral_creep_dev/models/cart.dart';
import 'package:neutral_creep_dev/models/eWallet.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neutral_creep_dev/services/dbService.dart';

import '../models/models.dart';
import '../helpers/color_helper.dart';
import '../helpers/hash_helper.dart';
import './paymentMadePage.dart';
import 'components/payment/logic.dart';
import 'components/payment/components.dart';

class PaymentPage extends StatefulWidget {
  final DBService db;
  final Customer customer;
  final PurchaseTransaction transaction;
  final String collectionMethod;
  final EWallet eWallet;
  final Map deliveryTime;

  PaymentPage(
      {this.db,
      this.customer,
      this.transaction,
      this.collectionMethod,
      this.eWallet,
      this.deliveryTime});

  _PaymentPageState createState() => _PaymentPageState(
      db: db,
      customer: customer,
      transaction: transaction,
      collectionMethod: collectionMethod,
      eWallet: eWallet,
      deliveryTime: deliveryTime);
}

class _PaymentPageState extends State<PaymentPage> {
  final DBService db;
  final Customer customer;
  final PurchaseTransaction transaction;
  final String collectionMethod;
  final EWallet eWallet;
  final Map deliveryTime;
  int counter = 0;
  String paymentType = "";
  int points = 0;
  bool cdCheck = true;

  _PaymentPageState(
      {this.db,
      this.customer,
      this.transaction,
      this.collectionMethod,
      this.eWallet,
      this.deliveryTime});

  @override
  void initState() {
    super.initState();
    if (customer.eWallet.eCreadits <= 0) cdCheck = false;
  }

  @override
  Widget build(BuildContext context) {
    print(deliveryTime);
    return Scaffold(
      appBar: appBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: whiteSmoke,
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            OrderSummary(
                transaction: transaction,
                deliveryTime: deliveryTime,
                collectionMethod: collectionMethod),
            displayCreepDollarAmount(),
            creepDollarPaymentButton(context),
            displayCreditCardDetails(context),
            creditCardPaymentButton(context),
            SizedBox(height: 30)
          ],
        ),
      ),
    );
  }

  StatelessWidget creepDollarPaymentButton(BuildContext context) {
    return cdCheck
        ? PaymentButton(
            title: "PAY BY CREEP-DOLLARS",
            onPressed: () {
              if (customer.eWallet.eCreadits <
                  transaction.getCart().getTotalCost())
                Fluttertoast.showToast(msg: "Insufficient Creep-Dollar");
              else {
                points = PaymentLogic.handleCreepDollarPayment(
                    transaction: transaction,
                    paymentType: paymentType,
                    customer: customer,
                    collectionMethod: collectionMethod,
                    eWallet: eWallet,
                    counter: counter,
                    deliveryTime: deliveryTime,
                    points: points,
                    db: db);
                customer.clearCart();
                paymentType = "CreepDollars";
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => PaymentMadePage(
                            pointsEarned: points,
                            customer: customer,
                            paymentType: paymentType,
                            cardNo: "")),
                    ModalRoute.withName("home"));
              }
            })
        : Container();
  }

  StatelessWidget displayCreepDollarAmount() {
    return cdCheck
        ? Text(
            "Creep-Dollars Available: \$${customer.eWallet.eCreadits.toStringAsFixed(2)}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          )
        : Container();
  }

  Widget displayCreditCardDetails(BuildContext context) {
    return eWallet.creditCards.length != 0
        ? Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            creditCardDetails(context),
            changeCreditCardButton()
          ])
        : Container();
  }

  Container creditCardDetails(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 6,
      width: MediaQuery.of(context).size.width -
          (eWallet.creditCards.length > 1 ? 100 : 50),
      decoration: BoxDecoration(
          color: gainsboro,
          borderRadius: BorderRadius.all(Radius.circular(16))),
      padding: EdgeInsets.only(left: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("${eWallet.creditCards[counter]["cardNum"]}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          SizedBox(height: 20),
          Row(
            children: <Widget>[
              Text("${eWallet.creditCards[counter]["fullName"]}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              SizedBox(width: 30),
              Text(
                  "Exp: ${eWallet.creditCards[counter]["expiryMonth"]}/${eWallet.creditCards[counter]["expiryYear"]}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          )
        ],
      ),
    );
  }

  PaymentButton creditCardPaymentButton(BuildContext context) {
    return PaymentButton(
        title: "PAY BY CREDIT CARD",
        onPressed: () {
          PaymentLogic.handleCreditCardPayment(
              transaction: transaction,
              paymentType: paymentType,
              customer: customer,
              collectionMethod: collectionMethod,
              eWallet: eWallet,
              counter: counter,
              deliveryTime: deliveryTime);
          customer.clearCart();
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => PaymentMadePage(
                      pointsEarned: points,
                      customer: customer,
                      paymentType: paymentType,
                      cardNo: eWallet.creditCards[counter]["cardNum"])),
              ModalRoute.withName('home'));
        });
  }

  StatelessWidget changeCreditCardButton() {
    return eWallet.creditCards.length > 1 &&
            counter < eWallet.creditCards.length
        ? IconButton(
            icon: Icon(Icons.arrow_forward_ios),
            onPressed: () {
              if (counter < eWallet.creditCards.length - 1) {
                ++counter;
              } else
                counter = 0;
              setState(() {});
            },
          )
        : Container();
  }

  AppBar appBar() {
    return AppBar(
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
    );
  }
}
