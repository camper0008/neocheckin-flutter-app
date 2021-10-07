import 'package:neocheckin/utils/time.dart';

class Employee {
  final String name;
  final String department;
  final Time flex;
  final bool working;
  final String photo;
  Employee({required this.name, required this.department, required this.flex, required this.working, required this.photo});

  Employee.fromJson(Map<String, dynamic> json)
    : name = json['name'],
      department = json['department'],
      flex = Time(seconds: json['flex']),
      working = json['working'],
      photo = json['photo'];
}

class NullEmployee implements Employee {
  @override
  final String name = '';
  @override
  final String department = '';
  @override
  final Time flex = Time();
  @override
  final bool working = false;
  @override
  final String photo = '';

  NullEmployee();
}