import 'package:flutter/material.dart';

class SignUpTextField extends StatelessWidget {
  final TextEditingController controller;
  final String title, error;
  final bool obscureText;
  const SignUpTextField(
      {Key key, this.controller, this.title, this.error, this.obscureText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
          Text("$title:", style: TextStyle(fontSize: 20)),
          Container(
              width: double.infinity,
              child: TextFormField(
                  obscureText: obscureText,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 15),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      hintText: title,
                      errorText: error),
                  controller: controller))
        ]));
  }
}
