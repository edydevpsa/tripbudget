import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tripbudget/models/trip.dart';
import 'package:tripbudget/views/edit_notes_view.dart';
import 'package:tripbudget/widgets/provider_widget.dart';
import 'package:tripbudget/widgets/text_fields.dart';

class DetailTripView extends StatefulWidget {
  final Trip trip;

  DetailTripView({Key key, @required this.trip}) : super(key: key);

  @override
  _DetailTripViewState createState() => _DetailTripViewState();
}

class _DetailTripViewState extends State<DetailTripView> {
  TextEditingController _budgetEditController = TextEditingController();
  //var _budget;

  @override
  void initState() { 
    super.initState();
    _budgetEditController.text = widget.trip.budget.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: CustomScrollView(
          slivers:[
            SliverAppBar(
              title: Text('Trip Details'),
              elevation: 2.0,
              backgroundColor: Colors.indigoAccent,
              expandedHeight: 250.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                // title: AutoSizeText(
                //   trip.title,maxLines: 3, 
                //   style:TextStyle(color: Colors.white, fontSize: 20.0),
                // ),
                background: widget.trip.getLocationImage(),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.settings, color: Colors.white),
                   onPressed: (){
                     _tripEditModalBottonShet(context);
                   },
                ),
              ],
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [ 
                  tripDetails(),
                  //CalculatorWidget(trip: widget.trip,),
                  totalBudgetcard(),
                  costDuringTheTrip(),
                  daysOutCard(),
                  //SizedBox(),
                  notesCard(context),
                ],
              ), 
            ),
          ],
        ),
      ),
    );
  }

  Widget tripDetails(){
    return Card(
      elevation: 2.0,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Flexible(
                  child: AutoSizeText(
                    widget.trip.title, 
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 23.0,color: Colors.deepPurple),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("${DateFormat('dd/MM/yyyy').format(widget.trip.startDate).toString()} - ${DateFormat('dd/MM/yyyy').format(widget.trip.endDate).toString()}"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget totalBudgetcard(){
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: Colors.indigoAccent,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Daily Budget', style: TextStyle(fontSize: 18.0, color: Colors.white),),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: AutoSizeText(
                    "\$${(widget.trip.budget.floor()).toString()}", style: TextStyle(fontSize: 90.0),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          
        ],

      ),
    );
  }

  Widget costDuringTheTrip(){
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: Colors.lightBlue,
      child:  Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Spending during the trip', style: TextStyle(fontSize: 18.0, color: Colors.white),),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Total:', style: TextStyle(fontSize: 20.0,),),
                Flexible(
                  child: AutoSizeText(
                    "\$${(widget.trip.budget.floor() * widget.trip.getTotalTripDays()).toString()}", style: TextStyle(fontSize: 50.0),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          
        ],

      ),
    );
  }

  Widget daysOutCard(){
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: Colors.pinkAccent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('${widget.trip.getDaysUntilTrip().toString()}', style: TextStyle(fontSize: 70.0),),
            Text('Days until your trip', style: TextStyle(fontSize: 25.0),),
          ],
        ),
      ),
    );
  }

  Widget notesCard(BuildContext context) {
    return Hero(
      tag: 'TripNotes-${widget.trip.title}',
      transitionOnUserGestures: true,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        color: Colors.deepPurpleAccent,
        child: InkWell(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top:10.0, left: 10.0),
                child: Row(
                  children: [
                    Text('Trip Notes', style: TextStyle(fontSize: 24.0, color: Colors.white)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: setNoteText(),
                  
                ),
              ),
            ],
          ),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> EditNotes(trip: widget.trip)));
          },
        ),
      ),
    );

  }

  List<Widget>setNoteText() {
    if (widget.trip.notes == null) {
      return [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.add_circle, color:Colors.white),
        ),
        Text('Click to Add Notes', style:  TextStyle(color: Colors.white),),
      ];
    }else{
      return [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.trip.notes, style: TextStyle(color: Colors.white), overflow: TextOverflow.ellipsis,),
          ),
        ),
      ];
    }
  }

  void _tripEditModalBottonShet(BuildContext context) {
    showModalBottomSheet(
      context: context, builder: (BuildContext contex){
        return Container(
          height: MediaQuery.of(context).size.height * 0.50,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(' Edit Trip', style: TextStyle(fontSize: 25, color: Colors.redAccent),),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.cancel, size: 28.0, color: Colors.redAccent), 
                        onPressed: (){
                          Navigator.of(context).pop();
                        }
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0,),
                  Row(
                    children: [
                      Flexible(
                        child: AutoSizeText(
                          widget.trip.title, 
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 23.0,color: Colors.deepPurple),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: MoneyTextFields(controller: _budgetEditController, helperText: 'Edit budget',)
                      ),
                    ],
                  ),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RaisedButton(
                        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10.0)),
                        child: Text('Submit'),
                        textColor: Colors.white,
                        color: Colors.deepPurple,
                        onPressed: ()async{
                          setState(() {
                            //widget.trip.budget = (_budgetEditController.text == '') ? '0': double.parse(_budgetEditController.text);
                            widget.trip.budget = double.parse(_budgetEditController.text);
                            updateTrip(context);
                          });
                          Navigator.pop(context);
                        },
                      ),
                      RaisedButton(
                        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10.0)),
                        child: Text('Delete'),
                        textColor: Colors.white,
                        color: Colors.black,
                        onPressed: (){
                          setState(() {
                            deleteTrip(context);
                          });
                          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                        },
                      ),
                    ],
                  ),
                  
                ],
              ),
            ),
          ),
        );
      }
    );
  }
  //From Firebase modify and Update infomation for the toJosn()
  Future updateTrip(BuildContext context) async{
    var uuid = await Provider.of(context).auth.getCurrentUId();
    final document = FirebaseFirestore.instance
      .collection('userData')
      .doc(uuid)
      .collection('trips')
      .doc(widget.trip.documentId);
    return await document.set(widget.trip.toJson());  
  }
  //From Firebase Delete information 
  Future deleteTrip(BuildContext context) async{
    var uuid = await Provider.of(context).auth.getCurrentUId();
    final document = FirebaseFirestore.instance.collection('userData').doc(uuid).collection('trips').doc(widget.trip.documentId);
    return  await document.delete();
    
  }

}