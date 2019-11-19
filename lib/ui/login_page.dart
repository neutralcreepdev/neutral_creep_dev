import 'package:flutter/material.dart';
import 'package:neutral_creep_dev/models/models.dart';
import 'package:neutral_creep_dev/services/dbService.dart';
import 'package:neutral_creep_dev/ui/sign_up_profile_page.dart';
import 'package:provider/provider.dart';
import 'components/login/componets.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isChecked = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String emailError = "";
  String passwordError = "";

  @override
  void initState() {
    super.initState();
    LoginPageLogic.getEmailPassword(_emailController, _passwordController)
        .then((value) => setState(() => isChecked = value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
                decoration: backgroundImage(),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      // Title and Logo
                      Column(children: <Widget>[
                        logo(context),
                        Container(
                            child: Center(
                                child: Text("LOGIN",
                                    style: TextStyle(fontSize: 50))))
                      ]),

                      // Main body
                      Column(
                        children: <Widget>[
                          FacebookLoginButton(
                              onPressed: () =>
                                  handleFacebookButtonTapped(context)),
                          SizedBox(height: 10),
                          GoogleLoginButton(
                              onPressed: () =>
                                  handleGoogleButtonTapped(context)),
                          SizedBox(height: 10),
                          Container(
                              child: Center(
                                  child: Text("-OR-",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color:
                                              Theme.of(context).cardColor)))),
                          LoginTextField(
                              title: "email",
                              controller: _emailController,
                              obscureText: false,
                              error: emailError),
                          SizedBox(height: 10),
                          LoginTextField(
                              title: "password",
                              controller: _passwordController,
                              obscureText: true,
                              error: passwordError),
                          SizedBox(height: 10),
                          rememberMeAndForgetPasswordFields(),
                        ],
                      ),

                      // login button and sign up
                      Column(
                        children: <Widget>[
                          LoginButton(
                              onPressed: () =>
                                  handleLoginButtonTapped(context)),
                          SizedBox(height: 10),
                          SignUpLink(
                              onTap: () => handleSignUpLinkTapped(context))
                        ],
                      )
                    ]))));
  }

  void handleSignUpLinkTapped(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SignUpProfilePage(isUsingSocial: false)));
  }

  void handleGoogleButtonTapped(BuildContext context) {
    LoginPageLogic.googlelogin(context).then((customer) {
      if (customer.name != null) {
        Provider.of<Customer>(context).updateCustomer(customer);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        Provider.of<Customer>(context).id = customer.id;
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => SignUpProfilePage(isUsingSocial: true)));
      }
    });
  }

  void handleFacebookButtonTapped(BuildContext context) {
    LoginPageLogic.facebooklogin(context).then((customer) {
      if (customer != null) {
        Provider.of<Customer>(context).updateCustomer(customer);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        Provider.of<Customer>(context).id = customer.id;
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => SignUpProfilePage(isUsingSocial: true)));
      }
    });
  }

  void handleLoginButtonTapped(BuildContext context) {
    isChecked
        ? LoginPageLogic.savePreferences(
            _emailController.text, _passwordController.text)
        : LoginPageLogic.clearPreferences();

    setState(() {
      emailError = LoginPageLogic.validateEmail(_emailController.text);
      passwordError = LoginPageLogic.validatePassword(_passwordController.text);
    });

    if (emailError.isEmpty && passwordError.isEmpty) {
      LoginPageLogic.loginDialog(
              context, _emailController.text, _passwordController.text)
          .then((customer) async {
        if (customer != null) {
          Provider.of<Customer>(context).updateCustomer(customer);
          await DBService()
              .getEWalletData(Provider.of<Customer>(context).id)
              .then((eWallet) =>
                  Provider.of<Customer>(context).eWallet = eWallet);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(),
                  settings: RouteSettings(name: "home")));
        } else {
          LoginPageLogic.errorDialog(context);
        }
      });
    }
  }

  RememberMeForgetPasswordFields rememberMeAndForgetPasswordFields() {
    return RememberMeForgetPasswordFields(
      value: isChecked,
      rememberMeOnChanged: (value) {
        setState(() => isChecked = value);
      },
      fogetPasswordOnTap: () {},
    );
  }

  SizedBox logo(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 150,
      child: Image.asset("assets/images/logo-neutralcreep2019-2.png",
          fit: BoxFit.cover),
    );
  }

  BoxDecoration backgroundImage() {
    return BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/BG.png"), fit: BoxFit.cover));
  }
}
