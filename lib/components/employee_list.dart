import 'dart:async';
import 'package:flutter/material.dart';
import 'package:neocheckin/components/constrained_sidebar.dart';
import 'package:neocheckin/models/employee.dart';
import 'package:neocheckin/responses/employees_working.dart';
import 'package:neocheckin/utils/config.dart';
import 'package:neocheckin/utils/http_request.dart';

ConstrainedSidebar constrainedEmployeeList()
  => const ConstrainedSidebar(
    child: Padding(
      padding: EdgeInsets.only(right: 16),
      child: EmployeeList(),
    ),
  );

class EmployeeList extends StatefulWidget {
  const EmployeeList({Key? key}) : super(key: key);

  @override
  State<EmployeeList> createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {

  Map<String, List<Employee>> _employees = {};

  void _updateEmployees() async {
    String url = await cacheUrl;
    Map<String, dynamic> body = await HttpRequest.httpGet(url + '/employees/working', context);
    EmployeesWorkingResponse response = EmployeesWorkingResponse.fromJson(body);
    if (response.error == 'none') {
      setState(() => _employees = response.ordered );
    }

    Timer(const Duration(seconds: 30), _updateEmployees);
  }

  @override
  void initState() {
    super.initState();
    _updateEmployees();
  }
  @override
  void didUpdateWidget(EmployeeList oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateEmployees();
  }

  Widget _getDepartmentText(String name)
    => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        name,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      ),
    );

  List<Widget> _getEmployees(List<Employee> employees)
    => employees.map((employee) => 
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(
          employee.name,
          textAlign: TextAlign.left,
          style: const TextStyle(fontSize: 28),
        ),
      ),
    ).toList();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: ScrollController(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: _employees.entries.map((department) => 
          Column(
            children: [
              _getDepartmentText(department.key),
              ..._getEmployees(department.value),
            ]
          )
        ).toList()
      ),
    );
  }
}