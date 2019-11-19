import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encPkg;

import '../helpers/color_helper.dart';
import '../services/authService.dart';
import '../services/dbService.dart';
import 'components/login/componets.dart';

class LoginSignUpPage extends StatefulWidget {
  _LoginSignUpPageState createState() => _LoginSignUpPageState();
}

class _LoginSignUpPageState extends State<LoginSignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _form2 = GlobalKey<FormState>();
  final _auth = AuthService();
  final _db = DBService();
  var isSignUp = true;
  var isRememberMe = false;
  SharedPreferences sp;
  TextEditingController emailText = new TextEditingController();
  TextEditingController passwordText = new TextEditingController();

  //Encryption AES and RSA
  static final key = encPkg.Key.fromUtf8('CSIT-321 FYPQRCODEORDERINGSYSTEM');
  final iv = encPkg.IV.fromLength(16);
  final enc = encPkg.Encrypter(encPkg.AES(key));

  void initState() {
    super.initState();
    getEmailPassword();
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
                      LoginSignUpToggle(
                        isSignUp: isSignUp,
                        loginOnPress: setIsSignUpToFalse,
                        signUpOnPress: setIsSignUpToTrue,
                      ),

                      //  form container ====================================
                      LoginSignUpForm(
                          emailController: emailText,
                          passwordController: passwordText,
                          isSignUp: isSignUp),

                      //  button and terms and condition container ====================================
                      Container(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: <Widget>[
                            isSignUp
                                ? TermsAndConditionsLink()
                                : RememberMeForgetPasswordFields(
                                    isRememberMe: isRememberMe,
                                    formKey: _form2,
                                    onChanged: _onChanged,
                                    authService: _auth),

                            //  login sign up button ====================================
                            SizedBox(height: 15),
                            LoginSignUpButton(
                                isSignUp: isSignUp,
                                formKey: _formKey,
                                email: emailText.text,
                                password: passwordText.text,
                                authService: _auth,
                                dbService: _db,
                                onChange: _onChanged,
                                isRememberMe: isRememberMe)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            //  facebook and google signup/login container ====================================
            LoginSignUpWithSocials(authService: _auth, dbService: _db)
          ],
        ),
      ),
    );
  }

  _onChanged(bool value) async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      isRememberMe = value;
      if (isRememberMe) {
        if (emailText.text != "" && passwordText.text != "") {
          final emailEnc = enc.encrypt(emailText.text, iv: iv);
          final passwordEnc = enc.encrypt(passwordText.text, iv: iv);
          sp.setBool("check", isRememberMe);
          sp.setString("email", emailEnc.base64);
          sp.setString("password", passwordEnc.base64);
          getEmailPassword();
        }
      } else {
        sp.clear();
      }
    });
  }

  getEmailPassword() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      isRememberMe = sp.getBool("check");
      if (isRememberMe != null) {
        if (isRememberMe) {
          if (sp.getString("email") != "" && sp.getString("password") != "") {
            String decEmailText = enc.decrypt64(sp.getString("email"), iv: iv);
            String decPasswordText =
                enc.decrypt64(sp.getString("password"), iv: iv);
            emailText.text = decEmailText;
            passwordText.text = decPasswordText;
          }
        } else {
          emailText.clear();
          passwordText.clear();
          sp.clear();
        }
      } else {
        isRememberMe = false;
      }
    });
  }

  void setIsSignUpToFalse() {
    setState(() {
      isSignUp = false;
    });
  }

  void setIsSignUpToTrue() {
    setState(() {
      isSignUp = true;
    });
  }
}
