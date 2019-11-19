import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';

import '../models/eWallet.dart';
import '../models/customer.dart';

import '../helpers/color_helper.dart';

import '../services/dbService.dart';

class ProfilePage extends StatefulWidget {
  Customer customer;
  DBService db;

  //String bankName;

  ProfilePage({this.customer, this.db});

  _ProfilePageState createState() =>
      _ProfilePageState(customer: customer, db: db);
}

class _ProfilePageState extends State<ProfilePage> {
  Customer customer;
  DBService db;

  // String bankName;
  bool update;

  _ProfilePageState({this.customer, this.db});

  final _formKey = GlobalKey<FormState>();
  List<String> selectableMonths = new List<String>();

  List<String> selectableYear = new List<String>();
  String dropdownValue, newValue;
  String month, year;
  bool visibilityTag = false;
  bool initial = true;
  Map<String, dynamic> credit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    int inityear = DateTime.now().year;
    int add = 0;
    for (int i = 0; i < 30; i++) {
      add = inityear + i;
      String temp2 = add.toString();
      selectableYear.add(temp2);
    }
    for (int i = 1; i <= 12; i++) {
      if (i < 10) {
        selectableMonths.add(i.toString().padLeft(2, "0"));
      } else
        selectableMonths.add(i.toString());
    }
    dropdownValue = "";
    //newValue = bankName;
    update = false;
  }

  @override
  Widget build(BuildContext context) {
    db.addCCIntoCustomer(customer).then((val) {
      customer.eWallet.creditCards = val;
    });

    if (customer.eWallet.creditCards.length > 0)
      visibilityTag = true;
    else
      visibilityTag = false;
    return Scaffold(
      appBar: AppBar(
        //Back button
        automaticallyImplyLeading: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              if (update) db.updateProfile(customer);
              Navigator.pop(context);
            }),
        backgroundColor: alablaster,
        centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 30,
              letterSpacing: 3),
        ),
        elevation: 0.2,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                  /*child: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/testProfilePic.PNG'),
                  radius: 40.0,
                ),*/
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
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
                      backgroundImage:
                          AssetImage('assets/images/testProfilePic.PNG'),
                      radius: 40.0,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                      width: 100,
                      height: 100,
                      child: QrImage(
                        data: customer.id,
                        foregroundColor: heidelbergRed,
                      )),
                ],
              )),
              Divider(
                height: 60.0,
                color: heidelbergRed,
              ),
              Row(
                children: <Widget>[
                  Text('Full Name: ',
                      style: TextStyle(
                        color: Colors.black,
                        letterSpacing: 2.0,
                      )),
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      size: 20,
                    ),
                    color: heidelbergRed,
                    onPressed: () async {
                      updateField(0, context, _formKey, customer).then((val) {
                        update = val;
                      });
                      setState(() {});
                    },
                  )
                ],
              ),
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
              Row(
                children: <Widget>[
                  Text('Address:',
                      style: TextStyle(
                        color: Colors.black,
                        letterSpacing: 2.0,
                      )),
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      size: 20,
                    ),
                    color: heidelbergRed,
                    onPressed: () {
                      updateField(1, context, _formKey, customer).then((val) {
                        update = val;
                      });
                      setState(() {});
                    },
                  )
                ],
              ),
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
              Row(
                children: <Widget>[
                  Text('Contact Number:',
                      style: TextStyle(
                        color: Colors.black,
                        letterSpacing: 2.0,
                      )),
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      size: 20,
                    ),
                    color: heidelbergRed,
                    onPressed: () {
                      updateField(2, context, _formKey, customer).then((val) {
                        update = val;
                      });
                      setState(() {});
                    },
                  )
                ],
              ),
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
                          style: TextStyle(color: heidelbergRed),
                          underline: Container(
                            height: 2,
                            color: heidelbergRed,
                          ),
                          onChanged: (newValue) {
                            setState(() {
                              dropdownValue = newValue;
                            });
                          },
                          hint: Text("Please Select a Card to view"),
                          items: //<String>['One', 'Two', 'Free', 'Four']
                              customer.eWallet.creditCards
                                  .map<DropdownMenuItem<String>>(
                                      (Map<String, dynamic> value) {
                            String x = value["bankName"] +
                                ": XXXX XXXX XXXX " +
                                value["cardNum"].toString().substring(
                                    value["cardNum"].toString().length - 4,
                                    value["cardNum"].toString().length);
                            return DropdownMenuItem<String>(
                              value: x,
                              child: Text(
                                  "${value["bankName"]}: XXXX XXXX XXXX ${value["cardNum"].toString().substring(value["cardNum"].toString().length - 4, value["cardNum"].toString().length)}"),
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
                    await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return MyDialog(
                            db: db,
                            customer: customer,
                            formKey: _formKey,
                            month: month,
                            year: year,
                            selectableYear: selectableYear,
                            selectableMonths: selectableMonths,
                            credit: credit,
                          );
                        });

                    //customer.eWallet.creditCards.add(credit);
                    //customer.eWallet.creditCards.clear();

                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> updateField(
      int val, BuildContext context, formKey, Customer customer) async {
    switch (val) {
      case 0:
        {
          //Name
          await showDialog(
              context: context,
              builder: (BuildContext context) {
                final firstNameController = TextEditingController();
                final lastNameController = TextEditingController();
                return AlertDialog(
                  content: Form(
                    key: formKey,
                    child: Container(
                      height: MediaQuery.of(context).size.height - 600,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Update Name",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Expanded(
                              child: TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please input your first name!';
                                  }
                                  return null;
                                },
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  labelText: "First Name",
                                  prefixIcon: Icon(
                                    Icons.people,
                                    color: heidelbergRed,
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: heidelbergRed, width: 0.0),
                                  ),
                                ),
                                controller: firstNameController,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please input your last name!';
                                  }
                                  return null;
                                },
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  labelText: "Last Name",
                                  prefixIcon: Icon(
                                    Icons.people,
                                    color: heidelbergRed,
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: heidelbergRed, width: 0.0),
                                  ),
                                ),
                                controller: lastNameController,
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width - 90,
                                  child: RaisedButton(
                                    child: Text(
                                      "Submit",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    color: heidelbergRed,
                                    onPressed: () {
                                      if (_formKey.currentState.validate()) {
                                        customer.firstName =
                                            firstNameController.text.toString();
                                        customer.lastName =
                                            lastNameController.text.toString();
                                        _formKey.currentState.save();
                                        Navigator.pop(context);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ]),
                    ),
                  ),
                );
              });
        }
        break;
      case 1:
        {
          //Address
          showDialog(
              context: context,
              builder: (BuildContext context) {
                final unitController = TextEditingController();
                final streetController = TextEditingController();
                final postalCodeController = TextEditingController();

                return AlertDialog(
                  content: Form(
                    key: formKey,
                    child: Container(
                      height: MediaQuery.of(context).size.height - 500,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Update Address",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Expanded(
                              child: TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please input your unit number';
                                  }
                                  return null;
                                },
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  labelText: "Unit",
                                  prefixIcon: Icon(
                                    Icons.home,
                                    color: heidelbergRed,
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: heidelbergRed, width: 0.0),
                                  ),
                                ),
                                controller: unitController,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please input your street';
                                  }
                                  return null;
                                },
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  labelText: "Street",
                                  prefixIcon: Icon(
                                    Icons.home,
                                    color: heidelbergRed,
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: heidelbergRed, width: 0.0),
                                  ),
                                ),
                                controller: streetController,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please input your postal code!';
                                  } else if (value.length != 6) {
                                    return 'Please enter correct postal code!';
                                  }
                                  return null;
                                },
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: "Postal Code",
                                  prefixIcon: Icon(
                                    Icons.location_on,
                                    color: heidelbergRed,
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: heidelbergRed, width: 0.0),
                                  ),
                                ),
                                controller: postalCodeController,
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width - 90,
                                  child: RaisedButton(
                                    child: Text(
                                      "Submit",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    color: heidelbergRed,
                                    onPressed: () {
                                      if (_formKey.currentState.validate()) {
                                        Map address = {
                                          "unit":
                                              unitController.text.toString(),
                                          "street":
                                              streetController.text.toString(),
                                          "postalCode": postalCodeController
                                              .text
                                              .toString()
                                        };
                                        customer.address = address;
                                        _formKey.currentState.save();
                                        Navigator.pop(context);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ]),
                    ),
                  ),
                );
              });
        }
        break;
      case 2:
        {
          //Contact
          showDialog(
              context: context,
              builder: (BuildContext context) {
                final contactNumController = TextEditingController();
                return AlertDialog(
                  content: Form(
                    key: formKey,
                    child: Container(
                      height: MediaQuery.of(context).size.height - 700,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Update Contact Number",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Expanded(
                              child: TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please input contact Number!';
                                  } else if (value.length != 8) {
                                    return 'Please input correct Contact Number!';
                                  }
                                  return null;
                                },
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: "Contact Number",
                                  prefixIcon: Icon(
                                    Icons.call,
                                    color: heidelbergRed,
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: heidelbergRed, width: 0.0),
                                  ),
                                ),
                                controller: contactNumController,
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width - 90,
                                  child: RaisedButton(
                                    child: Text(
                                      "Submit",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    color: heidelbergRed,
                                    onPressed: () {
                                      if (_formKey.currentState.validate()) {
                                        customer.contactNum =
                                            contactNumController.text
                                                .toString();
                                        _formKey.currentState.save();
                                        Navigator.pop(context);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ]),
                    ),
                  ),
                );
              });
        }
        break;
      default:
        {
          Fluttertoast.showToast(msg: "Error: Something has gone wrong...");
        }
    }
    return true;
  }
}

