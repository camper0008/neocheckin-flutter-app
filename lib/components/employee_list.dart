import 'package:flutter/material.dart';
import 'package:neocheckin/models/employee.dart';

class EmployeeList extends StatefulWidget {
  final Map<String, List<Employee>> employees;

  const EmployeeList({Key? key, required this.employees}) : super(key: key);

  @override
  State<EmployeeList> createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {

  late Map<String, List<Employee>> _employees;

  _updateSelfState(Map<String, List<Employee>> employees) {
    _employees = employees;
  }

  @override
  void initState() {
    super.initState();
    _updateSelfState(widget.employees);
  }
  @override
  void didUpdateWidget(EmployeeList oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateSelfState(widget.employees);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: _employees.entries.map((department) => 
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                department.key,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            ...department.value.asMap().entries.map((entry) => 
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  entry.value.name,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ).toList()
          ]
        )
      ).toList()
    );
  }
}