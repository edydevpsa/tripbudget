import 'dart:io';
import 'dart:ui';
import 'package:auth_buttons/res/buttons/apple_auth_button.dart';
import 'package:auth_buttons/res/buttons/facebook_auth_button.dart';
import 'package:auth_buttons/res/buttons/google_auth_button.dart';
import 'package:auth_buttons/res/shared/auth_button_style.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tripbudget/services/auth_service.dart';
import 'package:tripbudget/widgets/provider_widget.dart';

enum AuthFormType{signIn, signUp,reset, anonymous, convert}

class SignUpView extends StatefulWidget {
  final AuthFormType authFormType;

  SignUpView({Key key, @required this.authFormType}) : super(key: key);

  @override
  _SignUpViewState createState() => _SignUpViewState(authFormType: this.authFormType);
}

class _SignUpViewState extends State<SignUpView> {
  AuthFormType authFormType;
  bool _showAppleSign = false;
  @override
  void initState() {
    _useAppleSignIn();
    super.initState();
    
  }
  Future _useAppleSignIn()async{
    if (Platform.isIOS) {
      var deviceInfo = await DeviceInfoPlugin().iosInfo;
      var vesion = deviceInfo.systemVersion;
      if (double.parse(vesion) >= 13) {
        setState(() {
          _showAppleSign = true;
        });
      }
    }
  }

  _SignUpViewState({this.authFormType});

  final formKey = GlobalKey<FormState>();
  String _email, _password, _name, _warning;

  void switchFormState(String state){
    formKey.currentState.reset();
    if(state == 'signUp') {
      setState(() {
      authFormType = AuthFormType.signUp;
      });
    }else if(state == 'home'){
      Navigator.of(context).pop();
    }else{
      setState(() {
        authFormType = AuthFormType.signIn;
      });
    }
  }

  bool validateFormField(){
    final form = formKey.currentState;//globalkey currentState.save()es necesario si nos dara email=!null:true,
    if (authFormType == AuthFormType.anonymous) {
      return true;
    }
    if (form.validate()) {
      form.save();
      return true;
    }else{
      return false;
    }
  }

  void submit()async{
    if (validateFormField()) {
      try {
        final auth = Provider.of(context).auth;
        switch (authFormType) {
          case AuthFormType.signIn:
            await auth.signInWithEmailandPassword(_email, _password);
            Navigator.of(context).pushReplacementNamed('/home');
            break;
          case AuthFormType.signUp:
            await auth.createUserWithEmailandPassword(_email, _password, _name);
            Navigator.of(context).pushReplacementNamed('/home');

            break;
          case AuthFormType.reset:
            await  auth.sendPasswordResetEmail(_email);
            setState(() {
              authFormType = AuthFormType.signIn;
            });
            break;
          case AuthFormType.anonymous:
            await auth.signInAnonymously();
            Navigator.of(context).pushReplacementNamed('/home');
            break;
          case AuthFormType.convert: 
            await auth.convertUserWithEmail(_email, _password, _name);
            Navigator.of(context).pop();
            break;

          default:
        }
      }on PlatformException catch (e) {
        print(e);
        setState(() {
          //_error = e.code;
          _warning = e.message;
          //_error= e.nativeErrorMessage;
        });
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    if (authFormType == AuthFormType.anonymous) {
      submit();
      return Scaffold(
        backgroundColor: Colors.amberAccent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitFadingCube(color: Colors.white,),
            SizedBox(height: 20.0,),
            Text('Loading...', style: TextStyle(color: Colors.white, fontSize: 14.0))
          ],
        ),
      );
    }else{
      return Scaffold(
        body: Container(
          color:Color.fromRGBO(131, 184, 225, 1.0),
          width: _width,
          height: _height,
          child: SafeArea(
            child: SingleChildScrollView(
              child:Column(
                children: [
                  SizedBox(height: _height * 0.05),
                  showAlert(),
                  SizedBox(height: _height * 0.05),
                  buidHeaderText(),
                  SizedBox(height: _height * 0.02),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: buildInput() + buildButtons(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget showAlert(){
    if(_warning != null){
      return Container(
        color: Colors.amberAccent,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right:8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(
              child: AutoSizeText(
                _warning, 
                maxLines: 3, 
                style: TextStyle(color: Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:8.0),
              child: IconButton(icon: Icon(Icons.close), 
                onPressed: (){
                  setState(() {
                    _warning = null;
                  });
                },
              ),
            ),
          ],
        ),
      );
    }
    return SizedBox(height: 0.0, width: 0.0,);
  }

  AutoSizeText buidHeaderText(){
    String _headerText;
    if (authFormType == AuthFormType.signIn) {
      _headerText = 'Sign In';
    }else if(authFormType == AuthFormType.reset){
      _headerText = 'Reset Password';
    }else{
      _headerText = 'Create an Account';
    }
    return AutoSizeText(
      _headerText,
      maxLines: 1,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 28.0, color: Colors.white),
    );
  }

  List<Widget>buildInput() {
    List<Widget>textFields = [];
    if (authFormType == AuthFormType.reset) {
        textFields.add(
        buildFormFieldEmail('Email'),
      );
      textFields.add(SizedBox(height: 20.0,));

      return textFields;
    }
    //if were in the sign up state add name
    if ([AuthFormType.signUp, AuthFormType.convert].contains(authFormType)) {
      textFields.add(
        buildFormFieldName('Name'),
      );
    }
    textFields.add(SizedBox(height: 20.0,));
    textFields.add(
      buildFormFieldEmail('Email'),
    );
    textFields.add(SizedBox(height: 20.0,));
    textFields.add(
      buildFormFieldPassword('Password'),
    );
    return textFields;
  }

  //widget FormField Email
  Widget buildFormFieldEmail( String hint,){
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
      child: TextFormField(
        //VALIDATOR
        validator: EmailValidator.validateEmail,
        style: TextStyle(fontSize: 16.0),
        decoration: InputDecoration(
          focusColor: Colors.deepPurple,
          hintText: hint,
          border:OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
          filled: true,
          fillColor: Colors.white10,
          prefixIcon: Icon(Icons.email),
        ),
        //capture la data q manda el user con un globalkey currentState.save() 
        onSaved: (value) => _email = value, 
          
      ),
    );
  }
  //widget FormField Password
  Widget buildFormFieldPassword( String hint,){
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0, bottom: 10.0),
      child: TextFormField(
        validator: PasswordValidator.validatePassword,
        style: TextStyle(fontSize: 16.0),
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
          filled: true,
          fillColor: Colors.white10,
          prefixIcon: Icon(Icons.lock_outline_sharp),
        ),
        obscureText: true,
        //capture la data q manda el user con un globalkey currentState.save()
        onSaved: (value) => _password = value 
      ),
    );
  }
  //widget FormField User
  Widget buildFormFieldName( String hint,){
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0,),
      child: TextFormField(
        validator: NameValidator.validateName,
        style: TextStyle(fontSize: 16.0),
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
          filled: true,
          fillColor: Colors.white10,
          prefixIcon: Icon(Icons.person),
        ),
        //capture la data q manda el user con un globalkey currentState.save()
        onSaved: (value) => _name = value 
      ),
    );
  }

