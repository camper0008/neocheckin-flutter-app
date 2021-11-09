import 'dart:async';
import 'package:flutter/material.dart';
import 'package:neocheckin/components/cancel_button_list.dart';
import 'package:neocheckin/components/card_reader_input.dart';
import 'package:neocheckin/components/clock_time.dart';
import 'package:neocheckin/components/flex_and_option_display.dart';
import 'package:neocheckin/components/employee_list.dart';
import 'package:neocheckin/models/option.dart';
import 'package:neocheckin/state_manager.dart';
import 'package:neocheckin/utils/config.dart';
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

class _HomePageState extends State<HomePage> implements StateManagable {
  late StateManager _stateManager;

  @override
  void refreshState() {setState((){});}

  void _updateOptions() async {
    List<Option>? updated = await getUpdatedOptions(context);
    if (updated != null) {
      bool isIdentical = optionsAreIdentical(_stateManager.options, updated);
      if (!isIdentical) {
        _stateManager.options = updated;
        _stateManager.setPriorityOrNullOption();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _stateManager = StateManager(state: this);
    _updateOptions();
    configFileExists(context);
    Timer.periodic(const Duration(minutes: 1), (Timer t) {_updateOptions();});
  }

  @override
  Widget build(BuildContext context) =>
  Stack(
    children: [
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => { _stateManager.setPriorityOrNullOption() },
        child: Row(
          children: [
            constrainedCancelButtonList(_stateManager),
            UserDisplay(
              stateManager: _stateManager,
            ),
            constrainedEmployeeList(),
          ],
        ),
      ),
      cornerTimer(),
      CardReaderInput(
        onSubmitted: (String rfid) {
          cardReaderSubmit(
            rfid: rfid, 
            stateManager: _stateManager, 
            errorContext: context, 
          ); 
        }
      ),
    ],
  );
}