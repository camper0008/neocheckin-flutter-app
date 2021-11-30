import 'dart:async';
import 'package:flutter/material.dart';
import 'package:neocheckin/models/timestamp.dart';
import 'package:neocheckin/utils/http_requests/get_timestamp.dart';
import 'package:neocheckin/utils/time.dart';

Align cornerTimer()
  => const Align(
    alignment: Alignment.topLeft,
    child: Clock()
  );

class Clock extends StatefulWidget {
  const Clock({ Key? key }) : super(key: key);

  @override
  State<Clock> createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  int _initialTime = 0;
  final Stopwatch _stopwatch = Stopwatch();
  Time _clockTime = Time();

  void _recalibrateClockTime() async {
    Timestamp result = await getUpdatedLocalTimestamp(context);
    _clockTime = Time(hours: result.hour, minutes: result.minute, seconds: result.seconds);
    _initialTime = _clockTime.getSeconds();

    _stopwatch.stop();
    _stopwatch.reset();
    _stopwatch.start();

    Timer(const Duration(hours: 1), _recalibrateClockTime);
  }

  void _updateClockTime() async {
    setState(() => _clockTime.setSeconds(_initialTime + _stopwatch.elapsed.inSeconds));

    Timer(const Duration(seconds: 1), _updateClockTime);
  }

  @override void initState() {
    super.initState();
    _updateClockTime();
    _recalibrateClockTime();
  }
  
  @override
  Widget build(BuildContext context)
    => Container(
      color: Colors.white,
      margin: const EdgeInsets.all(32.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          _clockTime.getFormattedHours() + 
          ":" + _clockTime.getFormattedMinutes() + 
          ":" + _clockTime.getFormattedSeconds(),
          style: const TextStyle(
            fontSize: 44,
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );
}