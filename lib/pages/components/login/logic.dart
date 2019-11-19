import 'package:flutter/widgets.dart';

class LoginSignUpLogic {
  static final RegExp emailRegExp = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

  // validators
  static String validateLoginSignUpConfirmPassword(
      String confirmPassword, TextEditingController controller) {
    if (confirmPassword.isEmpty) {
      return "This field is blank";
    }

    if (confirmPassword != controller.text) {
      return "Confirm Password should match password";
    }
    return null;
  }

  static String validateLoginSignUpPassword(String password) {
    if (password.isEmpty) {
      return "This field is blank";
    }
    if (password.length != 8) {
      return "Please enter a 8 alphanumeric password";
    }
    if (validatePWStructure(password) == false)
      return "Password must include at least 1 lowercase\nand uppercase alphabet, digit and symbol";
    return null;
  }

  static String validateLoginSignUpEmail(String email) {
    if (email.isEmpty) {
      return "This field is blank";
    }
    bool checkEmail = emailRegExp.hasMatch(email);
    if (checkEmail == false) return "Please enter a valid email";
    return null;
  }

  static bool validatePWStructure(String password) {
    String patt =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~.,*%^]).{8,}$';
    RegExp createRegExp = new RegExp(patt);
    return createRegExp.hasMatch(password);
  }

  static String validateReEnteredEmail(
    String val,
    TextEditingController controller,
  ) {
    if (val.isEmpty)
      return "Please enter confirmation email";
    else if (!val.contains("@") && !val.contains("."))
      return "Please enter valid email!";
    else if (controller.text.toString() != val) {
      return "Please enter the same email as above";
    }
    return null;
  }

  static String validateEmail(String val) {
    if (val.isEmpty)
      return "Please enter email";
    else if (!val.contains("@") && !val.contains("."))
      return "Please enter valid email!";
    return null;
  }
}
