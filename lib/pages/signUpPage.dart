import 'package:flutter/material.dart';
import 'package:neutral_creep_dev/models/customer.dart';

import 'package:neutral_creep_dev/helpers/color_helper.dart';
import 'package:neutral_creep_dev/services/dbService.dart';

import 'package:neutral_creep_dev/pages/homePage.dart';

class SignUpPage extends StatefulWidget {
  final String uid;
  final DBService db;

  SignUpPage({this.uid, this.db});

  @override
  _SignUpPageState createState() => _SignUpPageState(db: db, uid: uid);
}

class _SignUpPageState extends State<SignUpPage> {
  final DBService db;
  String uid;
  Customer customer;

  _SignUpPageState({this.db, this.uid});

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dayController = TextEditingController();
  final _monthController = TextEditingController();
  final _yearController = TextEditingController();
  final _contactNumController = TextEditingController();
  final _streetController = TextEditingController();
  final _unitController = TextEditingController();
  final _postalCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: alablaster,
          centerTitle: true,
          title: Text(
            "Registration",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 30,
                letterSpacing: 3),
          ),
          elevation: 0.2,
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text("FirstName:"),
                    TextFormField(
                      decoration: InputDecoration(hintText: "FirstName"),
                      controller: _firstNameController,
                    ),
                    TextFormField(
                      decoration: InputDecoration(hintText: "LastName"),
                      controller: _lastNameController,
                    ),
                    TextFormField(
                      decoration: InputDecoration(hintText: "day"),
                      controller: _dayController,
                    ),
                    TextFormField(
                      decoration: InputDecoration(hintText: "month"),
                      controller: _monthController,
                    ),
                    TextFormField(
                      decoration: InputDecoration(hintText: "year"),
                      controller: _yearController,
                    ),
                    TextFormField(
                      decoration: InputDecoration(hintText: "contactNum"),
                      controller: _contactNumController,
                    ),
                    TextFormField(
                      decoration: InputDecoration(hintText: "street"),
                      controller: _streetController,
                    ),
                    TextFormField(
                      decoration: InputDecoration(hintText: "unit"),
                      controller: _unitController,
                    ),
                    TextFormField(
                      decoration: InputDecoration(hintText: "postalCode"),
                      controller: _postalCodeController,
                    ),
                  ],
                ),
              ),
              RaisedButton(
                onPressed: () {
                  customer = _confirmDetails(uid);
                  db.writeNewCustomer(customer);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      settings: RouteSettings(name: "home"),
                      builder: (context) => HomePage(
                            customer: customer,
                            db: db,
                          )));
                },
                child: Text('confirm'),
              )
            ],
          ),
        ));
  }

  Customer _confirmDetails(String uid) {
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String day = _dayController.text;
    String month = _monthController.text;
    String year = _yearController.text;
    String contactNum = _contactNumController.text;
    String street = _streetController.text;
    String unit = _unitController.text;
    String postalCode = _postalCodeController.text;

    Map address = {"street": street, "unit": unit, "postalCode": postalCode};
    Map dob = {"day": day, "month": month, "year": year};

    Customer customer = new Customer(
        id: uid,
        firstName: firstName,
        lastName: lastName,
        dob: dob,
        contactNum: contactNum,
        address: address);
    customer.createNewCustomer();
    return customer;
  }
}
