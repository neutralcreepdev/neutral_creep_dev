import 'package:flutter/material.dart';

class AddCreditCardTextFields extends StatelessWidget {
  final TextEditingController controller;
  final String title, error;
  final double width;
  final TextInputType keyboardType;
  const AddCreditCardTextFields(
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
          Text("$title:", style: Theme.of(context).textTheme.body1),
          Container(
              width: width,
              child: TextFormField(
                  keyboardType: keyboardType,
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
