import 'package:flutter/material.dart';
import 'package:neocheckin/components/cancel_button.dart';
import 'package:neocheckin/components/cancel_button_list.dart';
import 'package:neocheckin/components/card_reader_input.dart';
import 'package:neocheckin/components/option.dart';
import 'package:neocheckin/components/worker_display.dart';
import 'components/flex_display.dart';
import 'utils/http_request.dart';
import 'utils/time.dart';

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
  String _name = 'User';
  bool _checkedIn = false;
  Map<String, List<String>> _workers = {};

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
  void _updateWorkers() {
    (() async {
      Map<String, dynamic> body = await HttpRequest.get('http://localhost:8079/api/workers');
      if (body['error_msg'].runtimeType != null.runtimeType) return;
      Map<String, List<String>> data = body['workers'].map<String, List<String>>((key, value) {
        List<String> newArray = [];
        for (int i = 0; i < value.length; ++i) {
          newArray.add(value[i].toString());
        }
        return MapEntry(key.toString(), newArray);
      });
      setState(() {
        _workers = data;
      });
    })();
  }
  void _setFlex(int seconds) {
    setState(() {
      _flex.setSeconds(seconds);
    });
  }
  void _setCheckOutState(bool option) {
    setState(() {
      _checkedIn = option;
    });
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
    _updateWorkers();
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
              child: WorkerDisplay(workers: _workers),
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
                Map<String, dynamic> body = await HttpRequest.get('http://localhost:8079/api/user/$value');
                if (body['error_msg'].runtimeType != null.runtimeType) return;
                _setName(body['user']['name']);
                _setCheckOutState(!body['user']['checkedIn']);
                _setFlex(body['user']['flex']);
                _setOption(-1);
                _addCancelButton(
                  CancelButtonController(
                    action: 'check ' + (body['user']['checkedIn'] == true ? 'ud' : 'ind'), 
                    callback: () async {
                      Map<String, dynamic> httpReq = {
                        "userid": value,
                      };
                      await HttpRequest.post('http://localhost:8079/api/cardscanned', httpReq);
                      _updateWorkers();
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
