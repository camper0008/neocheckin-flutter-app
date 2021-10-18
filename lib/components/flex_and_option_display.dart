import 'package:flutter/material.dart';
import 'package:neocheckin/components/flex_display.dart';
import 'package:neocheckin/components/option_display.dart';
import 'package:neocheckin/models/employee.dart';
import 'package:neocheckin/models/option.dart';

class UserDisplay extends StatelessWidget {

  final Employee employee;
  final void Function(Employee) setEmployee;
  final Option optionSelected;
  final List<Option> options;
  final void Function(Option) setOption;
  
  const UserDisplay({
    Key? key,
    required this.employee, 
    required this.setEmployee,
    required this.optionSelected,
    required this.options,
    required this.setOption
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
  Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          if (employee is! NullEmployee)
            Expanded(
              child: FlexDisplay(employee: employee, setEmployee: setEmployee),
            ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16, top: 8),
            child: OptionDisplay(
              selected: optionSelected, 
              options: options, 
              setOption: setOption,
            ),
          ),
        ],
      ),
    ),
  );
}