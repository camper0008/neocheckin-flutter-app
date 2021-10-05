import 'dart:async';
import 'package:flutter/material.dart';

class CancelButtonController {
  final int duration;
  final String action;
  final void Function() callback;
  final void Function(CancelButtonController) unmountCallback;
  late final Timer _callbackTimer;
  late int _displayCounter;

  CancelButtonController({required this.duration, required this.action, required this.callback, required this.unmountCallback}) {
    _callbackTimer = Timer(
      Duration(seconds: duration, milliseconds: 25),
      () { 
        callback();
        unmountCallback(this);
      }
    );

    _displayCounter = duration * 10;
  }

  void decreaseCounter() {
    _displayCounter--;
  }

  String getDisplayString() {
    return _displayCounter.toString()
      .padLeft(2, '0').split('')
      .reduce((prev, curr) => prev + '.' + curr);
  }
}

class CancelButton extends StatefulWidget {
  final CancelButtonController controller;

  const CancelButton({Key? key, required this.controller}) : super(key: key);

  @override
  State<CancelButton> createState() => _CancelButtonState();
}

class _CancelButtonState extends State<CancelButton> {
  late CancelButtonController _controller;
  Timer _displayTimer = Timer(const Duration(seconds: 0), (){});

  void update(CancelButton widget) {
    _controller = widget.controller;
  }

  void _createDisplayTimer(CancelButton widget) {
    _displayTimer = Timer.periodic(
      const Duration(milliseconds: 100), 
      (timer) {
        if (!mounted) { timer.cancel(); return;}
        if (_controller._displayCounter < 1) {
          timer.cancel();
        } else {
          setState(() {
            _controller.decreaseCounter();
          });
        }
      }
    );
  }

  @override
  void initState() {
    super.initState();
    update(widget);
    _createDisplayTimer(widget);
  }

  @override
  void didUpdateWidget(CancelButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    update(widget);
    _displayTimer.cancel();
    _createDisplayTimer(widget);
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
          'Annuller ' + _controller.action + '? [' + _controller.getDisplayString() + ']',
          style: const TextStyle(fontSize: 24),
        ),
      ),
      icon: const Icon(
        Icons.alarm,
        size: 24,
      ),
      style: ElevatedButton.styleFrom(
        primary: Colors.red,
      ),
    );
  }
}