  List<Widget> buildButtons() {
    String _switchButtonText, _newFormState, _submitButtonText;
    bool _showForgotPassword = false;
    bool _showSocialIcon = true;

    if (authFormType == AuthFormType.signIn) {
      _switchButtonText = 'Create New Account';
      _newFormState = 'signUp';
      _submitButtonText = 'Sign In';
      _showForgotPassword = true;
    }else if(authFormType == AuthFormType.reset){
      _switchButtonText = 'Return to Sign In';
      _newFormState = 'signIn';
      _submitButtonText = 'Submit';
      _showSocialIcon = false;

    }else if(authFormType == AuthFormType.convert){
      _switchButtonText = 'Cancel';
      _newFormState = 'home';
      _submitButtonText = 'Sign Up';
      _showSocialIcon = false;
    }else{
      _switchButtonText = 'Have an Account? Sign In';
      _newFormState = 'signIn';
      _submitButtonText = 'Sign Up';
      _showSocialIcon = false;
    }

    return [
      Padding(
        padding: const EdgeInsets.only(top:15.0, right: 5.0, left: 22.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          child: RaisedButton(
            shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20.0)),
            color: Colors.white,
            textColor: Colors.indigo,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_submitButtonText, style: TextStyle(color: Colors.indigoAccent)),
            ),
            onPressed: submit,//fuction void submit
          ),
        ),
      ),
      showForgotPassword(_showForgotPassword),
      FlatButton(
        child: Text(_switchButtonText, style: TextStyle(color: Colors.white)),
        onPressed: (){
          switchFormState(_newFormState);
        }, 
      ),
      builSocialIcon(_showSocialIcon),
    ];
  }

  Widget showForgotPassword(bool visible){
    return Visibility(
      child: FlatButton(
        child: Text('Forgot Password?', style: TextStyle(color: Colors.white),),
        onPressed: (){
          setState(() {
            authFormType = AuthFormType.reset;    
          });
        },
      ),
      visible: visible,
    );
  }

  Widget builSocialIcon(bool visible, ) {
    final _auth = Provider.of(context).auth;
    return Visibility(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Divider(color: Colors.white,),
          SizedBox(height: 10.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GoogleAuthButton(
                elevation: 5.0,
                style: AuthButtonStyle.icon,
                buttonColor: Colors.white,
                borderRadius: 30.0,
                borderColor: Colors.white,
                onPressed: ()async{
                  try {
                    if (authFormType == AuthFormType.convert) {
                      await _auth.convertWithGoogle();
                      Navigator.of(context).pop();
                    }else{
                      await _auth.signInWithGoogle();
                      Navigator.of(context).pushReplacementNamed('/home');
                    }
                
                  } catch (e) {
                      setState(() {
                      _warning = e.message;
                    });
                  }
                },
              ),
              buildAppleSignIn(_auth),
              _facebookAuthButton(_auth),
            ],
          ),
        ],
      ),
      visible: visible,
    );
  }
  Widget buildAppleSignIn(AuthService _auth){
    if (authFormType != AuthFormType.convert && _showAppleSign == true) {
      return AppleAuthButton(
        elevation: 5.0,
        style: AuthButtonStyle.icon,
        borderRadius: 30.0,
        buttonColor: Colors.white,
        onPressed: ()async{
          await _auth.signInWithApple();
          Navigator.of(context).pushReplacementNamed('/home');
        }
      );
    // }else if(authFormType == AuthFormType.convert){
    //   return AppleAuthButton(
    //     elevation: 5.0,
    //     style: AuthButtonStyle.icon,
    //     borderRadius: 30.0,
    //     buttonColor: Colors.white,
    //     onPressed: ()async{
    //       await _auth.signInWithApple();
    //       Navigator.of(context).pushReplacementNamed('/home');
    //     }
    //   );
    }else {
      return Container();
    }
  }
  Widget _facebookAuthButton(AuthService _auth){
    return FacebookAuthButton(
      elevation: 5.0,
      style: AuthButtonStyle.icon,
      borderRadius: 30.0,
      onPressed: ()async{
        await _auth.loginWithFacebook();
        Navigator.of(context).pushReplacementNamed('/home');
      },
    );
  }

}