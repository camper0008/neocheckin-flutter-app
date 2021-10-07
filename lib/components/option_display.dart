import 'package:flutter/material.dart';
import 'package:neocheckin/models/option.dart';

class OptionDisplay extends StatefulWidget {
  final Option selected;
  final List<Option> options;
  final Function(Option) stateFunction;

  const OptionDisplay({Key? key, required this.selected, required this.options, required this.stateFunction}) : super(key: key);

  @override
  State<OptionDisplay> createState() => _OptionDisplayState();
}

class _OptionDisplayState extends State<OptionDisplay> {

  late Option _selected;
  late List<Option> _options;
  late void Function(Option) _updateParentState;

  _updateSelfState(Option selected, List<Option> options, Function(Option) updateParentState) {
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
  void didUpdateWidget(OptionDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateSelfState(widget.selected, widget.options, widget.stateFunction);
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.center,
      spacing: 8.0,
      runSpacing: 8.0,
      children: _options.map((Option option) =>
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: (option.id == _selected.id) ? 8 : 0,
            primary: (option.id == _selected.id) ? colorScheme.primary : colorScheme.primaryVariant,
          ),
          onPressed: () {_updateParentState(option);},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              option.name,
              style: const TextStyle(
                fontSize: 32,
              )
            ),
          ),
        )
      ).toList()
    );
  }
}