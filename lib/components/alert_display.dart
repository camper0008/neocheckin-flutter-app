import 'package:flutter/material.dart';
import 'package:neocheckin/utils/play_alert.dart';

class AlertDisplay extends StatelessWidget {

  final void Function() callback;
  final Text title;
  final Text message;
  
  const AlertDisplay({Key? key, required this.title, required this.message, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    playAlert();
    return AlertDialog(
      title: title,
      content: SingleChildScrollView(
        child: message
      ),
      actions: [
        TextButton(
          onPressed: callback, 
          child: const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'OK', style: TextStyle(fontSize: 20),
            ),
          )
        )
      ]
    );

  }
}