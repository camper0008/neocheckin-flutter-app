import 'package:flutter/material.dart';
import 'package:neocheckin/components/cancel_button.dart';

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
  Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _cancelButtons.map((controller) => 
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: CancelButton(
                  controller: controller,
                ),
              )
            ).toList()
          ),
        ),
      ]
    ),
  );
}