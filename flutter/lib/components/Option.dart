import 'package:flutter/material.dart';

class Option extends StatefulWidget {
  final int selected;
  final List<String> options;
  final Function(int) stateFunction;

  Option({required this.selected, required this.options, required this.stateFunction});

  @override
  State<Option> createState() => _OptionState();
}

class _OptionState extends State<Option> {

  late List<bool> _selected;
  late List<String> _options;
  late Function(int) _updateParentState;

  _updateSelfState(int selected, List<String> options, Function(int) updateParentState) {
    List<bool> list = List.filled(options.length, false);
    list[selected] = true;

    _updateParentState = updateParentState;
    _selected = list;
    _options = options;
  }
    @override
  void initState() {
    super.initState();
    _updateSelfState(widget.selected, widget.options, widget.stateFunction);
  }
  @override
  void didUpdateWidget(Option oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateSelfState(widget.selected, widget.options, widget.stateFunction);
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
        this._updateParentState(index);
      },
      isSelected: _selected,
    );
  }
}