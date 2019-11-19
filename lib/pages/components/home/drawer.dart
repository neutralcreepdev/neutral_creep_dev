import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../deliveryCheck.dart';
import '../../eWalletPage.dart';
import '../../profilePage.dart';
import '../../startPage.dart';
import '../../transactionHistory.dart';
import '../../../models/models.dart';
import '../../../services/dbService.dart';

class HomePageDrawer extends StatelessWidget {
  final Customer customer;
  final DBService dbService;
  const HomePageDrawer({Key key, this.customer, this.dbService})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          SizedBox(height: 30),
          drawerButtons(context, "E-Wallet", () {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    EWalletPage(customer: customer, db: dbService)));
          }),
          SizedBox(height: 30),
          drawerButtons(context, "Profile", () {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    ProfilePage(customer: customer, db: dbService)));
          }),
          SizedBox(height: 30),
          drawerButtons(context, "Transaction history", () {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    TransactionHistoryPage(customer: customer, db: dbService)));
          }),
          SizedBox(height: 30),
          drawerButtons(context, "Order Status", () {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    DeliveryCheckPage(customer: customer, db: dbService)));
          }),
          SizedBox(height: 30),
          drawerButtons(context, "Logout", () {
            FirebaseAuth.instance.signOut();
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => StartPage()));
          }),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  InkWell drawerButtons(BuildContext context, String title, Function onTap) {
    return InkWell(
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      ),
      onTap: onTap,
    );
  }
}
