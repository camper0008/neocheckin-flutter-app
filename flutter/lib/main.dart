import 'package:flutter/material.dart';
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
  //int _optionSelected = 0;
  Time _flex = new Time();

  //void _setOption(int option) {
  //  setState(() {
  //    _optionSelected = option;
  //  });
  //}

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
            TextButton(onPressed: _incFlex, child: Text('Increase')),
            TextButton(onPressed: _decFlex, child: Text('Decrease')),
          ],
        ),
      ),
    );
  }
}
