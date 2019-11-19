import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:neutral_creep_dev/models/models.dart';
import 'package:neutral_creep_dev/services/authService.dart';
import 'package:neutral_creep_dev/services/dbService.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encPkg;

import 'loading_dialog.dart';

class LoginPageLogic {
  static final key = encPkg.Key.fromUtf8('CSIT-321 FYPQRCODEORDERINGSYSTEM');
  static final iv = encPkg.IV.fromLength(16);
  static final enc = encPkg.Encrypter(encPkg.AES(key));
  static SharedPreferences _sp;

  static final RegExp emailRegExp = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

  static final DBService _dbService = DBService();

  // login dialogs ========================================================================

  static Future<Customer> googlelogin(BuildContext context) async {
    Customer customer;
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          Provider.of<AuthService>(context).checkAccount().then((val) {
            Future<FirebaseUser> user =
                Provider.of<AuthService>(context).signInWithGoogle();
            user.then((userValue) async {
              if (val == false) {
                await Firestore.instance
                    .collection("users")
                    .document("${userValue.uid}")
                    .setData(
                        {"id": userValue.uid, "lastLoggedIn": DateTime.now()});
                customer = Customer(id: userValue.uid);
                Navigator.pop(context);
              } else {
                _dbService.getCustomerData(userValue.uid).then((customerData) {
                  customer = customerData;
                  Navigator.pop(context);
                });
              }
            });
          }).catchError((onError, stacktrace) => Navigator.pop(context));
          return LoadingDialog();
        });

    return customer;
  }

  static Future<Customer> facebooklogin(BuildContext context) async {
    Customer customer;
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          Provider.of<AuthService>(context).FBcheckAccount().then((val) {
            Future<FirebaseUser> user =
                Provider.of<AuthService>(context).signInWithFb();

            user.then((userValue) async {
              if (val == false) {
                await Firestore.instance
                    .collection("users")
                    .document("${userValue.uid}")
                    .setData(
                        {"id": userValue.uid, "lastLoggedIn": DateTime.now()});
                customer = null;
                Navigator.pop(context);
              } else {
                _dbService
                    .getCustomerData(userValue.uid)
                    .then((customerData) => customer = customerData);
              }
              Navigator.pop(context);
            });
          }).catchError((onError, stacktrace) => Navigator.pop(context));

          return LoadingDialog();
        });

    return customer;
  }

  static Future<Customer> loginDialog(
      BuildContext context, String email, String password) async {
    Customer customer;
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          Future<FirebaseUser> user = Provider.of<AuthService>(context)
              .emailSignIn(email: email, password: password);

          user.then((userValue) async {
            await _dbService
                .getCustomerData(userValue.uid)
                .then((customerData) {
              customer = customerData;
            });
            Navigator.pop(context);
          }).catchError((error, stackTrace) {
            Navigator.pop(context);
            customer = null;
          });
          return LoadingDialog();
        });
    return customer;
  }

  static void errorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Error"),
          content: new Text("Incorrect Login Details"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Validators ========================================================================

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
    return "";
  }

  static String validateEmail(String email) {
    if (email.isEmpty)
      return "This field is blank";
    else if (!emailRegExp.hasMatch(email)) return "Please enter valid email!";
    return "";
  }

  // Shared preference ========================================================================

  static Future<void> savePreferences(String email, String password) async {
    _sp = await SharedPreferences.getInstance();
    if (email != "" && password != "") {
      final emailEnc = enc.encrypt(email, iv: iv);
      final passwordEnc = enc.encrypt(password, iv: iv);
      _sp.setBool("rememberMe", true);
      _sp.setString("email", emailEnc.base64);
      _sp.setString("password", passwordEnc.base64);
    }
  }

  static Future<void> clearPreferences() async {
    _sp = await SharedPreferences.getInstance();
    _sp.clear();
    _sp.setBool("rememberMe", false);
  }

  static Future<bool> getEmailPassword(TextEditingController emailController,
      TextEditingController passwordController) async {
    _sp = await SharedPreferences.getInstance();
    bool rememberMe = _sp.getBool("rememberMe") ?? false;

    if (rememberMe) {
      String email = enc.decrypt64(_sp.getString("email"), iv: iv);
      String password = enc.decrypt64(_sp.getString("password"), iv: iv);
      emailController.text = email;
      passwordController.text = password;
    } else {
      emailController.clear();
      passwordController.clear();
    }

    return rememberMe;
  }
}
