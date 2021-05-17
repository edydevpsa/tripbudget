import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MoneyTextFields extends StatelessWidget {
  final TextEditingController controller;
  final String helperText;

  MoneyTextFields({Key key, @required this.controller, this.helperText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          child: Row(
            children: [
              Icon(Icons.attach_money,size: 40.0, color: Colors.blueAccent,),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0,right: 30.0, left: 5.0,bottom: 10.0),
                  child: TextField(
                    controller: controller,
                    maxLines: 1,
                    decoration: InputDecoration(
                      helperText: helperText,
                    ),
                    keyboardType: TextInputType.numberWithOptions(decimal: false),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    //autofocus: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}