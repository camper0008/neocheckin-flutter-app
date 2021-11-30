// im really sorry
import 'package:flutter/widgets.dart';
import 'package:neocheckin/components/cancel_button.dart';
import 'package:neocheckin/models/employee.dart';
import 'package:neocheckin/models/option.dart';
import 'package:neocheckin/models/timestamp.dart';
import 'package:neocheckin/responses/employee.dart';
import 'package:neocheckin/state_manager.dart';
import 'package:neocheckin/utils/config.dart';
import 'package:neocheckin/utils/display_error.dart';
import 'package:neocheckin/utils/http_request.dart';
import 'package:neocheckin/utils/http_requests/get_timestamp.dart';


_sendCardScanRequest({
  required BuildContext errorContext, required String rfid, 
  required Option option
}) async {
  Timestamp timestamp = await getUpdatedUTCTimestamp(errorContext);

  Map<String, dynamic> httpReq = {
    "employeeRfid": rfid,
    "name": option.name,
    "option": option.id,
    "apiKey": (await config)["WRAPPER_POST_KEY"],
    "systemId": (await config)["SYSTEM_ID"],
    "timestamp": timestamp.isoDate,
  };

  String url = await cacheUrl;
  await HttpRequest.httpPost(url + '/employee/cardscanned', httpReq, errorContext);
}

Future<Employee> _getEmployeeFromRfid(String rfid, BuildContext context) async {
  String url = await cacheUrl;

  Map<String, dynamic> body = await HttpRequest.httpGet(url + '/employee/$rfid', context);
  EmployeeResponse response = EmployeeResponse.fromJson(body);
  return response.employee;
}

cardReaderSubmit({
  required BuildContext errorContext, required String rfid, 
  required StateManager stateManager,
}) async {
  if (stateManager.activeOption is NullOption) return displayError(errorContext, "Du skal vælge en mulighed.");
  if (rfid == '') return displayError(errorContext, "Tekstfelt tom.");

  Employee employee = await _getEmployeeFromRfid(rfid, errorContext);
  if (employee is! NullEmployee) {
    if (!employee.working && stateManager.activeOption.category == "check in" || 
         employee.working && stateManager.activeOption.category == "check out") {
      stateManager.activeEmployee = employee;
      stateManager.addCancelButton(
        CancelButtonController(
          duration: 10,
          action: stateManager.activeOption.displayName.toLowerCase() + ' for ' + employee.name.split(' ')[0],
          callback: () =>
            _sendCardScanRequest(
              errorContext: errorContext,
              rfid: rfid, 
              option: stateManager.activeOption, 
            ),
          unmountCallback: stateManager.removeCancelButton,
        )
      );
    } else if (!employee.working) {
      displayError(errorContext, "Du kan ikke tjekke ud, når du ikke er tjekket ind.");
    } else if (employee.working) {
      displayError(errorContext, "Du kan ikke tjekke ind, når du ikke er tjekket ud.");
    }

  }
  stateManager.setPriorityOrNullOption();
}
