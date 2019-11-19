import 'package:flutter/material.dart';

class LoginTextField extends StatelessWidget {
  final TextEditingController controller;
  final String title, error;
  final bool obscureText;
  const LoginTextField(
      {Key key, this.controller, this.title, this.obscureText, this.error})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.body1),
          Container(
              width: double.infinity,
              child: TextFormField(
                  obscureText: obscureText,
                  controller: controller,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(15.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      hintText: title,
                      hintStyle: TextStyle(height: 1.7),
                      errorText: error)))
        ]));
  }
}
