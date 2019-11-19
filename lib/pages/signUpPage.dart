import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../services/dbService.dart';
import '../models/models.dart';
import 'homePage.dart';
import 'components/sign_up/components.dart';
import '../helpers/color_helper.dart';
import 'components/sign_up/logic.dart';

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
  final _contactNumController = TextEditingController();
  final _streetController = TextEditingController();
  final _unitController = TextEditingController();
  final _postalCodeController = TextEditingController();
  DateTime dob;

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
            elevation: 0.2),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      FirstNameTextField(controller: _firstNameController),
                      SizedBox(height: 10),
                      LastNameTextField(controller: _lastNameController),
                      SizedBox(height: 10),
                      DOBButton(onPressed: () => getDOB(), dob: dob),
                      SizedBox(height: 10),
                      ContactNumTextField(controller: _contactNumController),
                      SizedBox(height: 10),
                      StreetTextField(controller: _streetController),
                      SizedBox(height: 10),
                      UnitTextField(controller: _unitController),
                      SizedBox(height: 10),
                      PostalCodeTextField(controller: _postalCodeController),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    if (validateFn()) {
                      handleValidForm(context);
                    } else {
                      setState(() {});
                      Fluttertoast.showToast(
                          msg: "Please fill in the missing fields!");
                    }
                  },
                  child: Text('confirm'),
                )
              ],
            ),
          ),
        ));
  }

  void handleValidForm(BuildContext context) {
    customer = confirmDetails();
    db.writeNewCustomer(customer);
    Fluttertoast.showToast(msg: "You have signed up successfully!");
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        settings: RouteSettings(name: "home"),
        builder: (context) => HomePage(customer: customer, db: db)));
  }

  Customer confirmDetails() {
    return SignUpLogic.confirmDetails(
      uid: uid,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      dateOfBirth: dob,
      street: _streetController.text,
      unit: _unitController.text,
      postalCode: _postalCodeController.text,
      contactNum: _contactNumController.text,
    );
  }

  void getDOB() {
    int x = DateTime.now().year - 80;
    int y = DateTime.now().year - 18;
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(x, 12, 31),
        maxTime: DateTime(y, 01, 01), onConfirm: (date) {
      setState(() {
        dob = date;
      });
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  bool validateFn() {
    return SignUpLogic.validateForm(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      dob: dob,
      street: _streetController.text,
      unit: _unitController.text,
      postalCode: _postalCodeController.text,
      contactNum: _contactNumController.text,
    );
  }
}
