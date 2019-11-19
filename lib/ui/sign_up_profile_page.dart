import 'package:flutter/material.dart';
import 'package:neutral_creep_dev/models/models.dart';
import 'package:neutral_creep_dev/services/dbService.dart';
import 'package:neutral_creep_dev/ui/on_boarding_page.dart';
import 'package:neutral_creep_dev/ui/sign_up_email_page.dart';
import 'package:provider/provider.dart';

import 'components/sign_up_profile/components.dart';

class SignUpProfilePage extends StatefulWidget {
  final bool isUsingSocial;
  SignUpProfilePage({Key key, this.isUsingSocial}) : super(key: key);

  @override
  _SignUpProfilePageState createState() => _SignUpProfilePageState();
}

class _SignUpProfilePageState extends State<SignUpProfilePage> {
  void onBackArrowPressed(BuildContext context) => Navigator.pop(context);

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _unitLevelController = TextEditingController();
  final _streetController = TextEditingController();
  final _unitNumController = TextEditingController();
  final _blkNumController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _phoneNumController = TextEditingController();

  String firstNameError,
      lastNameError,
      streetError,
      unitLevelError,
      unitNumError,
      blockNumError,
      postalCodeError,
      phoneNumError;

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
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).backgroundColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                form(context),
                ConfirmProfileButton(onPressed: () => validateForm(context))
              ],
            ),
          ),
        ));
  }

  void validateForm(BuildContext context) async {
    final String empty = "This field is empty";
    setState(() {
      firstNameError = _firstNameController.text.isEmpty ? empty : null;
      lastNameError = _lastNameController.text.isEmpty ? empty : null;
      streetError = _streetController.text.isEmpty ? empty : null;
      blockNumError = _blkNumController.text.isEmpty ? empty : null;

      unitNumError = _unitNumController.text.isEmpty ? "Empty" : null;
      unitLevelError = _unitLevelController.text.isEmpty ? "Empty" : null;

      if (_postalCodeController.text.isEmpty)
        postalCodeError = empty;
      else if (_postalCodeController.text.length != 6)
        postalCodeError = "Invalid postal code";
      else
        postalCodeError = null;

      if (_phoneNumController.text.isEmpty) phoneNumError = empty;
      if (_phoneNumController.text.length != 8)
        phoneNumError = "Invalide phone number";
      else
        phoneNumError = null;
    });

    if (firstNameError == null &&
        lastNameError == null &&
        streetError == null &&
        blockNumError == null &&
        unitLevelError == null &&
        unitNumError == null &&
        postalCodeError == null &&
        phoneNumError == null) {
      SignUpProfileLogic.updateCustomer(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          street: _streetController.text,
          blockNum: _blkNumController.text,
          unitLevel: _unitLevelController.text,
          unitNum: _unitNumController.text,
          postalCode: _postalCodeController.text,
          phoneNum: _phoneNumController.text,
          context: context);

      if (!widget.isUsingSocial) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => SignUpEmailPage()));
      } else {
        await DBService().updateProfile(Provider.of<Customer>(context));
        List<Map<String, dynamic>> creditCard = List<Map<String, dynamic>>();
        Provider.of<Customer>(context).eWallet =
            EWallet(eCreadits: 0, points: 0, creditCards: creditCard);
        Provider.of<Customer>(context).currentCart = Cart();

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => OnBoardingPage()));
      }
    }
  }

  Container form(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(30, 30, 30, 20),
        width: double.infinity,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Sign Up", style: Theme.of(context).textTheme.title),
              SizedBox(height: 15),
              Text("Profile Details:",
                  style: TextStyle(
                      fontSize: 20, decoration: TextDecoration.underline)),
              SizedBox(height: 20),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SignUpProfileTextFields(
                      title: "first name",
                      error: firstNameError,
                      keyboardType: TextInputType.text,
                      width: (MediaQuery.of(context).size.width / 2) - 50,
                      controller: _firstNameController,
                    ),
                    SignUpProfileTextFields(
                      title: "last name",
                      error: lastNameError,
                      keyboardType: TextInputType.text,
                      width: (MediaQuery.of(context).size.width / 2) - 50,
                      controller: _lastNameController,
                    ),
                  ]),
              SizedBox(height: 5),
              SignUpProfileTextFields(
                title: "street",
                keyboardType: TextInputType.text,
                error: streetError,
                width: double.infinity,
                controller: _streetController,
              ),
              SizedBox(height: 5),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SignUpProfileTextFields(
                        title: "Block No.",
                        keyboardType: TextInputType.number,
                        error: blockNumError,
                        width: (MediaQuery.of(context).size.width / 2) - 50,
                        controller: _blkNumController),
                    UnitNumTextField(
                      title: "unit no.",
                      width: (MediaQuery.of(context).size.width / 2) - 5,
                      levelController: _unitLevelController,
                      unitController: _unitNumController,
                      levelError: unitLevelError,
                      unitError: unitNumError,
                    )
                  ]),
              SizedBox(height: 5),
              SignUpProfileTextFields(
                title: "postal code",
                keyboardType: TextInputType.number,
                error: postalCodeError,
                width: double.infinity,
                controller: _postalCodeController,
              ),
              SizedBox(height: 5),
              SignUpProfileTextFields(
                title: "phone no.",
                keyboardType: TextInputType.number,
                error: phoneNumError,
                width: double.infinity,
                controller: _phoneNumController,
              )
            ]));
  }
}
