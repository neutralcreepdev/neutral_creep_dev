import 'package:flutter/material.dart';

import 'logic.dart';

class PostalCodeTextField extends StatelessWidget {
  final TextEditingController controller;
  const PostalCodeTextField({Key key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(8.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        hintText: "Postal Code",
        errorText: SignUpLogic.getPostalCodeError(controller.text),
      ),
      controller: controller,
      keyboardType: TextInputType.number,
    );
  }
}
