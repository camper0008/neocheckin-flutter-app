import "dart:io";

import 'package:flutter/widgets.dart';
import 'package:neocheckin/utils/display_error.dart';

var _didError = false; // to prevent a loop if something goes wrong with playing audio
void playAlert(BuildContext errorContext) async {
  if (!_didError) {
    // requires sox package or some other command that can play audio
    try {
      ProcessResult res = await Process.run("play", ["./assets/sounds/alert.wav"]);
      if (res.exitCode != 0) {
        _didError = true;
        displayError(errorContext, "Something went wrong trying to play the alert sound. Possibly unable to find command 'play' or sound file.");
      }
    } catch(error) {
        _didError = true;
        displayError(errorContext, 'Something went wrong playing audio, are you missing the sox package?\n' + error.toString());
    }
  }
}