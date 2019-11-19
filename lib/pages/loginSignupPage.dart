import 'dart:ffi';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:neutral_creep_dev/models/customer.dart';
import 'package:neutral_creep_dev/pages/signUpPage.dart';

import '../helpers/color_helper.dart';

import '../services/authService.dart';
import '../services/dbService.dart';

import './homePage.dart';

class LoginSignUpPage extends StatefulWidget {
  _LoginSignUpPageState createState() => _LoginSignUpPageState();
}

class _LoginSignUpPageState extends State<LoginSignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _form2 = GlobalKey<FormState>();
  final _passKey = GlobalKey<FormFieldState>();
  final _auth = AuthService();
  final _db = DBService();
  var isSignUp = true;
  bool googleStuff = false;
  bool facebookStuff = false;
  var isRememberMe = false;
  String _email, _password;

  Container buildLoginSignUpButtonContainer() {
    return Container(
      width: double.infinity,
      //color: Colors.yellow,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              child: Text(
                "LOGIN",
                style: TextStyle(
                    color: isSignUp
                        ? heidelbergRed.withOpacity(0.5)
                        : heidelbergRed,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                setState(() {
                  isSignUp = false;
                });
              },
            ),
            SizedBox(
              width: 10,
            ),
            FlatButton(
              child: Text(
                "SIGN UP",
                style: TextStyle(
                    color: isSignUp
                        ? heidelbergRed
                        : heidelbergRed.withOpacity(0.5),
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                setState(() {
                  isSignUp = true;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Container buildTermsAndConditionContainer() {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            "By pressing \"SIGN UP\" you are agreeing to our",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text("Terms & Conditions",
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold))
        ],
      ),
    );
  }

  Container buildRememberMeAndForgetPassContainer() {
    return Container(
      padding: EdgeInsets.only(left: 30, right: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            onTap: () {
              setState(() {
                if (isRememberMe) {
                  isRememberMe = false;
                } else {
                  isRememberMe = true;
                }
              });
            },
            child: Container(
                child: Row(
              children: <Widget>[
                isRememberMe
                    ? Icon(Icons.check_box)
                    : Icon(Icons.check_box_outline_blank),
                Text("Remember Me",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            )),
          ),
          GestureDetector(
            onTap: () async {
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  final _textController = TextEditingController();
                  final _textController2 = TextEditingController();
                  return AlertDialog(
                    title: Text("Reset Password"),
                    content: Form(
                      key: _form2,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Enter email to reset password"),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width - 100,
                              child: TextFormField(
                                controller: _textController,
                                validator: (val) {
                                  if (val.isEmpty)
                                    return "Please enter email";
                                  else if (!val.contains("@."))
                                    return "Please enter valid email!";
                                  return null;
                                },
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: heidelbergRed,
                                  ),
                                  hintText: "Enter email",
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: heidelbergRed, width: 0.0),
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                textAlign: TextAlign.center,
                                textInputAction: TextInputAction.done,
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width - 100,
                              child: TextFormField(
                                controller: _textController2,
                                validator: (val) {
                                  if (val.isEmpty)
                                    return "Please enter confirmation email";
                                  else if (!val.contains("@."))
                                    return "Please enter valid email!";
                                  else if (_textController.text.toString() !=
                                      val) {
                                    return "Please enter the same email as above";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: heidelbergRed,
                                  ),
                                  hintText: "Re-enter email",
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: heidelbergRed, width: 0.0),
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                textAlign: TextAlign.center,
                                textInputAction: TextInputAction.done,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    actions: <Widget>[
                      // usually buttons at the bottom of the dialog
                      FlatButton(
                        child: new Text("Confirm"),
                        onPressed: () {
                          if (_form2.currentState.validate()) {
                            _form2.currentState.save();
                            _auth
                                .resetPassword(_textController.text.toString());
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                      FlatButton(
                        child: new Text("Cancel"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: Text(
              "Forget Password?",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  Align buildSocialSignUpContainer() {
    return Align(
      alignment: Alignment(0, 0.9),
      child: Container(
        padding: EdgeInsets.only(left: 30, right: 30),
        height: 100,
        width: 400,
        child: Column(
          children: <Widget>[
            Text(
              "connect with:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ButtonTheme(
                  height: 40,
                  minWidth: 150,
                  child: RaisedButton(
                    color: Colors.blue,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.facebookF,
                          color: Colors.white,
                        ),
                        SizedBox(width: 20),
                        Text("Facebook",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20))
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35)),
                    onPressed: () async {
                      bool x = true;
                      await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            _auth.FBcheckAccount().then((val) {
                              facebookStuff = val;
                              print(facebookStuff);
                              Future<FirebaseUser> user = _auth.signInWithFb();
                              user.then((userValue) {
                                if (facebookStuff == false) {
                                  Firestore.instance
                                      .collection("users")
                                      .document("${userValue.uid}")
                                      .setData({
                                    "id": userValue.uid,
                                    "lastLoggedIn": DateTime.now()
                                  });

                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => SignUpPage(
                                              uid: userValue.uid, db: _db)));
                                } else {
                                  _db
                                      .getCustomerData(userValue.uid)
                                      .then((customer) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            settings:
                                                RouteSettings(name: "home"),
                                            builder: (context) => HomePage(
                                                  customer: customer,
                                                  db: _db,
                                                )));
                                  });
                                }
                              });
                            }).catchError((onError, stacktrace) {
                              print(stacktrace);
                              Navigator.pop(context);
                              x = false;
                            });
                            return Dialog(
                                backgroundColor: Colors.transparent,
                                child: x
                                    ? SpinKitRotatingCircle(
                                        color: Colors.white,
                                        size: 50.0,
                                      )
                                    : Text("lame"));
                          });
                    },
                  ),
                ),
                ButtonTheme(
                  height: 40,
                  minWidth: 150,
                  child: RaisedButton(
                    color: Colors.orangeAccent,
                    child: Row(
                      children: <Widget>[
                        Icon(FontAwesomeIcons.google, color: Colors.white),
                        SizedBox(width: 20),
                        Text("Google",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20))
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35)),
                    onPressed: () async {
                      bool x = true;
                      await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            _auth.checkAccount().then((val) {
                              googleStuff = val;
                              print(googleStuff);
                              Future<FirebaseUser> user =
                                  _auth.signInWithGoogle();
                              user.then((userValue) {
                                if (googleStuff == false) {
                                  Firestore.instance
                                      .collection("users")
                                      .document("${userValue.uid}")
                                      .setData({
                                    "id": userValue.uid,
                                    "lastLoggedIn": DateTime.now()
                                  });

                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => SignUpPage(
                                              uid: userValue.uid, db: _db)));
                                } else {
                                  _db
                                      .getCustomerData(userValue.uid)
                                      .then((customer) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            settings:
                                                RouteSettings(name: "home"),
                                            builder: (context) => HomePage(
                                                  customer: customer,
                                                  db: _db,
                                                )));
                                  });
                                }
                              });
                            }).catchError((onError, stacktrace) {
                              print(stacktrace);
                              Navigator.pop(context);
                              x = false;
                            });
                            return Dialog(
                                backgroundColor: Colors.transparent,
                                child: x
                                    ? SpinKitRotatingCircle(
                                        color: Colors.white,
                                        size: 50.0,
                                      )
                                    : Text("lame"));
                          });
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  bool validatePWStructure(String password) {
    String patt =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~.,*%^]).{8,}$';
    RegExp createRegExp = new RegExp(patt);
    return createRegExp.hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/startPageBG.jpg"),
                fit: BoxFit.fitHeight)),
        child: Stack(
          children: <Widget>[
            //  title text ====================================
            Align(
                alignment: Alignment(0, -0.8),
                child: Text(
                  "NEUTRAL CREEP",
                  style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
                )),

            //  login signup container ====================================
            Center(
              child: Form(
                key: _formKey,
                child: Container(
                  width: MediaQuery.of(context).size.width - 60,
                  height: 500,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      color: alablaster),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      //  login signup button container ====================================
                      buildLoginSignUpButtonContainer(),

                      //  form container ====================================
                      Container(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Column(
                            children: <Widget>[
                              //  Email text form ====================================
                              TextFormField(
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: "EMAIL",
                                ),
                                onSaved: (emailInput) => _email = emailInput,
                                validator: (emailInput) {
                                  if (emailInput.isEmpty) {
                                    return "This field is blank";
                                  }
                                  /* bool checkEmail = RegExp(
                                          r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(emailInput);
                                  if (checkEmail == false)
                                    return "Please enter a valid email";*/
                                  return null;
                                },
                              ),

                              //  password text form ====================================
                              SizedBox(height: 10),
                              TextFormField(
                                key: _passKey,
                                obscureText: true,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  hintText: "PASSWORD",
                                ),
                                onSaved: (passwordInput) =>
                                    _password = passwordInput,
                                validator: (passwordInput) {
                                  if (passwordInput.isEmpty) {
                                    return "This field is blank";
                                  }
                                  if (passwordInput.length != 8) {
                                    return "Please enter a 8 alphanumeric password";
                                  }
                                  if (validatePWStructure(passwordInput) ==
                                      false)
                                    return "Password must include at least 1 lowercase\nand uppercase alphabet, digit and symbol";
                                  return null;
                                },
                              ),

                              //  confirm password text form ====================================
                              SizedBox(height: 10),
                              isSignUp
                                  ? TextFormField(
                                      obscureText: true,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        hintText: "CONFIRMED PASSWORD",
                                      ),
                                      validator: (confirmPasswordInput) {
                                        if (confirmPasswordInput.isEmpty) {
                                          return "This field is blank";
                                        }

                                        if (confirmPasswordInput !=
                                            _passKey.currentState.value) {
                                          return "Confirm Password should match password";
                                        }
                                        return null;
                                      },
                                    )
                                  : Container(),
                            ],
                          )),

                      //  button and terms and condition container ====================================
                      Container(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: <Widget>[
                            isSignUp
                                ? buildTermsAndConditionContainer()
                                : buildRememberMeAndForgetPassContainer(),

                            //  login sign up button ====================================
                            SizedBox(height: 15),
                            ButtonTheme(
                              height: 70,
                              minWidth: 250,
                              child: RaisedButton(
                                color: heidelbergRed,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(35)),
                                child: Text(
                                  isSignUp ? "SIGN UP" : "LOGIN",
                                  style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                onPressed: () async {
                                  bool x = true;
                                  if (_formKey.currentState.validate()) {
                                    _formKey.currentState.save();
                                    if (isSignUp) {
                                      await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            Future<FirebaseUser> user =
                                                _auth.handleSignUp(
                                                    _email, _password);
                                            user.then((userValue) {
                                              if (userValue != null) {
                                                Firestore.instance
                                                    .collection("users")
                                                    .document(
                                                        "${userValue.uid}")
                                                    .setData({
                                                  "id": userValue.uid,
                                                  "lastLoggedIn": DateTime.now()
                                                });

                                                Navigator.of(context)
                                                    .pushReplacement(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                SignUpPage(
                                                                    uid: userValue
                                                                        .uid,
                                                                    db: _db)));
                                              } else {
                                                Navigator.of(context).pop();
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Email is already in use!", toastLength: Toast.LENGTH_LONG);
                                              }
                                            }).catchError(
                                                (onError, stacktrace) {
                                              print(stacktrace);
                                              Navigator.pop(context);
                                              x = false;
                                            });
                                            return Dialog(
                                                backgroundColor:
                                                    Colors.transparent,
                                                child: x
                                                    ? SpinKitRotatingCircle(
                                                        color: Colors.white,
                                                        size: 50.0,
                                                      )
                                                    : Text("lame"));
                                          });
                                    } else {
                                      Future<FirebaseUser> user;

                                      await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            user = _auth.handleEmailSignIn(
                                                _email, _password, context);
                                            user.then((userValue) {
                                              _db
                                                  .getCustomerData(
                                                      userValue.uid)
                                                  .then((customer) {
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        settings: RouteSettings(
                                                            name: "home"),
                                                        builder: (context) =>
                                                            HomePage(
                                                              customer:
                                                                  customer,
                                                              db: _db,
                                                            )));
                                              });
                                              /*Navigator.of(context)
                                                    .pushReplacement(
                                                        MaterialPageRoute(
                                                            settings:
                                                                RouteSettings(
                                                                    name:
                                                                        "home"),
                                                            builder:
                                                                (context) =>
                                                                    HomePage(
                                                                      customer:
                                                                          customer,
                                                                      db: _db,
                                                                    )));
                                              });*/
                                            }).catchError((error, stackTrace) {
                                              Navigator.pop(context);
                                              x = false;
                                            });
                                            return Dialog(
                                                backgroundColor:
                                                    Colors.transparent,
                                                child: x
                                                    ? SpinKitRotatingCircle(
                                                        color: Colors.white,
                                                        size: 50.0,
                                                      )
                                                    : Text("lame"));
                                          });
                                      if (x == false) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            // return object of type Dialog
                                            return AlertDialog(
                                              title: new Text("Error"),
                                              content: new Text(
                                                  "Incorrect Login Details"),
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
                                    }
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            //  facebook and google signup/login container ====================================
            buildSocialSignUpContainer()
          ],
        ),
      ),
    );
  }
}
