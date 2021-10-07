import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:neocheckin/models/employee.dart';

class FlexDisplay extends StatefulWidget {
  final Employee employee;
  final void Function(Employee) setEmployee;

  const FlexDisplay({Key? key, required this.employee, required this.setEmployee}) : super(key: key);

  @override
  State<FlexDisplay> createState() => _FlexDisplayState();
}

class _FlexDisplayState extends State<FlexDisplay> {
  late String _flexPrefix;
  late Color _flexColor;
  late Employee _employee;
  late Timer _resetTimer;

  _updateSelfState(Employee employee) {
    _employee = employee;

    bool isNegative = _employee.flex.isNegative();
    _flexPrefix = isNegative ? '-' : '+';
    _flexColor = isNegative ? Colors.red : Colors.green;
  }

  @override
  void initState() {
    super.initState();
    _updateSelfState(widget.employee);
    _resetTimer = Timer(const Duration(seconds: 5), (){widget.setEmployee(NullEmployee());});
  }
  @override
  void didUpdateWidget(FlexDisplay oldWidget) {
    if (oldWidget.employee.name != widget.employee.name) {
      _resetTimer.cancel();
      _resetTimer = Timer(const Duration(seconds: 5), (){widget.setEmployee(NullEmployee());});
      super.didUpdateWidget(oldWidget);
      _updateSelfState(widget.employee);
    }
  }

  @override
  Widget build(BuildContext build) {
    return Visibility(
      visible: (_employee is! NullEmployee),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 36),
            child: Text(
              (_employee.working ? 'Du er nu checket ud' : 'Du er nu checket ind'),
              style: const TextStyle(
                fontSize: (14*3),
              ),
            )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 40), 
                child: Image.memory(
                  base64Decode(_employee.photo),
                  gaplessPlayback: true,
                  width: 240,
                  height: 320,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _employee.name,
                    style: const TextStyle(
                      fontSize: (14*2.75),
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: (14*2.25)),
                      children: <TextSpan>[
                        const TextSpan(
                          text: 'Flex: '
                        ),
                        TextSpan(
                          text: _flexPrefix + _employee.flex.getFormattedHours(),
                          style: TextStyle(
                            color: _flexColor,
                            fontFamily: 'RobotoMono',
                          ),
                        ),
                        const TextSpan(
                          text: ':',
                        ),
                        TextSpan(
                          text: _employee.flex.getFormattedMinutes(), 
                          style: TextStyle(
                            color: _flexColor,
                            fontFamily: 'RobotoMono',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}