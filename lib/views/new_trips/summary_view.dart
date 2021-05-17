import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tripbudget/models/trip.dart';
import 'package:tripbudget/widgets/provider_widget.dart';

class SummaryView extends StatelessWidget {
  final db = FirebaseFirestore.instance;
  final Trip trip;

  SummaryView({Key key, this.trip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tripTypes = trip.types();
    var tripKeys = tripTypes.keys.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip Summary'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Finish'),
              Text('Location ${trip.title}'),
              Text("${DateFormat('dd/MM/yyyy').format(trip.startDate).toString()} - ${DateFormat('dd/MM/yyyy').format(trip.endDate).toString()}"),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  scrollDirection: Axis.vertical,
                  primary: false,
                  children: List.generate(tripTypes.length, (index){
                    return FlatButton(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          tripTypes[tripKeys[index]],
                          Text(tripKeys[index]),
                        ],
                      ),
                      onPressed: ()async{
                        //Save Data to Firebase
                        //await db.collection('trips').add(trip.toJson()); 
                        trip.travelType = tripKeys[index];
                        final uid = await Provider.of(context).auth.getCurrentUId();
                        await db.collection('userData').doc(uid).collection('trips').add(trip.toJson());
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      }, 
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}