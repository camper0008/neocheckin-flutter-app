// https://www.timeapi.io/api/Time/current/zone?timeZone=Europe/Copenhagen

dynamic _valueOrDefault(dynamic v, dynamic d) {
  if (v.runtimeType == null.runtimeType) {
    return d;
  } else {
    return v;
  }
}

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

  Timestamp.fromJson(Map<String, dynamic> json)
    : year         = _valueOrDefault(json['year'], 0),
      month        = _valueOrDefault(json['month'], 0),
      day          = _valueOrDefault(json['day'], 0),
      hour         = _valueOrDefault(json['hour'], 0),
      minute       = _valueOrDefault(json['minute'], 0),
      seconds      = _valueOrDefault(json['seconds'], 0),
      milliSeconds = _valueOrDefault(json['milliSeconds'], 0),
      isoDate      = _valueOrDefault(json['dateTime'], ""),
      date         = _valueOrDefault(json['date'], ""),
      time         = _valueOrDefault(json['time'], ""),
      dstActive    = _valueOrDefault(json['dstActive'], false);
}