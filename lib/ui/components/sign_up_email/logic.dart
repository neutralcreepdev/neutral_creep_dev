import 'package:flutter/material.dart';
import 'package:neutral_creep_dev/models/models.dart';
import 'package:neutral_creep_dev/services/authService.dart';
import 'package:neutral_creep_dev/services/dbService.dart';
import 'package:provider/provider.dart';

import 'loading_dialog.dart';

class SignUpLogic {
  static final RegExp emailRegExp = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

  static final DBService _dbService = DBService();

  static Future<bool> handleSignUpNewUser(
      BuildContext context, String email, String password) async {
    bool isSuccessful;
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          Provider.of<AuthService>(context)
              .handleSignUp(email, password)
              .then((user) {
            List<Map<String, dynamic>> creditCards =
                List<Map<String, dynamic>>();
            Provider.of<Customer>(context).id = user.uid;
            EWallet eWallet =
                EWallet(eCreadits: 0, points: 0, creditCards: creditCards);
            Provider.of<Customer>(context).eWallet = eWallet;
            Provider.of<Customer>(context).currentCart = Cart();
            _dbService.writeNewCustomer(Provider.of<Customer>(context));

            Navigator.pop(context);
            isSuccessful = true;
          }).catchError((error, stackTrace) {
            Navigator.pop(context);
            isSuccessful = false;
          });

          return LoadingDialog();
        });
    return isSuccessful;
  }

  static void errorDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: new Text(
                "Error",
                style: TextStyle(color: Colors.redAccent),
              ),
              content: new Text("This email has been used before"),
              actions: <Widget>[
                new FlatButton(
                    child: new Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ]);
        });
  }

  static String validateConfirmPassword(
      String password, String confirmPassword) {
    if (confirmPassword.isEmpty)
      return "This field is blank";
    else if (!(confirmPassword == password))
      return "Both password fields doesn't match";
    else
      return null;
  }

  static bool validatePWStructure(String password) {
    String patt =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~.,*%^]).{8,}$';
    RegExp createRegExp = new RegExp(patt);
    return createRegExp.hasMatch(password);
  }

  static String validatePassword(String password) {
    if (password.isEmpty)
      return "This field is blank";
    else if (password.length < 8)
      return "Password needs to be at least 8 character long";
    else if (validatePWStructure(password) == false)
      return "Password must include at least 1 lowercase\nand uppercase alphabet, digit and symbol";
    return null;
  }

  static String validateEmail(String email) {
    if (email.isEmpty)
      return "This field is blank";
    else if (!emailRegExp.hasMatch(email)) return "Please enter valid email!";
    return null;
  }
}
