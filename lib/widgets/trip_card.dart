
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tripbudget/models/trip.dart';
import 'package:tripbudget/views/detail_trip_view.dart';

Widget buildTripCard(BuildContext context, DocumentSnapshot snapshot){
    final trip = Trip.fromSnapshot(snapshot);
    final tripType = trip.types();
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        //height: double.infinity,
        //width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,//FractionalOffset(0.0, 0.6),
            end: Alignment.centerRight,//FractionalOffset(0.0, 1.0),
            colors: [
              Colors.pinkAccent,
              Colors.red,
              
              //Color.fromRGBO(236, 98, 188, 1.0),
              //Color.fromRGBO(241, 142, 171, 1.0),
            ],
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: InkWell(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [ 
              Row(
                children: [
                  Flexible(
                    child: AutoSizeText(
                      trip.title, maxLines: 3, style: TextStyle(fontSize: 28.0,color: Colors.white),
                      overflow: TextOverflow.ellipsis
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Row(
                    children: [
                      Text(
                        "${DateFormat('dd/MM/yyyy').format(trip.startDate).toString()} - ${DateFormat('dd/MM/yyyy').format(trip.endDate).toString()}", 
                        style: TextStyle(fontSize: 18.0, color: Colors.lime),
                      ),
                    ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Row(
                  children: [
                    Text("\$ ${(trip.budget == null)? 'n/a': trip.budget.toStringAsFixed(2)}", style: TextStyle(fontSize: 30.0, color: Colors.indigo),),
                    Spacer(),
                    //Text(trip.travelType, ),
                    (tripType.containsKey(trip.travelType)) 
                    ? tripType[trip.travelType] 
                    : tripType['other'],//Para q me jale los iconos desde firebase
                  ],
                ),
              ),
            ]
            ),
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailTripView(trip: trip)));
          },
        )
      ),
    );
}

