import 'package:flutter/material.dart';
import 'package:neocheckin/components/Option.dart';
import '/components/FlexDisplay.dart';
import '/utils/Time.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _optionSelected = 0;
  String _name = 'User';
  bool _checkedIn = false;
  Time _flex = new Time();

  void _setOption(int option) {
    setState(() {
      _optionSelected = option;
    });
  }
  void _setName(String name) {
    setState(() {
    });
  }
  void _setCheckOutState(int option) {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 36), 
              child: FlexDisplay(flex: _flex, name: _name, checkedIn: _checkedIn),
            ),
              Option(
                selected: _optionSelected, 
                options: ['zero', 'one', 'two'], 
                stateFunction: _setOption
              ),
          ],
        ),
      ),
    );
  }
}
