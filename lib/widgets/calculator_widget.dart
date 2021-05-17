import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tripbudget/models/trip.dart';
import 'package:tripbudget/widgets/provider_widget.dart';
import 'package:tripbudget/widgets/text_fields.dart';

class CalculatorWidget extends StatefulWidget {
   final Trip trip;

  CalculatorWidget({Key key, @required this.trip}) : super(key: key);

  @override
  _CalculatorWidgetState createState() => _CalculatorWidgetState();
}

class _CalculatorWidgetState extends State<CalculatorWidget> {
  TextEditingController _moneyControlller = TextEditingController();
  int _saved;
  int _needed;

  @override
  void initState() { 
    _saved = (widget.trip.saved ?? 0.0).floor();
    _needed = (widget.trip.budget.floor() * widget.trip.getTotalTripDays()) - _saved;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Container(
            color: Colors.indigoAccent,
            child: Padding(
              padding: const EdgeInsets.only(top:12.0, bottom: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: Column(
                      children: [
                        AutoSizeText("\$$_saved", maxLines: 4, style: TextStyle(fontSize: 30.0,color: Colors.lime,), overflow: TextOverflow.ellipsis,),
                        Text("Saved", style: TextStyle(fontSize: 16.0,color: Colors.white,)),
                      ],
                    ),
                  ),
                  Container(
                    height: 60.0,
                    child: VerticalDivider(color: Colors.white,thickness: 4,),
                  ),
                  Flexible(
                    child: Column(
                      children: [
                        AutoSizeText("\$$_needed", maxLines: 4, style: TextStyle(fontSize: 30.0, color: Colors.lime),overflow: TextOverflow.ellipsis,),
                        Text("Needed", style: TextStyle(fontSize: 16.0,color: Colors.white,)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.cyan,
            child: Column(
              children: [
                SizedBox(height: 10.0,),
                Text('Saved Aditional',style: TextStyle(fontSize: 20.0, color: Colors.deepPurple),),
                Padding(
                  padding: const EdgeInsets.only(left:20.0, right: 50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: MoneyTextFields(controller:_moneyControlller, helperText: 'Edit Additional',)
                      ),
                      IconButton(
                        icon: Icon(Icons.add_circle,color: Colors.amberAccent,),
                        iconSize: 35.0,
                        onPressed: ()async{
                          setState(() {
                            _saved += (_moneyControlller.text == '') ? 0 : int.parse(_moneyControlller.text);
                            _needed -= (_moneyControlller.text == '') ? 0 : int.parse(_moneyControlller.text);
                          });
                          final uid = await Provider.of(context).auth.getCurrentUId();
                          await FirebaseFirestore.instance
                          .collection('userData')
                          .doc(uid)
                          .collection('trips')
                          .doc(widget.trip.documentId)
                          .update({'saved': _saved.toDouble()});
                        }
                      ),
                      IconButton(
                        icon: Icon(Icons.remove_circle, color: Colors.redAccent,),
                        iconSize: 35.0,
                        onPressed: ()async{
                          setState(() {
                            _saved -= (_moneyControlller.text == '') ? 0 : int.parse(_moneyControlller.text);
                            _needed += (_moneyControlller.text == '') ? 0 : int.parse(_moneyControlller.text);
                          });
                          final uid = await Provider.of(context).auth.getCurrentUId();
                          await FirebaseFirestore.instance
                          .collection('userData')
                          .doc(uid)
                          .collection('trips')
                          .doc(widget.trip.documentId)
                          .update({'saved': _saved.toDouble()});
                        }
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      generateAddMoneyBtn(25),
                      generateAddMoneyBtn(50),
                      generateAddMoneyBtn(100),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  RaisedButton generateAddMoneyBtn(int amount){
    return RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
      child: Text("\$$amount"),
      color: Colors.amber,
      onPressed: ()async{
        setState(() {
          _saved += amount; //or _saved = _saved + 25;
          _needed -= amount; //or _needed = _needed - 25;
        });
        final uid = await Provider.of(context).auth.getCurrentUId();
        await FirebaseFirestore.instance
        .collection('userData')
        .doc(uid)
        .collection('trips')
        .doc(widget.trip.documentId)
        .update({'saved': _saved.toDouble()});
      }
    );
  }
}