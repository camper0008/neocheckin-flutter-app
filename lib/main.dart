import 'dart:async';
import 'package:flutter/material.dart';
import 'package:neocheckin/components/cancel_button.dart';
import 'package:neocheckin/components/cancel_button_list.dart';
import 'package:neocheckin/components/card_reader_input.dart';
import 'package:neocheckin/components/flex_and_option_display.dart';
import 'package:neocheckin/components/employee_list.dart';
import 'package:neocheckin/components/constrained_sidebar.dart';
import 'package:neocheckin/models/option.dart';
import 'package:neocheckin/responses/employees_working.dart';
import 'package:neocheckin/models/employee.dart';
import 'package:neocheckin/utils/http_request.dart';
import 'package:neocheckin/utils/http_requests/card_scanned.dart';
import 'package:neocheckin/utils/http_requests/get_updated_options.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NeoCheckIn',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DefaultTextStyle(
        style: TextStyle(
          fontFamily: 'Roboto',
        ),
        child: Scaffold(
          body: HomePage()
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<CancelButtonController> _cancelButtons = [];
  List<Option> _options = [];
  Option _optionSelected = NullOption();
  Option _priorityOption = NullOption();
  Employee _activeEmployee = NullEmployee();
  Map<String, List<Employee>> _employees = {};

  void _setOption(Option option) => setState(() => _optionSelected = option );
  void _setEmployee(Employee employee) => setState(() => _activeEmployee = employee );

  void _updateOptions() async {
    List<Option> updated = await getUpdatedOptions(_options, context);
    bool isIdentical = optionsAreIdentical(_options, updated);
    if (!isIdentical) {
      Option priorityOption = getPriorityOption(updated);
      setState(() {
        _options = updated;
        _priorityOption = priorityOption;
        _optionSelected = priorityOption;
      });
    }

    Timer(const Duration(minutes: 1), _updateOptions);
  }
  void _updateEmployees() async {
    Map<String, dynamic> body = await HttpRequest.httpGet('$apiUrl/employees/working', context);
    EmployeesWorkingResponse response = EmployeesWorkingResponse.fromJson(body);
    if (response.error == 'none') {
      setState(() => _employees = response.ordered );
    }
  }
  void _addCancelButton(CancelButtonController controller) =>
    setState(() => _cancelButtons.add(controller));
  void _removeCancelButton(CancelButtonController controller) =>
    setState(() => _cancelButtons.removeWhere((p) => p == controller));

  @override
  void initState() {
    super.initState();
    _updateEmployees();
    _updateOptions();
  }

  ConstrainedSidebar _cancelButtonList() {
    return ConstrainedSidebar(
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: CancelButtonList(
          cancelButtons: _cancelButtons,
          removeCancelButton: (CancelButtonController controller) { _removeCancelButton(controller); },
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) =>
  Stack(
    children: [
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _setOption(_priorityOption),
        child: Row(
          children: [
            _cancelButtonList(),
            UserDisplay(
              employee: _activeEmployee,
              setEmployee: _setEmployee,
              optionSelected: _optionSelected,
              options: _options,
              setOption: _setOption,
            ),
            ConstrainedSidebar(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: EmployeeList(employees: _employees),
              ),
            ),
          ],
        ),
      ),
      CardReaderInput(
        onSubmitted: (String rfid) {
          cardReaderSubmit(
            rfid: rfid, 
            optionSelected: _optionSelected, 
            errorContext: context, 
            addCancelButton: _addCancelButton,
            removeCancelButton: _removeCancelButton,
            setEmployee: _setEmployee,
            updateEmployeesCallback: _updateEmployees,
            resetSelected: () => _setOption(_priorityOption)
          ); 
        }
      ),
    ],
  );
}