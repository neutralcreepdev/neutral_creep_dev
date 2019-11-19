import 'package:flutter/material.dart';
import 'package:neutral_creep_dev/models/customer.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  final _contactNumController = TextEditingController();
  final _streetController = TextEditingController();
  final _unitController = TextEditingController();
  final _postalCodeController = TextEditingController();
  DateTime dob;
  bool initial=true;

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
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(8.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          hintText: "First Name",
                          errorText: _validateField(_firstNameController.text) ? null: 'Please input your first name!',
                        ),
                        controller: _firstNameController,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(8.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          hintText: "Last Name",
                          errorText: _validateField(_lastNameController.text) ? null: 'Please input your last name!',

                        ),
                        controller: _lastNameController,


                      ),
                      SizedBox(height: 10),
                      RaisedButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                            side: BorderSide(color: Colors.grey)),
                          onPressed: () {

                          int x = DateTime.now().year-80;
                          int y = DateTime.now().year-18;
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: DateTime(x, 12, 31),
                                maxTime: DateTime(y, 01, 01),
                                onConfirm: (date) {
                              dob = date;
                              setState(() {});
                            },
                                currentTime: DateTime.now(),
                                locale: LocaleType.en);
                          },
                          child: (dob.toString()=="null")
                              ? Text(
                                  'Select Your Date of Birth',
                                  style: TextStyle(
                                      fontSize: 18),
                                )
                              : Text(
                                  '${dob.toString().substring(0,10)}',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.blue),
                                )
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(8.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          hintText: "Contact Number",
                          errorText: _validateCN(_contactNumController.text),
                        ),
                        keyboardType: TextInputType.number,
                        controller: _contactNumController,

                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(8.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          hintText: "Street",
                          errorText: _validateField(_streetController.text) ? null: 'Please input your street!',
                        ),
                        controller: _streetController,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(8.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          hintText: "Unit",
                          errorText: _validateField(_unitController.text) ? null: 'Please input your unit!',
                        ),
                        controller: _unitController,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(8.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          hintText: "Postal Code",
                          errorText: _validatePC(_postalCodeController.text),
                        ),
                        controller: _postalCodeController,
                          keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    if(validateFn()) {
                      customer = _confirmDetails(uid, dob);
                      db.writeNewCustomer(customer);
                      Fluttertoast.showToast(msg: "You have signed up successfully!");
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          settings: RouteSettings(name: "home"),
                          builder: (context) => HomePage(
                            customer: customer,
                            db: db,
                          )));
                    }else{
                      Fluttertoast.showToast(msg: "Please fill in the missing fields!");
                      setState(() {
                      });
                    }
                  },
                  child: Text('confirm'),
                )
              ],
            ),
          ),
        ));
  }

  Customer _confirmDetails(String uid, DateTime dateOfBirth) {
    Customer customer;
      String firstName = _firstNameController.text;
      String lastName = _lastNameController.text;
      String day = dateOfBirth.toString().substring(8,10);
      String month = dateOfBirth.toString().substring(5,7);
      String year = dateOfBirth.toString().substring(0,4);
      String contactNum = _contactNumController.text;
      String street = _streetController.text;
      String unit = _unitController.text;
      String postalCode = _postalCodeController.text;

      Map address = {"street": street, "unit": unit, "postalCode": postalCode};
      Map dob = {"day": day, "month": month, "year": year};

      customer = new Customer(
          id: uid,
          firstName: firstName,
          lastName: lastName,
          dob: dob,
          contactNum: contactNum,
          address: address);
      customer.createNewCustomer();

    return customer;
  }

  bool _validateField(String temp) {
    if(!initial) {
      if (temp.isEmpty) {
        return false;
      } else
        return true;
    } else {
      return true;
    }
  }

  String _validateCN(String CN) {
    if(!initial) {
      if (CN.isEmpty)
        return "Please input your contact number!";
      if (CN.length != 8)
        return "Please enter 8 digits for your contact number!";
    }
    return null;
  }

  String _validatePC(String PC) {
    if(!initial) {
      if (PC.isEmpty)
        return "Please input your postal code!";
      if (PC.length != 6)
        return "Please enter 6 digits for your postal code!";
    }
    return null;
  }


  bool validateFn(){
    bool temp=true;
    if(_firstNameController.text.isEmpty || _lastNameController.text.isEmpty || dob.toString()=="null" || _contactNumController.text.isEmpty
    || _streetController.text.isEmpty || _unitController.text.isEmpty || _contactNumController.text.length!=8 || _postalCodeController.text.length!=6)
      temp=false;
    initial=false;
    return temp;
  }
}
