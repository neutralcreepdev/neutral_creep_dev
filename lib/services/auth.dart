//import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool checkUserExist() {
    if (_auth.currentUser() == null) {
      print("no user");
      return false;
    } else {
      print(_auth.currentUser().toString());
      return true;
    }
  }

  void handleUserSignUp(String email, String password) {
    Future<FirebaseUser> user = _handleSignUp(email, password);
    user.then((userValue) {
      Firestore.instance.collection("users").document(userValue.uid).setData({
        "uid": userValue.uid,
      });
    });
  }

  Future<FirebaseUser> _handleSignUp(String email, String password) async {
    final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    return user;
  }

  Future<FirebaseUser> handleEmailSignIn(String email, String password) async {
    final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    ))
        .user;

    return user;
  }

  Future<FirebaseUser> handleGoogleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    return user;
  }
}
