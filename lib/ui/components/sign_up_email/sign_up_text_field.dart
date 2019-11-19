import 'package:flutter/material.dart';

class SignUpTextField extends StatelessWidget {
  final TextEditingController controller;
  final String title, error;
  const SignUpTextField({Key key, this.controller, this.title, this.error})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
          Text("$title:", style: Theme.of(context).textTheme.body1),
          Container(
              width: double.infinity,
              child: TextFormField(
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(15.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      hintText: title,
                      errorText: error),
                  controller: controller))
        ]));
  }
}
