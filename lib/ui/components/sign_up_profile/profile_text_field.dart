import 'package:flutter/material.dart';

class SignUpProfileTextFields extends StatelessWidget {
  final TextEditingController controller;
  final String title, error;
  final double width;
  final TextInputType keyboardType;
  const SignUpProfileTextFields(
      {Key key,
      this.controller,
      this.title,
      this.width,
      this.error,
      this.keyboardType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
          Text("$title:", style: TextStyle(fontSize: 15)),
          Container(
              width: width,
              child: TextFormField(
                  keyboardType: keyboardType,
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
