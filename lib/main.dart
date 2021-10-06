import 'dart:async';
import 'package:flutter/material.dart';
import 'package:neocheckin/components/cancel_button.dart';
import 'package:neocheckin/components/cancel_button_list.dart';
import 'package:neocheckin/components/card_reader_input.dart';
import 'package:neocheckin/components/option_display.dart';
import 'package:neocheckin/components/employee_list.dart';
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
      home: const HomePage(),
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

  void _setOption(Option option) {
    setState(() {
      _optionSelected = option;
    });
  }
  void _setEmployee(Employee employee) {
    setState(() {
      _activeEmployee = employee;
    });
  }
  void _updateOptions() {
    (() async {
      Map<String, dynamic> body = await HttpRequest.get('http://localhost:8079/api/options/available', _displayError);
      OptionsAvailableResponse response = OptionsAvailableResponse.fromJson(body);
      if (response.error == 'none') {
        bool isIdentical = (_options.length != response.options.length);
        if (isIdentical) {
          for (int i = 0; i < _options.length; ++i) {
            if (_options[i].id != response.options[i].id) {
              isIdentical = false;
            }
          }
          if (isIdentical) {
            setState(() {
              _options = response.options;
            });
          }
        }
      }
    })();

    Timer(const Duration(minutes: 1), _updateOptions);
  }
  void _updateEmployees() {
    (() async {
      Map<String, dynamic> body = await HttpRequest.get('http://localhost:8079/api/employees/working', _displayError);
      EmployeesWorkingResponse response = EmployeesWorkingResponse.fromJson(body);
      if (response.error == 'none') {
        setState(() {
          _employees = response.ordered;
        });
      }
    })();
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
  void _displayError(String message) {
    setState(() {
      _errorMessage = message;
    });
  }

  @override
  void initState() {
    super.initState();
    _updateEmployees();
    _updateOptions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CancelButtonList(
            cancelButtons: _cancelButtons,
            removeCancelButton: (CancelButtonController controller) { _updateCancelButtons(controller, remove: true); },
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 64.0),
              child: EmployeeList(employees: _employees),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 36), 
                child: FlexDisplay(employee: _activeEmployee, setEmployee: _setEmployee),
              ),
              OptionDisplay(
                selected: _optionSelected, 
                options: _options, 
                stateFunction: _setOption
              ),
            ],
          ),
          CardReaderInput(
            onSubmitted: (String value) async {
              Map<String, dynamic> body = await HttpRequest.get('http://localhost:8079/api/employee/$value', _displayError);
              EmployeeResponse response = EmployeeResponse.fromJson(body);
              Employee employee = response.employee;
              if (response.error == 'none') {
                _setEmployee(response.employee);
                Option optionCache = _optionSelected;
                _updateCancelButtons(
                  CancelButtonController(
                    action: 'check ' 
                      + (employee.working ? ('ud' + (_optionSelected.id != -1 ? ' med valg ' + _optionSelected.name : '')) : 'ind') 
                      + ' for ' 
                      + employee.name.split(' ')[0], 
                    callback: () async {
                      Map<String, dynamic> httpReq = {
                        "employeeId": value,
                        "optionId": optionCache.id,
                        "checkingIn": !employee.working, 
                      };
                      await HttpRequest.post('http://localhost:8079/api/employee/cardscanned', httpReq, _displayError);
                      _updateEmployees();
                    },
                    duration: 5,
                    unmountCallback: (CancelButtonController controller) { _updateCancelButtons(controller, remove: true); },
                  )
                );
                _setOption(NullOption());
              }
            }
          ),
          if (_errorMessage != '') AlertDialog(
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
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Text(
                    'OK', style: TextStyle(fontSize: 20),
                  ),
                )
              )
            ],
          ),
        ],
      ),
    );
  }
}
