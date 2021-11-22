import "dart:io";

void playAlert() {
  Process.run("play", ["./assets/sounds/alert.wav"]);
}