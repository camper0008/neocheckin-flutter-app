import 'package:neocheckin/models/employee.dart';
import 'package:neocheckin/responses/abstract.dart';

class EmployeeResponse implements Response {
  final Employee employee;
  @override
  final String error;

  EmployeeResponse({required this.employee, this.error = 'none'});

  EmployeeResponse.fromJson(Map<String, dynamic> json)
    : employee = json['employee'],
    error = json['error'] ?? 'none';
}
