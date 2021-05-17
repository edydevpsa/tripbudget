import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tripbudget/models/trip.dart';
import 'package:tripbudget/widgets/provider_widget.dart';

class EditNotes extends StatefulWidget {
  final Trip trip;

  const EditNotes({Key key, @required this.trip}) : super(key: key);

  @override
  _EditNotesState createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> {
  TextEditingController _notesController = TextEditingController();
  final db = FirebaseFirestore.instance;

  @override
  void initState() { 
    _notesController.text = widget.trip.notes;
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(52, 54, 101, 1.0),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Hero(
          tag: 'TripNotes-${widget.trip.title}',
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  buildHeading(context),
                  buildNotesText(),
                  buildSummitButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeading(BuildContext context) {
    return Material(
      color: Color.fromRGBO(52, 54, 101, 1.0),
      child: Padding(
        padding: const EdgeInsets.only(top:10.0, left: 20.0),
        child: Row(
          children: [
            Expanded(
              child: Text('Trip Notes', 
                style: TextStyle(color: Colors.white, fontSize: 24.0),
              ),
            ),
            FlatButton(
              child: Icon(Icons.close, color: Colors.white, size: 30.0),
              onPressed: (){
                Navigator.of(context).pop();
              }, 
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNotesText() {
    return Material(
      color: Color.fromRGBO(52, 54, 101, 1.0),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: TextField(
          maxLines: null,
          controller: _notesController,
          decoration: InputDecoration(
            border: InputBorder.none
          ),
          cursorColor: Colors.white,
          style: TextStyle(color: Colors.white),
          autofocus: true,
        ),
      ),
    );
  }

  Widget buildSummitButton(BuildContext context) {
    return Material(
      color: Color.fromRGBO(52, 54, 101, 1.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        color: Colors.indigoAccent,
        child: Text('Save your Notes', style: TextStyle(color: Colors.white, fontSize: 15.0),),
        onPressed: ()async{
          //uploading notes to firebase, the user unique id
          widget.trip.notes = _notesController.text;
          final uid = await Provider.of(context).auth.getCurrentUId();
          db.collection('userData')
          .doc(uid)
          .collection('trips')
          .doc(widget.trip.documentId) //de Aqui para abajo actualizmos data en el notes
          .update({
            'notes': _notesController.text,
          });

          Navigator.of(context).pop();
        },
      ),
    );
  }
}