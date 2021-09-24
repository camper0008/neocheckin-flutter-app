import 'package:flutter/material.dart';
import 'package:neocheckin/components/Option.dart';
import '/components/FlexDisplay.dart';
import 'utils/Time.dart';

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
  Time _flex = new Time();
  List<bool> _isSelected = [true, false, false];

  void _setOption(int option) {
    setState(() {
      _optionSelected = option;
    });
  }

  void _incFlex(/*int flex*/) {
    setState(() {
      _flex.addSeconds(60); //flex;
    });
  }
  void _decFlex(/*int flex*/) {
    setState(() {
      _flex.addSeconds(-60); //flex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlexDisplay(flex: _flex),
            Padding(
              padding: EdgeInsets.only(top: 36), 
              child: Option(selected: 2, options: ['1', '2', '3']),
            ),
          ],
        ),
      ),
    );
  }
}
