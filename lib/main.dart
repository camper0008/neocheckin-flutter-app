import 'dart:async';
import 'package:flutter/material.dart';
import 'package:neocheckin/components/cancel_button.dart';
import 'package:neocheckin/components/cancel_button_list.dart';
import 'package:neocheckin/components/card_reader_input.dart';
import 'package:neocheckin/components/option_display.dart';
import 'package:neocheckin/components/employee_list.dart';
import 'package:neocheckin/components/constrained_sidebar.dart';
import 'package:neocheckin/models/option.dart';
import 'package:neocheckin/responses/employee.dart';
import 'package:neocheckin/responses/employees_working.dart';
import 'package:neocheckin/components/flex_display.dart';
import 'package:neocheckin/models/employee.dart';
import 'package:neocheckin/responses/options_available.dart';
import 'package:neocheckin/utils/http_request.dart';

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
      home: const Scaffold(
        body: HomePage()
      ),
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
  Employee _activeEmployee = NullEmployee();
  Map<String, List<Employee>> _employees = {};
  String _errorMessage = '';

  void _setOption(Option option) => setState(() => _optionSelected = option );
  void _setEmployee(Employee employee) => setState(() => _activeEmployee = employee );
  void _displayError(String message) => setState(() => _errorMessage = message);

  void _updateOptions() async {
    Map<String, dynamic> body = await HttpRequest.get('$apiUrl/options/available', _displayError);
    OptionsAvailableResponse response = OptionsAvailableResponse.fromJson(body);
    if (response.error == 'none') {
      bool isIdentical = (_options.length == response.options.length);
      if (isIdentical) {
        for (int i = 0; i < _options.length; ++i) {
          if (_options[i].id != response.options[i].id) {
            isIdentical = false;
          }
        }
      }
      if (!isIdentical) setState(() => _options = response.options);
    }

    Timer(const Duration(minutes: 1), _updateOptions);
  }
  void _updateEmployees() async {
    Map<String, dynamic> body = await HttpRequest.get('$apiUrl/employees/working', _displayError);
    EmployeesWorkingResponse response = EmployeesWorkingResponse.fromJson(body);
    if (response.error == 'none') {
      setState(() => _employees = response.ordered );
    }
  }
  void _updateCancelButtons(CancelButtonController controller, { bool remove = false }) {
    setState(() {
      if (!remove) {
        _cancelButtons.add(controller);
      } else {
        _cancelButtons.removeWhere((p) => p == controller);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _updateEmployees();
    _updateOptions();
  }

  @override
  Widget build(BuildContext context) =>
  Stack(
    children: [
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {_setOption(NullOption());},
        child: Row(
          children: [
            ConstrainedSidebar(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: CancelButtonList(
                  cancelButtons: _cancelButtons,
                  removeCancelButton: (CancelButtonController controller) { _updateCancelButtons(controller, remove: true); },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    if (_activeEmployee is! NullEmployee)
                      Expanded(
                        child: FlexDisplay(employee: _activeEmployee, setEmployee: _setEmployee),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16, top: 8),
                      child: OptionDisplay(
                        selected: _optionSelected, 
                        options: _options, 
                        stateFunction: _setOption
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ConstrainedSidebar(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: EmployeeList(employees: _employees),
              ),
            ),
          ],
        ),
      ),
      CardReaderInput(
        onSubmitted: (String value) async {
          Map<String, dynamic> body = await HttpRequest.get('$apiUrl/employee/$value', _displayError);
          EmployeeResponse response = EmployeeResponse.fromJson(body);
          Employee employee = response.employee;
          if (response.error == 'none') {
            _setEmployee(response.employee);
            Option optionCache = _optionSelected;
            _updateCancelButtons(
              CancelButtonController(
                duration: 5,

                action: 'check ' 
                  + (employee.working ? ('ud' + (_optionSelected.id != -1 ? ' (' + _optionSelected.name.toLowerCase() + ')' : '')) : 'ind') 
                  + ' for ' 
                  + employee.name.split(' ')[0], 

                callback: () async {
                  Map<String, dynamic> httpReq = {
                    "employeeId": value,
                    "optionId": optionCache.id,
                    "checkingIn": !employee.working, 
                  };
                  await HttpRequest.post('$apiUrl/employee/cardscanned', httpReq, _displayError);
                  _updateEmployees();
                },

                unmountCallback: (CancelButtonController controller) { _updateCancelButtons(controller, remove: true); },

              )
            );
            _setOption(NullOption());
          }
        }
      ),
      if (_errorMessage != '') 
      AlertDialog(
        title: const Text('En fejl opstod:'),
        content: SingleChildScrollView(
          child: Text(
            _errorMessage,
            style: const TextStyle(fontFamily: 'RobotoMono')
          ),
        ),
        actions: [
          TextButton(
            onPressed: (){_displayError('');}, 
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'OK', style: TextStyle(fontSize: 20),
              ),
            )
          )
        ]
      ),
    ],
  );
}