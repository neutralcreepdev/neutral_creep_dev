import 'package:flutter/material.dart';

import 'logic.dart';

class FirstNameTextField extends StatelessWidget {
  final TextEditingController controller;
  const FirstNameTextField({Key key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(8.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        hintText: "First Name",
        errorText: SignUpLogic.isFieldFilled(controller.text)
            ? null
            : 'Please input your first name!',
      ),
      controller: controller,
    );
  }
}
