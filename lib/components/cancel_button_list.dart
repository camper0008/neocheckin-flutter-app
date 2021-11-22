import 'package:flutter/material.dart';
import 'package:neocheckin/components/cancel_button.dart';
import 'package:neocheckin/components/constrained_sidebar.dart';
import 'package:neocheckin/state_manager.dart';

ConstrainedSidebar constrainedCancelButtonList(
  StateManager stateManager
)
  => ConstrainedSidebar(
    child: Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: CancelButtonList(
        stateManager: stateManager,
      ),
    ),
  );


class CancelButtonList extends StatelessWidget {

  final StateManager stateManager;

  const CancelButtonList({Key? key, required this.stateManager}) : super(key: key);

  @override
  Widget build(BuildContext context)
    => Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: SingleChildScrollView(
          controller: ScrollController(),
          reverse: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: stateManager.cancelButtons.map((controller) => 
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: CancelButton(
                  controller: controller,
                ),
              )
            ).toList()
          ),
        ),
      ),
    );
}