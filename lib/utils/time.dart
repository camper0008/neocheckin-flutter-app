class Time {
  int time = 0;
  Time({int seconds = 0, int minutes = 0, int hours = 0}) {
    time = seconds + minutes*60 + hours*60*60;
  }
  Time.now() : time = DateTime.now().millisecondsSinceEpoch ~/ 1000;

  void setSeconds(int seconds) {
    time = seconds;
  }

  int getSeconds() {return time;}
  int getMinutes() {return (time / 60).round();}
  int getHours()   {return (time / 60 / 60).round();}
  bool isNegative() {return time < 0;}

  String getFormattedHours([ bool? padded = true ]) {
    int absTime = time.abs();
    int minutes = ((absTime - absTime%60)/60).round();
    int hours = ((minutes - minutes%60)/60).round();
    if (padded == true && hours < 10) {
      return '0' + hours.toString();
    }
    return hours.toString();
  }

  String getFormattedMinutes([ bool? padded = true ]) {
    int absTime = time.abs();
    int minutes = ((absTime - absTime%60)/60).round()%60;
    if (padded == true && minutes < 10) {
      return '0' + minutes.toString();
    }
    return minutes.toString();
  }

  String getFormattedSeconds([ bool? padded = true ]) {
    int absTime = time.abs()%60;
    if (padded == true && absTime < 10) {
      return '0' + absTime.toString();
    }
    return absTime.toString();
  }

}