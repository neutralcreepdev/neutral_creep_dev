import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void logout() {
    _auth.signOut();
  }

  Future<FirebaseUser> getCurrentUser() async {
    return await _auth.currentUser();
  }

  bool checkUserExist() {
    if (_auth.currentUser() == null) {
      print("no user");
      return false;
    } else {
      print(_auth.currentUser().toString());
      return true;
    }
  }

  Future<FirebaseUser> handleSignUp(String email, String password) async {
   try {
     final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
         email: email, password: password))
         .user;
     return user;
   }catch(exception){
     return null;
   }
  }

  void initiateFacebookLogin() async {
    var facebookLogin = FacebookLogin();
    var result = await facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.error:
        print("Error");
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");
        break;
      case FacebookLoginStatus.loggedIn:
        print("LoggedIn");
        break;
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email).then((val){Fluttertoast.showToast(msg: "Reset Instructions sent to $email");}).catchError((){Fluttertoast.showToast(msg: "Unable to recognize $email");});
  }

  Future<FirebaseUser> signInWithFb() async {
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email']);
    if (result.status == FacebookLoginStatus.loggedIn) {
      final FacebookAccessToken accessToken = result.accessToken;

      AuthCredential credential =
      FacebookAuthProvider.getCredential(accessToken: accessToken.token);

      FirebaseUser fbUser = (await _auth.signInWithCredential(credential)).user;
      print(fbUser);
      return fbUser;
    }
    return null;
  }

  Future<bool> FBcheckAccount() async {
    try {
      final facebookLogin = FacebookLogin();
      final result = await facebookLogin.logIn(['email']);
      final AuthCredential credential = FacebookAuthProvider.getCredential(accessToken: result.accessToken.token);
      AuthResult authResult = await _auth.signInWithCredential(credential);
      print("hey${authResult.toString()}");
      if (authResult.additionalUserInfo.isNewUser) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      print(e.message);
      return null;
    }
  }

  Future<FirebaseUser> handleEmailSignIn(
      String email, String password, BuildContext context) async {
    FirebaseUser user;
    try {
      user = (await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;
      return user;
    } catch (exception) {
      print("null here");
      user = null;
      return user;
    }
  }



  Future<bool> checkAccount() async {
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: gSA.accessToken,
        idToken: gSA.idToken,
      );
      AuthResult authResult = await _auth.signInWithCredential(credential);
      if (authResult.additionalUserInfo.isNewUser) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      print(e.message);
      return null;
    }
  }

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return currentUser;
  }
}
