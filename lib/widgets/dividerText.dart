import 'package:flutter/material.dart';

class DividerwithText extends StatelessWidget {
  final String dividerText;
  DividerwithText({
    Key key, @required this.dividerText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Padding(
          padding: const EdgeInsets.only(right:8.0),
          child: Divider(),
        )),
        Text(dividerText),
        Expanded(child: Padding(
          padding: const EdgeInsets.only(left:8.0),
          child: Divider(),
        )),
      ],
    );
  }
}