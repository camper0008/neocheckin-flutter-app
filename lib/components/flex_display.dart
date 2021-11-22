import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:neocheckin/state_manager.dart';

Image _getImageFromBase64(String base64) {
  return Image.memory(
    base64Decode(base64),
    gaplessPlayback: true,
    width: 240,
    height: 320,
    errorBuilder: (BuildContext context, Object object, StackTrace? trace) {
      return Image.asset(
        "assets/images/placeholder.png",
        width: 240,
        height: 320,
      );
    },
  );
}


class FlexDisplay extends StatelessWidget {
  final StateManager stateManager;

  const FlexDisplay({Key? key, required this.stateManager}) : super(key: key);

  String get _flexPrefix {
    bool isNegative = stateManager.activeEmployee.flex.isNegative();
    return isNegative ? '-' : '+';
  }

  Color get _flexColor {
    bool isNegative = stateManager.activeEmployee.flex.isNegative();
    return isNegative ? Colors.red : Colors.green;
  }

  Text get _flexText =>
    Text.rich(
      TextSpan(
        style: const TextStyle(fontSize: (14*2.25)),
        children: <TextSpan>[
          const TextSpan(
            text: 'Flex: '
          ),
          TextSpan(
            text: _flexPrefix + stateManager.activeEmployee.flex.getFormattedHours(),
            style: TextStyle(
              color: _flexColor,
              fontFamily: 'RobotoMono',
            ),
          ),
          const TextSpan(
            text: ':',
          ),
          TextSpan(
            text: stateManager.activeEmployee.flex.getFormattedMinutes(), 
            style: TextStyle(
              color: _flexColor,
              fontFamily: 'RobotoMono',
            ),
          ),
        ],
      ),
    );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 36),
          child: Text(
            (stateManager.activeEmployee.working ? 'Du er nu tjekket ud' : 'Du er nu tjekket ind'),
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
              child: _getImageFromBase64(stateManager.activeEmployee.photo)
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stateManager.activeEmployee.name,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 7,
                    style: const TextStyle(
                      fontSize: (14*2.25),
                    ),
                  ),
                  _flexText
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

}