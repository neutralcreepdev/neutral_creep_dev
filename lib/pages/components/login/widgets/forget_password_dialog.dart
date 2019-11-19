import 'package:flutter/material.dart';

import '../../../../services/authService.dart';
import '../../../../helpers/color_helper.dart';
import '../logic.dart';

class ForgetPasswordDialog extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final AuthService authService;

  ForgetPasswordDialog({
    Key key,
    this.formKey,
    this.authService,
  }) : super(key: key);

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Reset Password"),
      content: Form(
        key: formKey,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Enter email to reset password"),
              SizedBox(height: 15),
              enterEmailTextField(context),
              SizedBox(height: 30),
              reEnterEmailTextField(context),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        FlatButton(
          child: new Text("Confirm"),
          onPressed: () {
            if (formKey.currentState.validate()) {
              formKey.currentState.save();
              authService.resetPassword(_controller.text.toString());
              Navigator.of(context).pop();
            }
          },
        ),
        FlatButton(
            child: new Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ],
    );
  }

  Container reEnterEmailTextField(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 100,
      child: TextFormField(
        validator: (val) =>
            LoginSignUpLogic.validateReEnteredEmail(val, _controller),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.email,
            color: heidelbergRed,
          ),
          hintText: "Re-enter email",
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: heidelbergRed, width: 0.0),
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        textAlign: TextAlign.center,
        textInputAction: TextInputAction.done,
      ),
    );
  }

  Container enterEmailTextField(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 100,
      child: TextFormField(
        controller: _controller,
        validator: (val) => LoginSignUpLogic.validateEmail(val),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.email,
            color: heidelbergRed,
          ),
          hintText: "Enter email",
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: heidelbergRed, width: 0.0),
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        textAlign: TextAlign.center,
        textInputAction: TextInputAction.done,
      ),
    );
  }
}
