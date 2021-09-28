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
  late FocusNode _focusNode;

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

    _focusNode = FocusNode(skipTraversal: true, canRequestFocus: true, descendantsAreFocusable: true);
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
  void dispose() {
    _focusNode.dispose();

    super.dispose();
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
              'Mikkel Troels Conststed',
              style: TextStyle(
                fontSize: (14*2),
              ),
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: (14*2)),
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
            Padding(
              padding: const EdgeInsets.only(top: 36),
              child: Text(
                '$_stateText',
                style: TextStyle(
                  fontSize: (14*2.5),
                  color: Colors.green
                ),
              )
            ),
            Container(
              width: 0,
              child: TextField(
                autofocus: true,
                onSubmitted: (String value) {
                  _focusNode.requestFocus();
                },
                focusNode: _focusNode,
              ),
            ),
          ],
        ),
      ],
    );
  }
}