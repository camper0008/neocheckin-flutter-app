import 'package:flutter/material.dart';
import 'package:neocheckin/components/cancel_button.dart';
import 'package:neocheckin/components/cancel_button_list.dart';
import 'package:neocheckin/components/card_reader_input.dart';
import 'package:neocheckin/components/option.dart';
import 'package:neocheckin/components/employee_list.dart';
import 'package:neocheckin/responses/employees_working.dart';
import 'package:neocheckin/components/flex_display.dart';
import 'package:neocheckin/models/employee.dart';
import 'package:neocheckin/utils/http_request.dart';
import 'package:neocheckin/utils/time.dart';

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
  final Time _flex = Time();
  int _optionSelected = -1;
  Employee _activeEmployee = NullEmployee();
  Map<String, List<Employee>> _employees = {};

  void _setOption(int option) {
    setState(() {
      _optionSelected = option;
    });
  }
  void _setEmployee(Employee employee) {
    setState(() {
      _activeEmployee = employee;
    });
  }
  void _updateEmployees() {
    (() async {
      Map<String, dynamic> body = await HttpRequest.get('http://localhost:8079/api/employees/working');
      EmployeesWorkingResponse response = EmployeesWorkingResponse.fromJson(body);
    })();
  }
  void _addCancelButton(CancelButtonController cancelButton) {
    setState(() {
      _cancelButtons.add(cancelButton);
    });
  }
  void _removeCancelButton(CancelButtonController cancelButton) {
    setState(() {
      _cancelButtons.removeWhere((p) => p == cancelButton);
    });
  }

  @override
  void initState() {
    super.initState();
    _updateEmployees();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CancelButtonList(
            cancelButtons: _cancelButtons,
            removeCancelButton: _removeCancelButton,
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
                child: Text(
                  (_checkedIn ? 'Du er nu checket ind' : 'Du er nu checket ud'),
                  style: const TextStyle(
                    fontSize: (14*3),
                  ),
                )
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 36), 
                child: FlexDisplay(flex: _flex, name: _name),
              ),
              Option(
                selected: _optionSelected, 
                options: const [
                  'Gåtur', 
                  'Aftale',
                ], 
                stateFunction: _setOption
              ),
            ],
          ),
          CardReaderInput(
            onSubmitted: (String value) {
              (() async{
                Map<String, dynamic> body = await HttpRequest.get('http://localhost:8079/api/employee/$value');
                if (body['error_msg'].runtimeType != null.runtimeType) return;
                _setUser(body['user']['name']);
                _setCheckOutState(!body['user']['checkedIn']);
                _setFlex(body['user']['flex']);
                _setOption(-1);
                _addCancelButton(
                  CancelButtonController(
                    action: 'check ' 
                    + (body['user']['checkedIn'] == true ? 'ud' : 'ind') 
                    + ' for ' 
                    + body['user']['name'].toString(), 
                    callback: () async {
                      Map<String, dynamic> httpReq = {
                        "userid": value,
                      };
                      await HttpRequest.post('http://localhost:8079/api/cardscanned', httpReq);
                      _updateEmployees();
                    },
                    duration: 5,
                    unmountCallback: _removeCancelButton,
                  )
                );
              })();
            },
          ),
        ],
      ),
    );
  }
}
