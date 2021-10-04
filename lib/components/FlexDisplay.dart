import 'package:flutter/material.dart';
import 'dart:ui';
import '/utils/Time.dart';

class FlexDisplay extends StatefulWidget {
  final Time flex;
  final String name;

  FlexDisplay({required this.flex, required this.name});

  @override
  State<FlexDisplay> createState() => _FlexDisplayState();
}

class _FlexDisplayState extends State<FlexDisplay> {
  late String _flexHours;
  late String _flexMinutes;
  late String _flexPrefix;
  late Color _flexColor;
  late String _name;

  _updateSelfState(Time flex, String name) {
    _flexHours = flex.getFormattedHours();
    _flexMinutes = flex.getFormattedMinutes();

    bool isNegative = flex.isNegative();
    _flexPrefix = isNegative ? '-' : '+';
    _flexColor = isNegative ? Colors.red : Colors.green;

    _name = name;
  }

  @override
  void initState() {
    super.initState();
    _updateSelfState(widget.flex, widget.name);
  }
  @override
  void didUpdateWidget(FlexDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateSelfState(widget.flex, widget.name);
  }



  @override
  Widget build(BuildContext build) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 40), 
          child: Image(
            image: AssetImage('assets/images/placeholder.png')
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _name,
              style: TextStyle(
                fontSize: (14*2.75),
              ),
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: (14*2.25)),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Flex: '
                  ),
                  TextSpan(
                    text: '$_flexPrefix$_flexHours', 
                    style: TextStyle(
                      color: _flexColor,
                      fontFamily: 'RobotoMono',
                    ),
                  ),
                  TextSpan(
                    text: ':',
                  ),
                  TextSpan(
                    text: '$_flexMinutes', 
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
    );
  }
}