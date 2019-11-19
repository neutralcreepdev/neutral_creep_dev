import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neutral_creep_dev/helpers/color_helper.dart';

import '../../../services/authService.dart';
import '../../../services/dbService.dart';
import '../../homePage.dart';
import '../../signUpPage.dart';
import 'widgets/loading_dialog.dart';

class LoginSignUpButton extends StatelessWidget {
  final bool isSignUp;
  final GlobalKey<FormState> formKey;
  final String email, password;
  final AuthService authService;
  final DBService dbService;
  final Function onChange;
  final bool isRememberMe;

  const LoginSignUpButton({
    Key key,
    this.isSignUp,
    this.formKey,
    this.email,
    this.password,
    this.authService,
    this.dbService,
    this.onChange,
    this.isRememberMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: 70,
      minWidth: 250,
      child: RaisedButton(
        color: heidelbergRed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
        child: Text(
          isSignUp ? "SIGN UP" : "LOGIN",
          style: TextStyle(
              fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        onPressed: () async {
          bool x = true;
          if (formKey.currentState.validate()) {
            if (isSignUp) {
              x = await signUpDialog(context, x);
            } else {
              x = await loginDialog(context, x);
              if (x == false) {
                errorDialog(context);
              }
            }
          }
        },
      ),
    );
  }

  void errorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Error"),
          content: new Text("Incorrect Login Details"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
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

  Future<bool> loginDialog(BuildContext context, bool x) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          Future<FirebaseUser> user;

          user.then((userValue) {
            dbService.getCustomerData(userValue.uid).then((customer) {
              onChange(isRememberMe);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      settings: RouteSettings(name: "home"),
                      builder: (context) => HomePage(
                            customer: customer,
                            db: dbService,
                          )));
            });
          }).catchError((error, stackTrace) {
            Navigator.pop(context);
            x = false;
          });
          return LoadingDialog(isLoading: x);
        });
    return x;
  }

  Future<bool> signUpDialog(BuildContext context, bool x) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          Future<FirebaseUser> user = authService.handleSignUp(email, password);
          user.then((userValue) {
            userValue != null
                ? signUpSuccess(context, userValue)
                : signUpFail(context);
          }).catchError((onError, stacktrace) {
            print("ERROR! => $stacktrace");
            Navigator.pop(context);
            x = false;
          });
          return LoadingDialog(isLoading: x);
        });
    return x;
  }

  void signUpFail(BuildContext context) {
    Navigator.of(context).pop();
    Fluttertoast.showToast(
        msg: "Email is already in use!", toastLength: Toast.LENGTH_LONG);
  }

  void signUpSuccess(BuildContext context, FirebaseUser user) {
    Firestore.instance
        .collection("users")
        .document("${user.uid}")
        .setData({"id": user.uid, "lastLoggedIn": DateTime.now()});

    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => SignUpPage(uid: user.uid, db: dbService)));
  }
}
