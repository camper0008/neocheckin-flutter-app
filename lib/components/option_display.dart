import 'package:flutter/material.dart';
import 'package:neocheckin/models/option.dart';
import 'package:neocheckin/state_manager.dart';

class OptionDisplay extends StatefulWidget {
  final StateManager stateManager;

  const OptionDisplay({Key? key, required this.stateManager}) : super(key: key);

  @override
  State<OptionDisplay> createState() => _OptionDisplayState();
}

class _OptionDisplayState extends State<OptionDisplay> {

  late StateManager _stateManager;

  @override
  void initState() {
    super.initState();
    _stateManager = widget.stateManager;
  }

  Widget _optionsButton(Option option, ColorScheme colorScheme) {
    Color darkenedPrimary = HSLColor.fromColor(colorScheme.primary).withLightness(0.4).toColor();
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: (option.id == _stateManager.activeOption.id) ? 8 : 0,
        primary: (option.id == _stateManager.activeOption.id) ? colorScheme.primary : darkenedPrimary,
      ),
      onPressed: () {_stateManager.activeOption = option;},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Text(
          option.displayName,
          style: const TextStyle(
            fontSize: 32,
          )
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.center,
      spacing: 8.0,
      runSpacing: 8.0,
      children: _stateManager.options
        .where((Option option) => option.available == OptionAvailable.available)
        .map((Option option) => _optionsButton(option, colorScheme))
        .toList()
    );
  }
}