import 'package:flutter/material.dart';
import 'package:tripbudget/services/auth_service.dart';
class Provider extends InheritedWidget{
  final AuthService auth;
  final db;

  Provider({Key key, Widget child, this.auth, this.db}) : super (key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;

  }

  static Provider of(BuildContext context)=> (context.dependOnInheritedWidgetOfExactType<Provider>());
  
}