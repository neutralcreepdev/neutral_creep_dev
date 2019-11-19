import 'package:flutter/material.dart';
import '../models/customer.dart';
import '../services/dbService.dart';

import '../pages/homePage.dart';
import '../helpers/color_helper.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TopUpPage extends StatefulWidget {
  final Customer customer;
  final DBService db;

  TopUpPage({this.customer, this.db});

  _TopUpPageState createState() => _TopUpPageState(customer: customer, db: db);
}

class _TopUpPageState extends State<TopUpPage> {
  final Customer customer;
  final DBService db;
  int _selectedIndex;
  String bankInfo = "";
  final _formKey = GlobalKey<FormState>();

  _TopUpPageState({this.customer, this.db});

  final _textController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedIndex = 0;
    bankInfo = customer.eWallet.creditCards[0]["bankName"] +
        "|" +
        customer.eWallet.creditCards[0]["cardNum"];
  }

  @override
  Widget build(BuildContext context) {
    double currVal = customer.eWallet.eCreadits;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: alablaster,
        centerTitle: true,
        elevation: 0.2,
        iconTheme: IconThemeData(color: heidelbergRed, size: 30),
        title: Text(
          "Top-Up",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 30,
              letterSpacing: 3),
        ),
      ),
      backgroundColor: whiteSmoke,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 70),
                Text(
                  "CREEP-DOLLARS Balance:\n\$${currVal.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 75),
                Text("Enter top-up amount"),
                Container(
                  width: MediaQuery.of(context).size.width - 100,
                  child: TextFormField(
                    controller: _textController,
                    validator: (val) {
                      if (val.isEmpty)
                        return "Please enter amount to transfer";
                      else if (int.parse(val) <= 0)
                        return "Please enter correct amount to transfer!";
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.attach_money,
                        color: heidelbergRed,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: heidelbergRed, width: 0.0),
                      ),
                    ),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    textAlign: TextAlign.center,
                    textInputAction: TextInputAction.done,
                  ),
                ),
                SizedBox(height: 50),
                Text("credit Card:"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 300,
                    width: MediaQuery.of(context).size.width - 60,
                    decoration: BoxDecoration(
                        color: alablaster,
                        border: Border.all(width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: customer.eWallet.creditCards.length,
                        itemBuilder: (context, index) {
                          return index == 0
                              ? Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(14),
                                        bottom: Radius.circular(0)),
                                    color: _selectedIndex != null &&
                                            _selectedIndex == index
                                        ? heidelbergRed
                                        : alablaster,
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  child: ListTile(
                                    title: Text(
                                      "${customer.eWallet.creditCards[index]["bankName"]} : XXXX XXXX XXXX ${customer.eWallet.creditCards[index]["cardNum"].toString().substring(customer.eWallet.creditCards[index]["cardNum"].toString().length - 4, customer.eWallet.creditCards[index]["cardNum"].toString().length)}\n${customer.eWallet.creditCards[index]["expiryMonth"]}-${customer.eWallet.creditCards[index]["expiryYear"]}",
                                      style: _selectedIndex != null &&
                                              _selectedIndex == index
                                          ? TextStyle(color: alablaster)
                                          : TextStyle(color: Colors.black),
                                    ),
                                    onTap: () {
                                      _selectedIndex = index;
                                      bankInfo = customer.eWallet
                                              .creditCards[index]["bankName"] +
                                          "|" +
                                          customer.eWallet.creditCards[index]
                                              ["cardNum"];
                                      print("BankInfo: $bankInfo");
                                      setState(() {});
                                    },
                                  ),
                                )
                              : Container(
                                  width: MediaQuery.of(context).size.width,
                                  color: _selectedIndex != null &&
                                          _selectedIndex == index
                                      ? heidelbergRed
                                      : alablaster,
                                  child: ListTile(
                                    title: Text(
                                      "${customer.eWallet.creditCards[index]["bankName"]} : XXXX XXXX XXXX ${customer.eWallet.creditCards[index]["cardNum"].toString().substring(customer.eWallet.creditCards[index]["cardNum"].toString().length - 4, customer.eWallet.creditCards[index]["cardNum"].toString().length)}\n${customer.eWallet.creditCards[index]["expiryMonth"]}-${customer.eWallet.creditCards[index]["expiryYear"]}",
                                      style: _selectedIndex != null &&
                                              _selectedIndex == index
                                          ? TextStyle(color: alablaster)
                                          : TextStyle(color: Colors.black),
                                    ),
                                    onTap: () {
                                      _selectedIndex = index;
                                      bankInfo = customer.eWallet
                                              .creditCards[index]["bankName"] +
                                          "|" +
                                          customer.eWallet.creditCards[index]
                                              ["cardNum"];
                                      print("BankInfo: $bankInfo");
                                      setState(() {});
                                    },
                                  ),
                                );
                        }),
                  ),
                ),
                SizedBox(height: 30),
                ButtonTheme(
                  height: 60,
                  minWidth: 300,
                  child: RaisedButton(
                    color: heidelbergRed,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35)),
                    child: Text(
                      "Confirm",
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        String addVal = _textController.text;
                        customer.eWallet.add(addVal);
                        db.updateECredit(
                            customer, double.parse(addVal), bankInfo);
                        Navigator.of(context)
                            .popUntil(ModalRoute.withName("home"));
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTile extends StatefulWidget {
  String bankInfo;
  Customer customer;
  int index;

  CustomTile({this.bankInfo, this.customer, this.index});

  @override
  CustomTileState createState() =>
      CustomTileState(customer: customer, bankInfo: bankInfo, index: index);
}

class CustomTileState extends State<CustomTile> {
  Color color;
  String bankInfo;
  Customer customer;
  int index;

  CustomTileState({this.bankInfo, this.customer, this.index});

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    color = Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _selectedIndex != null && _selectedIndex == index
          ? Colors.red
          : Colors.white,
      child: ListTile(
        title: Text(
          "Bank Card num: ${customer.eWallet.creditCards[index]["cardNum"]}\n${customer.eWallet.creditCards[index]["cardNum"]}",
        ),
        onTap: () {
          _selectedIndex = index;
          bankInfo = customer.eWallet.creditCards[index]["bankName"] +
              "|" +
              customer.eWallet.creditCards[index]["cardNum"];
          setState(() {});
        },
      ),
    );
  }
}
