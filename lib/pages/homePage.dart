import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:neutral_creep_dev/pages/summaryPage.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

import '../helpers/color_helper.dart';

import '../models/cart.dart';
import '../models/customer.dart';
import '../models/transaction.dart';

import '../services/authService.dart';
import '../services/dbService.dart';

import './profilePage.dart';

import 'components/home/components.dart';

class HomePage extends StatefulWidget {
  final Customer customer;
  final DBService db;

  HomePage({this.customer, this.db});

  _HomePageState createState() => _HomePageState(customer: customer, db: db);
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Customer customer;
  final AuthService auth;
  final DBService db;

  String result = "";

  _HomePageState({this.customer, this.auth, this.db});

  @override
  void initState() {
    super.initState();
    db.getEWalletData(customer.id).then((eWallet) {
      customer.eWallet = eWallet;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: buildAppBar(),
        drawer: HomePageDrawer(customer: customer, dbService: db),

        // Body =================================================
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: whiteSmoke,
            child: customer.currentCart.getCartSize() > 0
                ? cartBody()
                : Center(child: Text("current nothing in cart"))),
      ),
    );
  }

  Column cartBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: ListView.builder(
              itemCount: customer.currentCart.getCartSize(),
              itemBuilder: (context, index) {
                return ItemCard(
                    customer: customer,
                    index: index,
                    upArrowOnTap: () {
                      setState(() {
                        customer.currentCart.getGrocery(index).quantity += 1;
                      });
                    },
                    downArrowOnTap: () {
                      if (customer.currentCart.getGrocery(index).quantity > 1) {
                        setState(() {
                          customer.currentCart.getGrocery(index).quantity -= 1;
                        });
                      } else {
                        setState(() {
                          customer.currentCart.removeGrocery(index);
                        });
                      }
                    });
              }),
        ),
        CartSummary(customer: customer, dbService: db),
        SizedBox(height: 30)
      ],
    );
  }

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();

      setState(() {
        result = qrResult;
        Grocery temp = new Grocery();
        if (temp.setGroceryWithStringInput(result)) {
          if (!customer.currentCart.repeatCheck(temp)) {
            temp.quantity = 1;
            customer.currentCart.addGrocery(temp);
          }
        }
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "Camera permission was denied";
        });
      } else {
        setState(() {
          result = "Unknown Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        result = "You pressed the back button before scanning anything";
      });
    } catch (ex) {
      setState(() {
        result = "Unknown Error $ex";
      });
    }
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: alablaster,
      centerTitle: true,
      title: Text(
        "Home",
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 30,
            letterSpacing: 3),
      ),
      elevation: 0.2,
      leading: IconButton(
        icon: Icon(Icons.menu, color: heidelbergRed, size: 40),
        onPressed: () => _scaffoldKey.currentState.openDrawer(),
      ),
      actions: <Widget>[
        IconButton(
            icon: Icon(FontAwesomeIcons.qrcode, size: 30, color: heidelbergRed),
            onPressed: () => _scanQR()),
        SizedBox(width: 20),
      ],
    );
  }
}
