// im really sorry
import 'package:flutter/widgets.dart';
import 'package:neocheckin/components/cancel_button.dart';
import 'package:neocheckin/models/employee.dart';
import 'package:neocheckin/models/option.dart';
import 'package:neocheckin/models/timestamp.dart';
import 'package:neocheckin/responses/employee.dart';
import 'package:neocheckin/utils/display_error.dart';
import 'package:neocheckin/utils/http_request.dart';
import 'package:neocheckin/utils/http_requests/get_timestamp.dart';


_sendCardScanRequest({
  required BuildContext errorContext, required String rfid, 
  required int optionId, required Function() updateEmployees
}) async {
  Timestamp timestamp = await getUpdatedTimestamp(errorContext);

  Map<String, dynamic> httpReq = {
    // TODO: implement correctly
    "employeeRfid": rfid,
    "option": optionId,
    "apiKey": "",
    "systemId": "test-01",
    "timestamp": timestamp.isoDate,
  };
  await HttpRequest.httpPost('$apiUrl/employee/cardscanned', httpReq, errorContext);
  updateEmployees();
}

Future<Employee> _getEmployeeFromRfid(String rfid, BuildContext context) async {
  Map<String, dynamic> body = await HttpRequest.httpGet('$apiUrl/employee/$rfid', context);
  EmployeeResponse response = EmployeeResponse.fromJson(body);
  return response.employee;
}

cardReaderSubmit({
  required BuildContext errorContext, required String rfid, 
  required Option optionSelected, required Function() resetSelected,
  required Function(Employee) setEmployee, required Function() updateEmployeesCallback,
  required Function(CancelButtonController) addCancelButton, required Function(CancelButtonController) removeCancelButton,
}) async {
  if (optionSelected is NullOption) return displayError(errorContext, "Du skal vælge en mulighed.");

  Employee employee = await _getEmployeeFromRfid(rfid, errorContext);
  if (employee is! NullEmployee) {
    setEmployee(employee);
    addCancelButton(
      CancelButtonController(
        duration: 5,
        action: optionSelected.name.toLowerCase() + ' for ' + employee.name.split(' ')[0],
        callback: () =>
          _sendCardScanRequest(
            errorContext: errorContext,
            rfid: rfid, 
            optionId: optionSelected.id, 
            updateEmployees: updateEmployeesCallback,
          ),
        unmountCallback: removeCancelButton,
      )
    );
  }
  resetSelected();
}
