import 'package:flutter/material.dart';
import 'package:neutral_creep_dev/models/models.dart';
import 'package:neutral_creep_dev/services/dbService.dart';
import 'package:provider/provider.dart';

import 'components/add_credit_card/components.dart';

class AddNewCreditCardPage extends StatefulWidget {
  AddNewCreditCardPage({Key key}) : super(key: key);

  @override
  _AddNewCreditCardPageState createState() => _AddNewCreditCardPageState();
}

class _AddNewCreditCardPageState extends State<AddNewCreditCardPage> {
  final _nameController = TextEditingController();
  final _cardNumController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _expiryMonthController = TextEditingController();
  final _expiryYearController = TextEditingController();

  String nameError, cardNumError, expiryError, bankNameError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).canvasColor,
            elevation: 0,
            shape: Border(
                bottom: BorderSide(
                    color: Theme.of(context).primaryColor, width: 0.2)),
            leading: IconButton(
                icon: Icon(Icons.arrow_back, size: 35, color: Colors.black),
                onPressed: () => Navigator.pop(context))),
        body: SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height - 98,
              child: Column(children: <Widget>[
                Flexible(
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            AddCreditCardTextFields(
                                title: "Cardholder name",
                                controller: _nameController,
                                error: nameError),
                            SizedBox(height: 10),
                            AddCreditCardTextFields(
                                title: "Card Number",
                                controller: _cardNumController,
                                error: cardNumError),
                            SizedBox(height: 10),
                            AddCreditCardTextFields(
                                title: "bank name",
                                controller: _bankNameController,
                                error: bankNameError),
                            SizedBox(height: 10),
                            ExpiryDateTextField(
                                monthController: _expiryMonthController,
                                yearController: _expiryYearController,
                                errorText: expiryError),
                          ])),
                ),
                AddCardButton(
                    onPressed: () => handleAddCardButtonTapped(context))
              ])),
        ));
  }

  void handleAddCardButtonTapped(BuildContext context) {
    setState(() {
      _nameController.text.isEmpty
          ? nameError = "This field is empty"
          : nameError = null;
      _bankNameController.text.isEmpty
          ? bankNameError = "This field is empty"
          : bankNameError = null;
      cardNumError = checkCardNum(_cardNumController.text);
      expiryError = checkExpiryDate(
          _expiryMonthController.text, _expiryYearController.text);
    });

    if (nameError == null && cardNumError == null && expiryError == null) {
      Map<String, dynamic> creditCard = {
        "fullName": _nameController.text.toString(),
        "cardNum": _cardNumController.text.toString(),
        "expiryMonth": _expiryMonthController.text,
        "expiryYear": _expiryYearController.text,
        "bankName": _bankNameController.text.toString()
      };

      Provider.of<Customer>(context).eWallet.creditCards.add(creditCard);
      DBService().updateCreditCards(Provider.of<Customer>(context));
      Navigator.pop(context);
    }
  }

  String checkExpiryDate(String monthString, String yearString) {
    final DateTime now = DateTime.now();
    if (monthString.isEmpty || yearString.isEmpty) {
      return "please fill up all fields";
    } else {
      int month = int.parse(monthString);
      int year = int.parse(yearString);

      if (year > (now.year + 5)) {
        return "Please enter a valid year";
      }

      if (month > 12 || month < 1) {
        return "Please enter a month";
      }

      if (year < now.year) {
        return "This card is already expired";
      }

      if (year == now.year && month <= now.month) {
        return "This card is already expired";
      }
    }
    return null;
  }

  String checkCardNum(String cardNum) {
    if (cardNum.isEmpty)
      return "This field is empty";
    else if (cardNum.length != 16) {
      print("\n\n\n\n\n${cardNum.length}");
      return "this card number is invalid";
    }

    return null;
  }
}
