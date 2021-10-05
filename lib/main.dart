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
              void func () async{
                var data = await HttpRequest.get('http://localhost:8079/api/user/$value');
                _setName(data['user']['username']);
                _setCheckOutState(data['user']['checkedIn']);

                _setOption(-1);
                _addCancelButton(
                  CancelButtonController(
                    action: 'Check in with id $value', 
                    callback: (){
                      Map<String, dynamic> httpReq = {
                        "userid": value,
                      };
                      HttpRequest.post('http://localhost:8079/api/cardscanned', httpReq);
                    },
                    duration: 5,
                    unmountCallback: _removeCancelButton,
                  )
                );
              }
              func();
            },
          ),
        ],
      ),
    );
  }
}
