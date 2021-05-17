import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PolicyDialog extends StatelessWidget {
  final String mdFileName;

  PolicyDialog({Key key,@required this.mdFileName}):assert(mdFileName.contains('md'),'the file contains md extension'),super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape:  RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: Future.delayed(Duration(milliseconds: 150)).then((value) {
                return rootBundle.loadString('assets/files/$mdFileName');
              }),
              builder: (context, snapshot){
                if (snapshot.hasData) {
                  return Markdown(
                    data: snapshot.data
                  );
                }
                return CircularProgressIndicator();
              }
            ),
          ),
          FlatButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8.0), bottomRight: Radius.circular(8.0))),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8.0), bottomRight: Radius.circular(8.0)),
              ),
              alignment: Alignment.center,
              height: 50.0,
              width: double.infinity,
              child: Text('close', style: TextStyle(fontSize: 20.0, color: Colors.white)),
            ),
            color: Colors.pinkAccent,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}