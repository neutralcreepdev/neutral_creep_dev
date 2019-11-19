import 'package:flutter/material.dart';

import 'logic.dart';

class ContactNumTextField extends StatelessWidget {
  final TextEditingController controller;
  const ContactNumTextField({Key key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(8.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        hintText: "Contact Number",
        errorText: SignUpLogic.getContactNumError(controller.text),
      ),
      keyboardType: TextInputType.number,
      controller: controller,
    );
  }
}
