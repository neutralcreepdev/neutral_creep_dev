import 'package:flutter/material.dart';

import 'logic.dart';

class LoginSignUpForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isSignUp;
  const LoginSignUpForm(
      {Key key, this.emailController, this.passwordController, this.isSignUp})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          children: <Widget>[
            emailTextField(),
            SizedBox(height: 10),
            passwordTextField(),
            SizedBox(height: 10),
            isSignUp ? confirmPasswordTextField() : Container(),
          ],
        ));
  }

  TextFormField confirmPasswordTextField() {
    return TextFormField(
      obscureText: true,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: "CONFIRMED PASSWORD",
      ),
      validator: (confirmPasswordInput) =>
          LoginSignUpLogic.validateLoginSignUpConfirmPassword(
              confirmPasswordInput, passwordController),
    );
  }

  TextFormField passwordTextField() {
    return TextFormField(
      obscureText: true,
      controller: passwordController,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: "PASSWORD",
      ),
      validator: (passwordInput) =>
          LoginSignUpLogic.validateLoginSignUpPassword(passwordInput),
    );
  }

  TextFormField emailTextField() {
    return TextFormField(
      textAlign: TextAlign.center,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: "EMAIL",
      ),
      validator: (emailInput) =>
          LoginSignUpLogic.validateLoginSignUpEmail(emailInput),
    );
  }
}
