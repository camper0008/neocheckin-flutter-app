// im really sorry
import 'package:flutter/widgets.dart';
import 'package:neocheckin/components/cancel_button.dart';
import 'package:neocheckin/models/employee.dart';
import 'package:neocheckin/models/option.dart';
import 'package:neocheckin/models/timestamp.dart';
import 'package:neocheckin/responses/employee.dart';
import 'package:neocheckin/utils/config.dart';
import 'package:neocheckin/utils/display_error.dart';
import 'package:neocheckin/utils/http_request.dart';
import 'package:neocheckin/utils/http_requests/get_timestamp.dart';


_sendCardScanRequest({
  required BuildContext errorContext, required String rfid, 
  required Option option, required Function() updateEmployees
}) async {
  Timestamp timestamp = await getUpdatedTimestamp(errorContext);

  Map<String, dynamic> httpReq = {
    "employeeRfid": rfid,
    "name": option.name,
    "option": option.id,
    "apiKey": (await config)["API_KEY"],
    "systemId": (await config)["SYSTEM_ID"],
    "timestamp": timestamp.isoDate,
  };
  await HttpRequest.httpPost((await config)["API_URL"]! + '/employee/cardscanned', httpReq, errorContext);
  updateEmployees();
}

Future<Employee> _getEmployeeFromRfid(String rfid, BuildContext context) async {
  Map<String, dynamic> body = await HttpRequest.httpGet((await config)["API_URL"]! + '/employee/$rfid', context);
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
  if (rfid == '') return displayError(errorContext, "Tekstfelt tom.");

  Employee employee = await _getEmployeeFromRfid(rfid, errorContext);
  if (employee is! NullEmployee) {
    if (!employee.working && optionSelected.category == "check in" || 
         employee.working && optionSelected.category == "check out") {
      setEmployee(employee);
      addCancelButton(
        CancelButtonController(
          duration: 10,
          action: optionSelected.displayName.toLowerCase() + ' for ' + employee.name.split(' ')[0],
          callback: () =>
            _sendCardScanRequest(
              errorContext: errorContext,
              rfid: rfid, 
              option: optionSelected, 
              updateEmployees: updateEmployeesCallback,
            ),
          unmountCallback: removeCancelButton,
        )
      );
    } else if (!employee.working) {
      displayError(errorContext, "Du kan ikke checke ud, når du ikke er checket ind.");
    } else if (employee.working) {
      displayError(errorContext, "Du kan ikke checke ind, når du ikke er checket ud.");
    }

  }
  resetSelected();
}
