import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tripbudget/models/trip.dart';
import 'package:tripbudget/views/new_trips/summary.dart';
import 'package:tripbudget/widgets/dividerText.dart';
import 'package:tripbudget/widgets/text_fields.dart';

enum BudgetType{simple, complex}
class BudgetView extends StatefulWidget {
  final Trip trip;

  BudgetView({Key key, this.trip}) : super(key: key);

  @override
  _BudgetViewState createState() => _BudgetViewState();
}

class _BudgetViewState extends State<BudgetView> {
  //final BudgetType _budgetType = BudgetType.simple;
  var _budgetState = BudgetType.simple;
  var _switchButtontext = 'Build Budget';
  var budgetTotal = 0;
  TextEditingController _budgetController = TextEditingController();
  TextEditingController _transportationController = TextEditingController();
  TextEditingController _foodController = TextEditingController();
  TextEditingController _lodgingController = TextEditingController();
  TextEditingController _entertainmentController = TextEditingController();

  @override
  void initState() { 
    _budgetController.addListener(_setBudgetTotal);
    _transportationController.addListener(_setTotalBudget);
    _foodController.addListener(_setTotalBudget);
    _lodgingController.addListener(_setTotalBudget);
    _entertainmentController.addListener(_setTotalBudget);
    super.initState();
    
  }

  _setTotalBudget(){
    var total = 0;
    total = (_transportationController.text == '') ? 0 : int.parse(_transportationController.text);
    total += (_foodController.text == '') ? 0 : int.parse(_foodController.text);
    total += (_lodgingController.text == '') ? 0 : int.parse(_lodgingController.text);
    total += (_entertainmentController.text == '') ? 0 : int.parse(_entertainmentController.text);

    setState(() {
      budgetTotal = total;
    });
  }

  _setBudgetTotal(){
    setState(() {
      budgetTotal = (_budgetController.text == "") ? 0 : int.parse(_budgetController.text);
    });
  }

  List<Widget> setBudgetFields(_budgetController){
    List<Widget>fields = [];

    if (_budgetState == BudgetType.simple) {
      _switchButtontext = 'Build Budget';
      fields.add(Text('Enter a Trip Budget'));
      fields.add(MoneyTextFields(controller: _budgetController, helperText:'Daily Estimated Budget'));
    }else{
      _switchButtontext = 'SimpleBudget';
      fields.add(Text('Enter how much you want to spend in each area'));
      fields.add(MoneyTextFields(controller: _transportationController, helperText: 'Daily Estimated Transportation Budget'));
      fields.add(MoneyTextFields(controller: _foodController, helperText: 'Daily Estimated Food Budget'));
      fields.add(MoneyTextFields(controller: _lodgingController, helperText: 'Daily Estimated Lodging Budget'));
      fields.add(MoneyTextFields(controller: _entertainmentController, helperText: 'Daily Estimated Entertainment Budget'));

      fields.add(Text('Total Budget: \$$budgetTotal'));
    }

    fields.add(
      FlatButton(
        child: Text('Continue', style: TextStyle(fontSize: 25.0, color: Colors.indigoAccent),),
        onPressed: (){
          //save budget
          //widget.trip.budget = (_budgetController.text == '') ? 0 : double.parse(_budgetController.text);
          widget.trip.budget = budgetTotal.toDouble();
          widget.trip.budgetTypes = {
            'transportation' : (_transportationController.text == '') ? 0.0 : double.parse(_transportationController.text),
            'food': (_foodController.text == '') ? 0.0 : double.parse(_foodController.text),
            'lodging': (_lodgingController.text == '') ? 0.0 : double.parse(_lodgingController.text),
            'entertainment' : (_entertainmentController.text == '') ? 0.0 : double.parse(_entertainmentController.text),

          };        
          //Navigator.push(context, MaterialPageRoute(builder: (context)=> SummaryView(trip: widget.trip)));  
          Navigator.push(context, MaterialPageRoute(builder: (context)=> Summary(trip: widget.trip)));          
        }
      )
    );
    fields.add( DividerwithText(dividerText: 'or'),);
    fields.add(
      FlatButton(
        child: Text(_switchButtontext, style: TextStyle(fontSize: 22.0, color: Colors.deepPurple),),
        onPressed: (){
          setState(() {
            _budgetState = (_budgetState == BudgetType.simple) ? BudgetType.complex : BudgetType.simple;
          });
        }, 
      ),
    );
    return fields;
  }

  @override
  Widget build(BuildContext context) {
    _budgetController.text = budgetTotal.toString();
    _budgetController.selection = TextSelection.collapsed(offset: _budgetController.text.length);
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Trip Budget'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: setBudgetFields(_budgetController),
            ),
          ),
        ),
      ),
    );
  }
}