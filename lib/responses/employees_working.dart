import 'package:neocheckin/models/employee.dart';
import 'package:neocheckin/responses/abstract.dart';

class EmployeesWorkingResponse implements Response {
  final List<Employee> employees;
  final Map<String, List<Employee>> ordered;
  @override
  final String error;

  EmployeesWorkingResponse({required this.employees, required this.ordered, this.error = 'none'});

  EmployeesWorkingResponse.fromJson(Map<String, dynamic> json)
    /* casting */
    : employees = (json['employees'].runtimeType != null.runtimeType) 
        ? (json['employees'] as List<dynamic>)
          .map((dynamic employeeJson) 
            => Employee.fromJson(employeeJson))
          .toList()
        : <Employee>[],
      ordered = (json['ordered'].runtimeType != null.runtimeType)
        ? (json['ordered'] as Map<String, dynamic>)
          .map((dynamic department, employeesJsonList)
            => MapEntry(
            department.toString(), 
            (employeesJsonList as List<dynamic>)
              .map((dynamic employeeJson) 
                => Employee.fromJson(employeeJson))
              .toList()
            ))
        : <String, List<Employee>>{},
      error = json['error'] ?? 'none';
}
