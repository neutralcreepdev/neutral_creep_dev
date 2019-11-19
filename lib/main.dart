import 'package:flutter/material.dart';
import 'package:neutral_creep_dev/services/authService.dart';
import 'package:neutral_creep_dev/services/dbService.dart';
import 'package:provider/provider.dart';

import 'models/models.dart';
import 'ui/launch_page.dart';
import 'app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final AuthService _auth = AuthService();
  final DBService _db = DBService();
  Customer _customer = Customer();
  PurchaseTransaction _transaction = PurchaseTransaction();

  runApp(MultiProvider(
    providers: [
      Provider<AuthService>.value(value: _auth),
      Provider<DBService>.value(value: _db),
      Provider<Customer>.value(value: _customer),
      Provider<PurchaseTransaction>.value(value: _transaction),
    ],
    child: MaterialApp(
        title: "Neutal Creep",
        theme: AppTheme.theme(),
        debugShowCheckedModeBanner: false,
        home: LaunchPage()),
  ));
}
