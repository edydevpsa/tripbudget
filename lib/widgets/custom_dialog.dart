import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title, description, primaryButtonText, primaryButtonRoute, secondaryButtonText, secondaryButtonRoute;

  CustomDialog({ @required this.title, @required this.description, @required this.primaryButtonText, @required this.primaryButtonRoute, this.secondaryButtonText, this.secondaryButtonRoute});
  final _primaryColor = Color.fromRGBO(89, 22, 242, 1.0);
  final grayColor = const Color(0xFF939393);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 24.0,),
                AutoSizeText(
                  title, 
                  maxLines: 2, 
                  style: TextStyle(color: _primaryColor, fontSize:25.0),
                ),
                SizedBox(height: 24.0,),
                AutoSizeText(
                  description, 
                  maxLines: 2, 
                  style: TextStyle(color: grayColor, fontSize:20.0),
                ),
                SizedBox(height: 24.0,),
                RaisedButton(
                  color: Colors.pinkAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                  child: AutoSizeText(
                    primaryButtonText, 
                    maxLines: 1, 
                    style: TextStyle(color:Colors.white, fontSize: 18.0, fontWeight: FontWeight.w300),
                  ),
                  onPressed: (){
                    Navigator.of(context).pop();
                    Navigator.pushReplacementNamed(context, primaryButtonRoute);
                  },
                ),
                SizedBox(height: 24.0,),
                showSecondaryButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget showSecondaryButton(BuildContext context){
    if (secondaryButtonRoute != null && secondaryButtonText != null) {
      return FlatButton(
        child: AutoSizeText(
          secondaryButtonText,
          maxLines: 1,
          style: TextStyle(color: Colors.pinkAccent, fontSize: 20.0, fontWeight: FontWeight.w400),
        ),
        onPressed: (){
          Navigator.of(context).pop();
          Navigator.pushReplacementNamed(context, secondaryButtonRoute);
        },
      );
    }else{
      return Container();
    }
  }
}