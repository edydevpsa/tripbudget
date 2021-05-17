import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tripbudget/models/trip.dart';
import 'package:tripbudget/views/new_trips/budget_view.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

class NewDateView extends StatefulWidget {
  final Trip trip;

  NewDateView({Key key, @required this.trip}) : super(key: key);

  @override
  _NewDateViewState createState() => _NewDateViewState();
}

class _NewDateViewState extends State<NewDateView> {

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(days: 7));

  Future displayDateRangePicker(BuildContext context)async{
    final List<DateTime> picked = await DateRagePicker.showDatePicker(
      context: context, 
      initialFirstDate: _startDate, 
      initialLastDate: _endDate, 
      firstDate: DateTime(DateTime.now().year -50),
      lastDate: DateTime(DateTime.now().year +50),
    );
    if (picked != null && picked.length == 2) {
      setState(() {
        _startDate = picked[0];
        _endDate = picked[1];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              //title: Text('Trip Details'),
              elevation: 2.0,
              backgroundColor: Colors.indigoAccent,
              expandedHeight: 250.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: AutoSizeText(
                  widget.trip.title,maxLines: 2, 
                  style:TextStyle(color: Colors.white, fontSize: 20.0),
                ),
                background: widget.trip.getLocationImage(),
              ),
            ),
            SliverFixedExtentList(
              delegate: SliverChildListDelegate(
                [ 
                  buildSelectedDetails(context, widget.trip),
                  buildButtons(),

                  //SizedBox(),
                ],
              ), 
              itemExtent: 200.0
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButtons(){
    return Padding(
      padding: const EdgeInsets.only(left:8.0, right: 8.0, bottom: 5.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(15.0)),
        elevation: 2.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.45,
              child: RaisedButton(
                shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20.0)),
                child: Text('Change Date Range'),
                textColor: Colors.white,
                color: Colors.deepPurple,
                onPressed: ()async{
                  await displayDateRangePicker(context);
                },
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.45,
              child: RaisedButton(
                shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20.0)),
                child: Text('Continue'),
                textColor: Colors.white,
                color: Colors.black,
                onPressed: (){
                  widget.trip.startDate = _startDate;
                  widget.trip.endDate = _endDate;
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> BudgetView(trip: widget.trip,)));
                },
              ),
            ),
          ],
        ),

      ),
    );
  }

  Widget buildingSelectedDates(){
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Start Date'),
                Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: Text(
                    "${DateFormat('MM-dd').format(_startDate).toString()}",
                    style: TextStyle(fontSize:35.0, color: Colors.deepPurple),
                  ),
                ),
                Text(
                  "${DateFormat('yyyy').format(_startDate).toString()}",
                  style: TextStyle(fontSize:18.0, color: Colors.deepPurple),
                ),
              ],
            ),
            Container(
              child: Icon(Icons.arrow_forward, color: Colors.redAccent, size: 45.0,),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('End Date'),
                Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: Text(
                    "${DateFormat('MM-dd').format(_endDate).toString()}",
                    style: TextStyle(fontSize:35.0, color: Colors.deepPurple),
                  ),
                ),
                Text(
                  "${DateFormat('yyyy').format(_endDate).toString()}",
                  style: TextStyle(fontSize:18.0, color: Colors.deepPurple),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSelectedDetails(BuildContext context, Trip trip){
    return Hero(
      tag: 'selectetTrip-${trip.title}',
      transitionOnUserGestures: true,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(left:8.0, right: 8.0),
          child: SingleChildScrollView(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top:16.0, left: 16.0, bottom: 16.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: AutoSizeText(
                                  trip.title, 
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 23.0),
                                ),
                              )
                            ],
                          ),
                          buildingSelectedDates(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}