class MyDialog extends StatefulWidget {
  var formKey = GlobalKey<FormState>();
  List<String> selectableMonths = new List<String>();
  String selectedMonth;
  String month;
  String year;

  List<String> selectableYear = new List<String>();
  String selectedYear;
  Map<String, dynamic> credit;

  DBService db;
  Customer customer;

  MyDialog({
    this.db,
    this.customer,
    this.selectableMonths,
    this.month,
    this.year,
    this.formKey,
    this.credit,
    this.selectableYear,
  });

  @override
  _MyDialogState createState() => new _MyDialogState(
      db: db,
      customer: customer,
      year: year,
      month: month,
      selectedYear: selectedYear,
      selectedMonth: selectedMonth);
}

class _MyDialogState extends State<MyDialog> {
  String selectedMonth;
  String selectedYear;
  String month;
  String year;
  DBService db;
  Customer customer;

  _MyDialogState(
      {this.db,
      this.customer,
      this.year,
      this.month,
      this.selectedYear,
      this.selectedMonth});

  final _bankNameController = TextEditingController();
  final _cardNumController = TextEditingController();
  final _fullNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: MediaQuery.of(context).size.height - 450,
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: widget.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                child: Text("Enter CreditCard Details"),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please input name of card!';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Name On Card",
                    prefixIcon: Icon(
                      Icons.person,
                      color: heidelbergRed,
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: heidelbergRed, width: 0.0),
                    ),
                  ),
                  controller: _fullNameController,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please input bank name!';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Bank",
                    prefixIcon: Icon(
                      Icons.attach_money,
                      color: heidelbergRed,
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: heidelbergRed, width: 0.0),
                    ),
                  ),
                  controller: _bankNameController,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please input credit card number!';
                    } else if (value.length != 16)
                      return 'Please input correct card number!';
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Card Number",
                    prefixIcon: Icon(
                      Icons.card_membership,
                      color: heidelbergRed,
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: heidelbergRed, width: 0.0),
                    ),
                  ),
                  controller: _cardNumController,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                child: Row(
                  children: <Widget>[
                    Text("Expiry Date:"),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        validator: (val) {
                          if (val == null) return "*Required";
                          return null;
                        },
                        hint: Text('Month'),
                        value: selectedMonth,
                        onChanged: (newValue) {
                          setState(() {
                            selectedMonth = newValue;
                          });
                        },
                        items: widget.selectableMonths.map((val) {
                          return DropdownMenuItem(
                            child: new Text(val),
                            value: val,
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        validator: (val) {
                          if (val == null) return "*Required";
                          return null;
                        },
                        hint: Text('Year'),
                        value: selectedYear,
                        onChanged: (newValue) {
                          setState(() {
                            selectedYear = newValue;
                          });
                        },
                        items: widget.selectableYear.map((val) {
                          return DropdownMenuItem(
                            child: new Text(val),
                            value: val,
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: RaisedButton(
                      child: Text(
                        "Submit",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      color: heidelbergRed,
                      onPressed: () async {
                        if (widget.formKey.currentState.validate()) {
                          if (selectedMonth != null) month = selectedMonth;
                          if (selectedYear != null) year = selectedYear;
                          widget.credit = {
                            "fullName": _fullNameController.text.toString(),
                            "cardNum": _cardNumController.text.toString(),
                            "expiryMonth": month,
                            "expiryYear": year,
                            "bankName": _bankNameController.text.toString(),
                          };

                          print(widget.credit);
                          widget.formKey.currentState.save();
                          customer.eWallet.creditCards.add(widget.credit);
                          db.updateCreditCards(customer);

                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
