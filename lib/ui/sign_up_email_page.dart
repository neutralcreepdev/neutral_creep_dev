import 'package:flutter/material.dart';
import 'package:neutral_creep_dev/ui/on_boarding_page.dart';
import 'components/sign_up_email/components.dart';

class SignUpEmailPage extends StatefulWidget {
  SignUpEmailPage({Key key}) : super(key: key);

  @override
  _SignUpEmailPageState createState() => _SignUpEmailPageState();
}

class _SignUpEmailPageState extends State<SignUpEmailPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String emailError, passwordError, confirmPasswordError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(context),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - 98,
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).backgroundColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                form(context),
                SignUpButton(onPressed: () => handleSignUpButtonTapped(context))
              ],
            ),
          ),
        ));
  }

  void handleSignUpButtonTapped(BuildContext context) async {
    setState(() {
      emailError = SignUpLogic.validateEmail(_emailController.text);
      passwordError = SignUpLogic.validatePassword(_passwordController.text);
      confirmPasswordError = SignUpLogic.validateConfirmPassword(
          _passwordController.text, _confirmPasswordController.text);
    });

    if (emailError == null &&
        passwordError == null &&
        confirmPasswordError == null) {
      await SignUpLogic.handleSignUpNewUser(
              context, _emailController.text, _passwordController.text)
          .then((isSuccessful) {
        if (isSuccessful) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => OnBoardingPage()),
              ModalRoute.withName("login"));
        } else {
          SignUpLogic.errorDialog(context);
        }
      });
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
              Text("Sign Up Credentials:",
                  style: TextStyle(
                      fontSize: 20, decoration: TextDecoration.underline)),
              SizedBox(height: 20),
              SignUpTextField(
                  title: "Email",
                  error: emailError,
                  controller: _emailController,
                  obscureText: false),
              SizedBox(height: 15),
              SignUpTextField(
                  title: "Password",
                  error: passwordError,
                  controller: _passwordController,
                  obscureText: true),
              SizedBox(height: 15),
              SignUpTextField(
                  title: "Confirm Password",
                  error: confirmPasswordError,
                  controller: _confirmPasswordController,
                  obscureText: true)
            ]));
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0,
        shape: Border(
            bottom:
                BorderSide(color: Theme.of(context).primaryColor, width: 0.2)),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, size: 35, color: Colors.black),
            onPressed: () => Navigator.pop(context)));
  }
}
