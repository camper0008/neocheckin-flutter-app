import 'package:flutter/material.dart';
import 'dart:ui';
import '../utils/Time.dart';

class FlexDisplay extends StatefulWidget {
  final Time flex;

  FlexDisplay({required this.flex});

  @override
  State<FlexDisplay> createState() => _FlexDisplayState();
}

class _FlexDisplayState extends State<FlexDisplay> {
  late String _flexHours;
  late String _flexMinutes;
  late String _flexPrefix;
  late Color _flexColor;
  late String _stateText;

  _updateSelfState(Time flex, [ bool checkedIn = true ]) {
    _flexHours = flex.getFormattedHours();
    _flexMinutes = flex.getFormattedMinutes();

    bool isNegative = flex.isNegative();
    _flexPrefix = isNegative ? '-' : '+';
    _flexColor = isNegative ? Colors.red : Colors.green;

    if (checkedIn)
      _stateText = "Du er nu checket ind";
    else
      _stateText = "Du er nu checket ud";
  }

  @override
  void initState() {
    super.initState();
    _updateSelfState(widget.flex);
  }
  @override
  void didUpdateWidget(FlexDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateSelfState(widget.flex);
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
            RichText(
              textScaleFactor: 2,
              text: TextSpan(children: <TextSpan>[
                TextSpan(
                  text: 'Mikkel Troels Conststed\n', 
                ),
                TextSpan(
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
                      style: TextStyle(
                        fontSize: 16
                      ),
                    ),
                    TextSpan(
                      text: '$_flexMinutes', 
                      style: TextStyle(
                        color: _flexColor,
                        fontFamily: 'RobotoMono',
                      ),
                    ),
                  ]
                ),
              ])
            ),
            Padding(
              padding: const EdgeInsets.only(top: 36),
              child: RichText(
                textScaleFactor: 2.5,
                text: TextSpan(
                  text: '$_stateText',
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
              ),
            ),
          ],
        )
        
      ],
    );
  }
}