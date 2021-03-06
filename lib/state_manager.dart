import 'dart:async';
import 'package:neocheckin/components/cancel_button.dart';
import 'package:neocheckin/models/employee.dart';
import 'package:neocheckin/models/option.dart';
import 'package:neocheckin/utils/http_requests/get_updated_options.dart';
import 'package:neocheckin/utils/time.dart';


abstract class StateManagable {
  void refreshState();
}


class StateManager {
  int _activeEmployeeLastUpdated = 0;
  Employee _activeEmployee = NullEmployee();
  Option _activeOption = NullOption();
  List<Option> _options = [];
  final List<CancelButtonController> _cancelButtons = [];
  late StateManagable _state;

  StateManager({required StateManagable state}) {
    _state = state;
  }

  Employee get activeEmployee {
    return _activeEmployee;
  }
  set activeEmployee(Employee e) {
    _activeEmployeeLastUpdated = Time.now().getSeconds();
    if (e is! NullEmployee) {
      _setActiveEmployeeTimeout();
    }
    _activeEmployee = e;
    _state.refreshState();
  }

  void _setActiveEmployeeTimeout() {
    int _scopedLastUpdated = _activeEmployeeLastUpdated;
    Timer(const Duration(seconds: 5), (){
      if (_activeEmployeeLastUpdated == _scopedLastUpdated) {
        activeEmployee = NullEmployee();
      }
    });
  }

  Option get activeOption {
    return _activeOption;
  }
  set activeOption(Option o) {
    _activeOption = o;
    _state.refreshState();
  }
  List<Option> get options {
    return _options;
  }
  set options(List<Option> o) {
    _options = o;
    _state.refreshState();
  }
  void setPriorityOrNullOption() {
    _activeOption = getPriorityOrNullOption(options);
    _state.refreshState();
  }

  List<CancelButtonController> get cancelButtons {
    return _cancelButtons;
  }
  void addCancelButton(CancelButtonController controller) {
    _cancelButtons.add(controller);
    _state.refreshState();
  }
  void removeCancelButton(CancelButtonController controller) {
    _cancelButtons.removeWhere((p) => p == controller);
    _state.refreshState();
  }
}