import 'package:flutter/material.dart';
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

  _updateState(Time flex) {
    _flexHours = flex.getFormattedHours();
    _flexMinutes = flex.getFormattedMinutes();

    bool isNegative = flex.isNegative();
    _flexPrefix = isNegative ? '-' : ' ';
    _flexColor = isNegative ? Colors.red : Colors.green;
  }

  @override
  void initState() {
    super.initState();
    _updateState(widget.flex);
  }
  @override
  void didUpdateWidget(FlexDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateState(widget.flex);
  }

  @override
  Widget build(BuildContext build) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 40, 0), 
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
                      style: TextStyle(color: _flexColor)
                    ),
                    TextSpan(
                      text: ':'
                    ),
                    TextSpan(
                      text: '$_flexMinutes', 
                      style: TextStyle(
                        color: _flexColor
                      ),
                    ),
                  ]
                ),
              ])
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 36, 0, 0),
              child: RichText(
                textScaleFactor: 2.5,
                text: TextSpan(
                  text: 'Du er nu checket ind',
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