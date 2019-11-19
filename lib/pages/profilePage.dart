import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

import '../models/eWallet.dart';
import '../models/customer.dart';

import '../helpers/color_helper.dart';

import '../services/dbService.dart';

class ProfilePage extends StatefulWidget {
  Customer customer;
  DBService db;

  ProfilePage({this.customer, this.db});

  _ProfilePageState createState() =>
      _ProfilePageState(customer: customer, db: db);
}

class _ProfilePageState extends State<ProfilePage> {
  Customer customer;
  DBService db;

  _ProfilePageState({this.customer, this.db});

  final _formKey = GlobalKey<FormState>();
  String dropdownValue = 'One';
  String newValue = "";
  bool visibilityTag = false;

  @override
  Widget build(BuildContext context) {
    if (customer.eWallet.creditCards.length > 0)
      visibilityTag = true;
    else
      visibilityTag = false;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: alablaster,
        centerTitle: true,
        elevation: 0.2,
        iconTheme: IconThemeData(color: heidelbergRed, size: 30),
        title: Text(
          "Profile",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 30,
              letterSpacing: 3),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
                /*child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/testProfilePic.PNG'),
                radius: 40.0,
              ),*/
                child: Container(
              decoration: new BoxDecoration(
                // Circle shape
                shape: BoxShape.circle,
                // The border you want
                border: new Border.all(
                  width: 1.0,
                  color: heidelbergRed,
                ),
              ),
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/testProfilePic.PNG'),
                radius: 40.0,
              ),
            )),
            Divider(
              height: 60.0,
              color: heidelbergRed,
            ),
            Text('Full Name: ',
                style: TextStyle(
                  color: heidelbergRed,
                  letterSpacing: 2.0,
                )),
            SizedBox(height: 10.0),
            Text(
              '${customer.lastName} ${customer.firstName}',
              style: TextStyle(
                  color: heidelbergRed,
                  letterSpacing: 2.0,
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 25.0),
            Text('Address:',
                style: TextStyle(
                  color: heidelbergRed,
                  letterSpacing: 2.0,
                )),
            SizedBox(height: 10.0),
            Text(
              'Blk ${customer.address['unit']}\n${customer.address['street']}\nS(${customer.address['postalCode']})',
              style: TextStyle(
                  color: heidelbergRed,
                  letterSpacing: 2.0,
                  fontSize: 23.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 25.0),
            Text('Contact Number:',
                style: TextStyle(
                  color: heidelbergRed,
                  letterSpacing: 2.0,
                )),
            SizedBox(height: 10.0),
            Text(
              '${customer.contactNum}',
              style: TextStyle(
                  color: heidelbergRed,
                  letterSpacing: 2.0,
                  fontSize: 23.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30.0),
            /* Row(
              children: <Widget>[
                Icon(Icons.card_membership, color: heidelbergRed),
                //Add a drop downOption to see which card is already in the account
                Text("CardInfo",
                    style: TextStyle(
                      color: heidelbergRed,
                      fontSize: 18.0,
                      letterSpacing: 1.0,
                    ))
              ],
            ),*/
            SizedBox(height: 10.0),
            Text('Current CreditCards:',
                style: TextStyle(
                  color: heidelbergRed,
                  letterSpacing: 2.0,
                )),
            visibilityTag
                ? new Row(
                    children: <Widget>[
                      Icon(Icons.card_membership),
                      SizedBox(
                        width: 10,
                      ),
                      DropdownButton<String>(
                        value: null,
                        style: TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (newValue) {
                          setState(() {
                            print('$newValue');
                            dropdownValue = newValue;
                          });
                        },
                        items: //<String>['One', 'Two', 'Free', 'Four']
                            customer.eWallet.creditCards
                                .map<DropdownMenuItem<String>>(
                                    (Map<String,dynamic> value) {
                          return DropdownMenuItem<String>(
                            value: value["bankName"],
                            child: Text(value["cardNum"]),
                          );
                        }).toList(),
                      ),
                    ],
                  )
                : new Container(),
            SizedBox(height: 10.0),
            visibilityTag
                ? Text('$dropdownValue')
                : Text('No CreditCard Saved'),
            SizedBox(
              height: 30.0,
            ),
            Container(
              color: heidelbergRed,
              child: FlatButton.icon(
                icon: Icon(
                  Icons.add,
                  color: whiteSmoke,
                ),
                label: Text(
                  "Add a new credit Card:",
                  style: TextStyle(color: whiteSmoke),
                ),
                onPressed: () async {
                  final _bankNameController = TextEditingController();
                  final _cardNumController = TextEditingController();
                  final _fullNameController = TextEditingController();
                  final _expYearController = TextEditingController();
                  final _expMonthController = TextEditingController();
                  await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Enter CreditCard Details"),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    decoration:
                                        InputDecoration(hintText: "FullName"),
                                    controller: _fullNameController,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    decoration:
                                        InputDecoration(hintText: "BankName"),
                                    controller: _bankNameController,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    decoration:
                                        InputDecoration(hintText: "CardNo."),
                                    controller: _cardNumController,
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(children: [
                                      Expanded(
                                        child: TextField(
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                              hintText: "Month"),
                                          controller: _expMonthController,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: TextField(
                                          textAlign: TextAlign.center,
                                          decoration:
                                              InputDecoration(hintText: "Year"),
                                          controller: _expYearController,
                                        ),
                                      )
                                    ])),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: RaisedButton(
                                      child: Text("Submit"),
                                      onPressed: () {
                                        if (_formKey.currentState.validate()) {
                                          _formKey.currentState.save();
                                          Navigator.pop(context);
                                        }
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      });


                  Map<String,dynamic> credit = {
                      "fullName": _fullNameController.text,
                      "cardNum": _cardNumController.text,
                      "expiryMonth": _expMonthController.text,
                      "expiryYear": _expYearController.text,
                      "bankName": _bankNameController.text};
                  print(credit);
                  customer.eWallet.creditCards.add(credit);
                  //customer.eWallet.creditCards.clear();

                  db.updateCreditCards(customer);
                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
