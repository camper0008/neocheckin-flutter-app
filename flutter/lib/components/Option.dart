import 'package:flutter/material.dart';

class Option extends StatefulWidget {
  final int selected;
  final List<String> options;

  Option({required this.selected, required this.options});

  @override
  State<Option> createState() => _OptionState();
}

class _OptionState extends State<Option> {

  late List<bool> _selected;
  late List<String> _options;

  _updateState(int selected, List<String> options) {
    List<bool> list = List.filled(options.length, false);
    list[selected] = true;

    _selected = list;
    _options = options;
  }
    @override
  void initState() {
    super.initState();
    _updateState(widget.selected, widget.options);
  }
  @override
  void didUpdateWidget(Option oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateState(widget.selected, widget.options);
  }


  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      children: _options.map((text) => 
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Text(
            '$text',
            style: TextStyle(
              fontSize: 32,
            ),
          ),
        ),
      ).toList(),
      onPressed: (int index) {
        setState(() {
          for (int buttonIndex = 0; buttonIndex < _selected.length; buttonIndex++) {
            if (buttonIndex == index) {
              _selected[buttonIndex] = true;
            } else {
              _selected[buttonIndex] = false;
            }
          }
        });
      },
      isSelected: _selected,
    );
  }
}