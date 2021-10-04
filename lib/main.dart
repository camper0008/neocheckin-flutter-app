import 'package:flutter/material.dart';
import 'package:neocheckin/components/Option.dart';
import 'package:neocheckin/components/WorkerDisplay.dart';
import '/components/FlexDisplay.dart';
import '/utils/Time.dart';

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
  int _optionSelected = -1;
  String _name = 'User';
  bool _checkedIn = false;
  Time _flex = new Time();
  FocusNode _cardFieldFocusNode = FocusNode(skipTraversal: true, canRequestFocus: true, descendantsAreFocusable: true);
  TextEditingController _cardFieldController = TextEditingController();

  void _setOption(int option) {
    setState(() {
      _optionSelected = option;
    });
  }
  void _setName(String name) {
    setState(() {
      _name = name;
    });
  }
  void _setCheckOutState(bool option) {
    setState(() {
      _checkedIn = option;
    });
  }

    @override
  void dispose() {
    _cardFieldFocusNode.dispose();
    _cardFieldController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 64.0),
              child: WorkerDisplay(workers: {
                'department': List.filled(4, 'camper'),
                'department2': List.filled(4, 'camper'),
              }),
            ),
          ),
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 36), 
                  child: FlexDisplay(flex: _flex, name: _name, checkedIn: _checkedIn),
                ),
                Option(
                  selected: _optionSelected, 
                  options: [
                    'Gåtur', 
                    'Aftale',
                  ], 
                  stateFunction: _setOption
                ),
                Container(
                  width: 0,
                  child: TextField(
                    autofocus: true,
                    onSubmitted: (String value) {
                      _setOption(-1);
                      _cardFieldController.clear();
                      _cardFieldFocusNode.requestFocus();
                    },
                    focusNode: _cardFieldFocusNode,
                    controller: _cardFieldController,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
