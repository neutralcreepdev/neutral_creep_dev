import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../services/authService.dart';
import '../../../../services/dbService.dart';
import '../../../homePage.dart';
import '../../../signUpPage.dart';

class GoogleButton extends StatelessWidget {
  final AuthService authService;
  final DBService dbService;
  const GoogleButton({Key key, this.authService, this.dbService})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
        onPressed: () async {
          bool x = true;
          await showDialog(
              context: context,
              builder: (BuildContext context) {
                authService.checkAccount().then((val) {
                  Future<FirebaseUser> user = authService.signInWithGoogle();
                  user.then((userValue) {
                    if (val == false) {
                      Firestore.instance
                          .collection("users")
                          .document("${userValue.uid}")
                          .setData({
                        "id": userValue.uid,
                        "lastLoggedIn": DateTime.now()
                      });

                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) =>
                              SignUpPage(uid: userValue.uid, db: dbService)));
                    } else {
                      dbService.getCustomerData(userValue.uid).then((customer) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                settings: RouteSettings(name: "home"),
                                builder: (context) => HomePage(
                                      customer: customer,
                                      db: dbService,
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
    );
  }
}
