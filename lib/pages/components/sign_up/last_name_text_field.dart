import 'package:flutter/material.dart';

import 'logic.dart';

class LastNameTextField extends StatelessWidget {
  final TextEditingController controller;
  const LastNameTextField({Key key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(8.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        hintText: "Last Name",
        errorText: SignUpLogic.isFieldFilled(controller.text)
            ? null
            : 'Please input your last name!',
      ),
      controller: controller,
    );
  }
}
