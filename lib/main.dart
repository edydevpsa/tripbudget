import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tripbudget/views/navigation_view.dart';
import 'package:tripbudget/services/auth_service.dart';
import 'package:tripbudget/views/first_view.dart';
import 'package:tripbudget/views/signUp_view.dart';
import 'package:tripbudget/widgets/provider_widget.dart';
 
void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Admob.initialize();
  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {
  final _primaryColor = Color.fromRGBO(239, 71, 111, 1.0);//Color.fromRGBO(51, 133, 198, 1.0);//Color.fromRGBO(251, 105, 102, 1.0);
  @override
  Widget build(BuildContext context) {
    return Provider(
      auth: AuthService(),
      db: FirebaseFirestore.instance,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        theme: ThemeData(
          primaryColor: _primaryColor,
        ),
        home: HomeController(),//FirstView(),//Home(),
        routes: {
          '/home' : (BuildContext context) => HomeController(),
          '/signUp': (BuildContext context) => SignUpView(authFormType: AuthFormType.signUp),
          '/signIn': (BuildContext context)=> SignUpView(authFormType: AuthFormType.signIn),
          '/anonymousSignIn': (BuildContext context)=> SignUpView(authFormType: AuthFormType.anonymous),
          '/convertUser': (BuildContext context)=> SignUpView(authFormType: AuthFormType.convert),
        },
      ),
    );
  }
}

class HomeController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of(context).auth;

    return StreamBuilder(
      stream: auth.authStateChanges,
      builder: (BuildContext context, AsyncSnapshot<String>snapshot){
        if (snapshot.connectionState == ConnectionState.active) {
          final bool signedIn = snapshot.hasData; 
          return signedIn ? Home() : FirstView();
        }
        return CircularProgressIndicator();
      }
    );
  }
}
