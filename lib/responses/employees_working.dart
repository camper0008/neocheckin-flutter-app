import 'package:neocheckin/models/employee.dart';
import 'package:neocheckin/responses/abstract.dart';

class EmployeesWorkingResponse implements Response {
  final List<Employee> employees;
  final Map<String, List<Employee>> ordered;
  @override
  final String error;

  EmployeesWorkingResponse({required this.employees, required this.ordered, this.error = 'none'});

  EmployeesWorkingResponse.fromJson(Map<String, dynamic> json)
    : employees = json['employees'],
      ordered = json['ordered'],
      error = json['error'] ?? 'none';
}
