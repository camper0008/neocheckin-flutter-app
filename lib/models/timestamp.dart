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

  Timestamp.fromJson(Map<String, dynamic> json)
    : year         = json['year'],
      month        = json['month'],
      day          = json['day'],
      hour         = json['hour'],
      minute       = json['minute'],
      seconds      = json['seconds'],
      milliSeconds = json['milliSeconds'],
      isoDate          = json['dateTime'],
      date         = json['date'],
      time         = json['time'],
      dstActive    = json['dstActive'];
}