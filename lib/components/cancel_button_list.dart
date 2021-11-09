import 'package:flutter/material.dart';
import 'package:neocheckin/components/cancel_button.dart';
import 'package:neocheckin/components/constrained_sidebar.dart';

ConstrainedSidebar constrainedCancelButtonList(
  List<CancelButtonController> cancelButtons, 
  Function(CancelButtonController) removeCancelButton
)
  => ConstrainedSidebar(
    child: Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: CancelButtonList(
        cancelButtons: cancelButtons,
        removeCancelButton: (CancelButtonController controller) { removeCancelButton(controller); },
      ),
    ),
  );


class CancelButtonList extends StatefulWidget {

  final List<CancelButtonController> cancelButtons;
  final void Function(CancelButtonController) removeCancelButton;

  const CancelButtonList({Key? key, required this.cancelButtons, required this.removeCancelButton}) : super(key: key);

  @override
  State<CancelButtonList> createState() => _CancelButtonListState();
}

class _CancelButtonListState extends State<CancelButtonList> {
  late List<CancelButtonController> _cancelButtons;

  @override
  void initState() {
    super.initState();
    _cancelButtons = widget.cancelButtons;
  }
  @override
  void didUpdateWidget(CancelButtonList oldWidget) {
    super.didUpdateWidget(oldWidget);
    _cancelButtons = widget.cancelButtons;
  }


  @override
  Widget build(BuildContext build) =>
  Align(
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
          children: _cancelButtons.map((controller) => 
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