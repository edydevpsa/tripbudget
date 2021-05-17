import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tripbudget/widgets/custom_dialog.dart';
import 'package:tripbudget/widgets/terms_Use.dart';

class FirstView extends StatelessWidget {

  final primaryColor = Color.fromRGBO(22, 189, 242, 1.0);
  
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: _width,
        height: _height,
        color: primaryColor,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(height: _height * 0.10,),
                  Image.asset('assets/files/year21.png', width: 260.0, height: 160.0,),
                  Text(
                    'Welcome!',
                    style: TextStyle(fontSize: 44.0, color: Colors.white),
                  ),
                  SizedBox(height: _height * 0.05),
                  AutoSizeText(
                    'Let’s start planning your next trip',
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30.0, color: Colors.white),
                  ),
                  SizedBox(height: _height *0.07),
                  RaisedButton(
                    color: Color.fromRGBO(89, 22, 242, 1.0),
                    shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(30.0)),
                    child: Padding(
                      padding: const EdgeInsets.only(top:8.0, bottom: 8.0, left: 20.0, right: 20.0),
                      child: Text('Get Started', style: TextStyle(color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.w300)),
                    ),
                    onPressed: (){
                      //Custom Dialog Class, you neeed invoke showDialog() for  te Dialog,
                      showDialog(
                        context: context,
                        builder: (BuildContext context){
                          return CustomDialog(
                            title: 'Would you like to create a free account?', 
                            description: 'With an account, your data will be securely saved, allowing you to access it from multiple devices.', 
                            primaryButtonText: 'Create My Account', 
                            primaryButtonRoute: '/signUp',
                            secondaryButtonText: 'Maybe Later',
                            secondaryButtonRoute: '/anonymousSignIn',
                          );
                        },
                      );
                      
                    },
                  ),
                  SizedBox(height: _height *0.02),
                  FlatButton(
                    child: Text('Sign In', style: TextStyle(color: Color.fromRGBO(89, 22, 242, 1.0), fontSize: 25.0),),
                    onPressed: (){
                      //Sign In Class
                      Navigator.of(context).pushReplacementNamed('/signIn');
                    }, 
                  ),
                  SizedBox(height: _height *0.16),
                  TermsOfUse(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}