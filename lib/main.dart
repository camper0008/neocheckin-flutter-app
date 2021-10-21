import 'dart:async';
import 'package:flutter/material.dart';
import 'package:neocheckin/components/cancel_button.dart';
import 'package:neocheckin/components/cancel_button_list.dart';
import 'package:neocheckin/components/card_reader_input.dart';
import 'package:neocheckin/components/flex_and_option_display.dart';
import 'package:neocheckin/components/employee_list.dart';
import 'package:neocheckin/components/constrained_sidebar.dart';
import 'package:neocheckin/models/option.dart';
import 'package:neocheckin/models/timestamp.dart';
import 'package:neocheckin/responses/employees_working.dart';
import 'package:neocheckin/models/employee.dart';
import 'package:neocheckin/utils/config.dart';
import 'package:neocheckin/utils/http_request.dart';
import 'package:neocheckin/utils/http_requests/card_scanned.dart';
import 'package:neocheckin/utils/http_requests/get_timestamp.dart';
import 'package:neocheckin/utils/http_requests/get_updated_options.dart';
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
  Map<String, List<Employee>> _workingEmployees = {};
  final Stopwatch _stopwatch = Stopwatch();
  int _initialTime = 0;
  Time _clockTime = Time();

  void _setOption(Option option) => setState(() => _optionSelected = option );
  void _setEmployee(Employee employee) => setState(() => _activeEmployee = employee );

  void _updateClockTime() async {
    setState(() => _clockTime.setSeconds(_initialTime + _stopwatch.elapsed.inSeconds));

    Timer(const Duration(seconds: 1), _updateClockTime);
  }
  void _recalibrateClockTime() async {
    Timestamp result = await getUpdatedTimestamp(context);
    _clockTime = Time(hours: result.hour, minutes: result.minute, seconds: result.seconds);
    _initialTime = _clockTime.getSeconds();

    _stopwatch.stop();
    _stopwatch.reset();
    _stopwatch.start();

    Timer(const Duration(hours: 1), _recalibrateClockTime);
  }
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
    Map<String, dynamic> body = await HttpRequest.httpGet((await config)["API_URL"]! + '/employees/working', context);
    EmployeesWorkingResponse response = EmployeesWorkingResponse.fromJson(body);
    if (response.error == 'none') {
      setState(() => _workingEmployees = response.ordered );
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
    _recalibrateClockTime();
    _updateClockTime();
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
                child: EmployeeList(employees: _workingEmployees),
              ),
            ),
          ],
        ),
      ),
      Align(
        alignment: Alignment.topLeft,
        child: Container(
          color: Colors.white,
          margin: const EdgeInsets.all(32.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _clockTime.getFormattedHours() + 
              ":" + _clockTime.getFormattedMinutes() + 
              ":" + _clockTime.getFormattedSeconds(),
              style: const TextStyle(
                fontSize: 44,
                backgroundColor: Colors.white,
              ),
            ),
          ),
        )
      ),
      CardReaderInput(
        onSubmitted: (String rfid) {
          // ¯\_(ツ)_/¯
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