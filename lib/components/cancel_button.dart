/*
  SHOULD BE:
    elevatedbutton, red
  USES:
    Timer class from dart:async
    https://api.flutter.dev/flutter/dart-async/Timer-class.html
  HAS:
    Line from start to finish counting down
*/

import 'dart:async';
import 'package:flutter/material.dart';

class CancelScanButton extends StatefulWidget {
  final String action;
  final void Function() callback;

  const CancelScanButton({Key? key, required this.action, required this.callback}) : super(key: key);

  @override
  State<CancelScanButton> createState() => _CancelScanButtonState();
}

class _CancelScanButtonState extends State<CancelScanButton> {
  late Timer _callbackTimer;
  late String _action;
  late Timer _displayTimer;
  String _timerString = "";

  @override
  void initState() {
    _callbackTimer = Timer(const Duration(seconds: 6), widget.callback);
    _action = widget.action;
    _startCountdown();
    super.initState();
  }

  _startCountdown() {
    int _countdown = 5000;
    _displayTimer = Timer.periodic(const Duration(milliseconds: 100), (countdownTimer) {
      if (_countdown < 100) {
        countdownTimer.cancel();
      } else {
        _countdown -= 100;
        String paddedString = _countdown.toString().padLeft(4, '0');
        String seconds = paddedString.substring(0, 1);
        String milliseconds = paddedString.substring(1, 2);
        setState(() {
          _timerString = '$seconds.$milliseconds';
        });
      }
    });
  }

  @override
  Widget build(BuildContext build) {
      return ElevatedButton.icon(
        onPressed: () {
          _callbackTimer.cancel();
          _displayTimer.cancel();
        }, 
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            '[$_timerString] Cancel $_action',
            style: const TextStyle(fontSize: 24),
          ),
        ),
        icon: const Icon(
          Icons.alarm,
          size: 24,
        ),
        style: ElevatedButton.styleFrom(primary: Colors.red),
      );
  }
}