import 'dart:async';
import 'package:flutter/material.dart';

class CancelButtonController {
  final int duration;
  final String action;
  final void Function() callback;
  final void Function(CancelButtonController) unmountCallback;
  late final Timer _callbackTimer;
  late Stopwatch _stopwatch;

  CancelButtonController({required this.duration, required this.action, required this.callback, required this.unmountCallback}) {
    _callbackTimer = Timer(
      Duration(seconds: duration, milliseconds: 25),
      () { 
        callback();
        unmountCallback(this);
      }
    );
    _stopwatch = Stopwatch()..start();
  }

  int getSecondsLeft() => duration - _stopwatch.elapsed.inSeconds;
}

class CancelButton extends StatefulWidget {
  final CancelButtonController controller;

  const CancelButton({Key? key, required this.controller}) : super(key: key);

  @override
  State<CancelButton> createState() => _CancelButtonState();
}

class _CancelButtonState extends State<CancelButton> {
  late CancelButtonController _controller;
  late int _secondsLeft;
  Timer _displayTimer = Timer(const Duration(seconds: 0), (){});

  void _updateSelf(CancelButton widget) {
    _controller = widget.controller;
    _secondsLeft = _controller.getSecondsLeft();
  }

  void _createDisplayTimer(CancelButton widget) {
    _displayTimer = Timer.periodic(
      const Duration(seconds: 1), 
      (timer) {
        if (!mounted) { timer.cancel(); return; }
        setState(() => _secondsLeft = _controller.getSecondsLeft());
      }
    );
  }

  @override
  void initState() {
    super.initState();
    _updateSelf(widget);
    _createDisplayTimer(widget);
  }

  @override
  void didUpdateWidget(CancelButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateSelf(widget);
  }

  @override
  void dispose() {
    super.dispose();
    _displayTimer.cancel();
  }

  @override
  Widget build(BuildContext build) {
    return ElevatedButton.icon(
      onPressed: () {
        _displayTimer.cancel();
        _controller._callbackTimer.cancel();
        _controller.unmountCallback(_controller);
      }, 
      label: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          'Annuller ' + _controller.action + '? [$_secondsLeft]',
          style: const TextStyle(fontSize: 20),
        ),
      ),
      icon: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Icon(
          Icons.alarm,
          size: 24,
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: Colors.red,
      ),
    );
  }
}