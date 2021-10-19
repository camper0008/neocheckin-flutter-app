import 'package:flutter/material.dart';
import 'package:neocheckin/components/alert_display.dart';

displayError(BuildContext errorContext, String message) =>
  showDialog(
    context: errorContext,
    builder: (BuildContext context) => AlertDisplay(
      title: const Text("En fejl opstod:"),
      message: Text(
        message,
        style: const TextStyle(fontFamily: 'RobotoMono')
      ), 
      callback: () => Navigator.of(context).pop(),
    )
  );