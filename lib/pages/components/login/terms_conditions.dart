import 'package:flutter/material.dart';

class TermsAndConditionsLink extends StatelessWidget {
  const TermsAndConditionsLink({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            "By pressing \"SIGN UP\" you are agreeing to our",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text("Terms & Conditions",
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold))
        ],
      ),
    );
  }
}
