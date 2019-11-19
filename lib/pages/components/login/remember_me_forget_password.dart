import 'package:flutter/material.dart';
import 'package:neutral_creep_dev/services/authService.dart';

import 'widgets/forget_password_dialog.dart';

class RememberMeForgetPasswordFields extends StatelessWidget {
  final bool isRememberMe;
  final Function onChanged;
  final GlobalKey<FormState> formKey;
  final AuthService authService;

  const RememberMeForgetPasswordFields(
      {Key key,
      this.isRememberMe,
      this.onChanged,
      this.formKey,
      this.authService})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 5.0, right: 5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CheckboxListTile(
              value: isRememberMe,
              onChanged: onChanged,
              title: new Text("Remember Me"),
              controlAffinity: ListTileControlAffinity.leading),
          GestureDetector(
            onTap: () async {
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ForgetPasswordDialog(
                    formKey: formKey,
                    authService: authService,
                  );
                },
              );
            },
            child: Text(
              "Forget Password?",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
