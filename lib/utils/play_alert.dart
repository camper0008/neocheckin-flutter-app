import "dart:io";

void playAlert() {
  // requires sox package
  Process.run("play", ["./assets/sounds/alert.wav"]);
}