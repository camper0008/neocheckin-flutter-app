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

  late int _selected;
  late List<String> _options;
  late Function(int) _updateParentState;

  _updateSelfState(int selected, List<String> options, Function(int) updateParentState) {
    _updateParentState = updateParentState;
    _selected = selected;
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
  print(_selected);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _options.asMap().entries.map((entry) => 
        Container(margin: EdgeInsets.symmetric(horizontal: 10),
          child: (entry.key == _selected)
          ? ElevatedButton(
            style: ElevatedButton.styleFrom(
              shadowColor: Colors.transparent,
            ),
            onPressed: () {_updateParentState(entry.key);},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                entry.value,
                style: TextStyle(
                  fontSize: 24,
                )
              ),
            ),
          )
          : OutlinedButton(
            onPressed: () {_updateParentState(entry.key);},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                entry.value,
                style: TextStyle(
                  fontSize: 24,
                )
              ),
            )
          ),
        ),
      ).toList()
    );
  }
}