import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tripbudget/credentials.dart';

class Trip{
  String title;
  DateTime startDate;
  DateTime endDate;
  double budget;
  Map budgetTypes;
  String travelType;
  String photoRerefence;
  String notes;
  String documentId;
  double saved;

  Trip(this.title, this.startDate, this.endDate, this.budget, this.budgetTypes, this.travelType,);

  //Formatting for Upload to firebase when creating the Trip
  Map<String, dynamic>toJson()=>{
    'title' : title,
    'startDate': startDate,
    'endDate': endDate,
    'budget' : budget,
    'budgetTypes' : budgetTypes,
    'travelType': travelType,
    'photoRerefence': photoRerefence,

  };

  //creating a Trip object from Firebase Snapshot
  Trip.fromSnapshot(DocumentSnapshot snapshot):
    title = snapshot.data()['title'],
    startDate = snapshot.data()['startDate'].toDate(),
    endDate = snapshot.data()['endDate'].toDate(),
    budget = snapshot.data()['budget'],
    budgetTypes = snapshot.data()['budgetTypes'],
    travelType = snapshot.data()['travelType'],
    photoRerefence = snapshot.data()['photoRerefence'],
    notes = snapshot.data()['notes'],
    documentId = snapshot.id,
    saved = snapshot.data()['saved'];

  Map<String, Icon>types() =>{
    'car':   Icon(Icons.directions_car,size: 50.0, color: Colors.lime,), 
    'bus':   Icon(Icons.directions_bus, size:50.0, color: Colors.orange,), 
    'train': Icon(Icons.train, size:50.0, color: Colors.amber,),
    'plane': Icon(Icons.airplanemode_active, size:50.0, color: Colors.lightBlue,),
    'ship':  Icon(Icons.directions_boat, size:50.0, color: Colors.blue),
    'other': Icon(Icons.directions, size:50.0, color: Colors.lightGreen,),
  };

  //return the Google Place Image
  FadeInImage getLocationImage() {
    final baseUrl = "https://maps.googleapis.com/maps/api/place/photo";
    final maxWidth = "1000";
    //final maxHeight = "1000";
    final url =  "$baseUrl?maxwidth=$maxWidth&photoreference=$photoRerefence&key=$PLACE_API_KEY";
    return FadeInImage(
      placeholder: AssetImage('assets/files/loading.gif'), 
      fadeInDuration: Duration(milliseconds:300),
      image: NetworkImage(url),
      fit: BoxFit.cover,
    );
  }

  int getTotalTripDays(){
    int total = endDate.difference(startDate).inDays;
    if (total < 1) {
      total = 1;
    }
    return total;
  }

  int getDaysUntilTrip(){
    int diff = startDate.difference(DateTime.now()).inDays;

    if (diff < 0) {
      diff = 0;
    }

    return diff;
  }
}