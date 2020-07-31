class TimeInstance {
  String starttime;
  String taskuid;
  String taskname;
  DateTime time;

  TimeInstance({this.taskuid, this.starttime, this.time, this.taskname});

  Map<String, dynamic> toJson() => {
        'taskuid': taskuid,
        'taskname': taskname,
        'time': time.toIso8601String(),
      };

  TimeInstance.fromJson(Map<String, dynamic> json)
      : taskuid = json['taskuid'],
        taskname = json['taskname'],
        time = DateTime.parse(json['time']);
}
