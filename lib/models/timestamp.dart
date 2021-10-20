// https://www.timeapi.io/api/Time/current/zone?timeZone=Europe/Copenhagen

class Timestamp {
  final int year;
  final int month;
  final int day;
  final int hour;
  final int minute;
  final int seconds;
  final int milliSeconds;
  final String isoDate;         
  final String date;        
  final String time;        
  final bool dstActive;     

  Timestamp({
    this.year = 0, this.month = 0, this.day = 0, 
    this.hour = 0, this.minute = 0, this.seconds = 0, this.milliSeconds = 0,
    this.isoDate = "", this.date = "", this.time = "",
    this.dstActive = false
  });

  // TODO: refactor into functions
  Timestamp.fromJson(Map<String, dynamic> json)
    : year         = json['year'].runtimeType         != null.runtimeType ? json['year'] : 0,
      month        = json['month'].runtimeType        != null.runtimeType ? json['month'] : 0,
      day          = json['day'].runtimeType          != null.runtimeType ? json['day'] : 0,
      hour         = json['hour'].runtimeType         != null.runtimeType ? json['hour'] : 0,
      minute       = json['minute'].runtimeType       != null.runtimeType ? json['minute'] : 0,
      seconds      = json['seconds'].runtimeType      != null.runtimeType ? json['seconds'] : 0,
      milliSeconds = json['milliSeconds'].runtimeType != null.runtimeType ? json['milliSeconds'] : 0,
      isoDate      = json['dateTime'].runtimeType     != null.runtimeType ? json['dateTime'] : "",
      date         = json['date'].runtimeType         != null.runtimeType ? json['date'] : "",
      time         = json['time'].runtimeType         != null.runtimeType ? json['time'] : "",
      dstActive    = json['dstActive'].runtimeType    != null.runtimeType ? json['dstActive'] : false;
}