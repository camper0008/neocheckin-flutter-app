import 'package:flutter/material.dart';
import 'package:neocheckin/components/flex_display.dart';
import 'package:neocheckin/components/option_display.dart';
import 'package:neocheckin/models/employee.dart';
import 'package:neocheckin/state_manager.dart';

class UserDisplay extends StatelessWidget {
  final StateManager stateManager;
  
  const UserDisplay({
    Key? key,
    required this.stateManager, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
  Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          if (stateManager.activeEmployee is! NullEmployee)
            Expanded(
              child: FlexDisplay(stateManager: stateManager,),
            ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16, top: 8),
            child: OptionDisplay(
              stateManager: stateManager,
            ),
          ),
        ],
      ),
    ),
  );
}