import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:todo/models/task.dart';

class Timermodel extends Model {
  Task task;
  String time = '00:00:00';
  String ttime = '00:00:00';
  bool isrunning = false;
  var swatch = Stopwatch();

  final dur = const Duration(seconds: 1);
  Task get currenttask => task;

  String get currenttime => time;

  void changetask(Task task) {
    this.task = task;
    notifyListeners();
  }

  void resettask() {
    this.task = null;
    notifyListeners();
  }

  void settime(String val) {
    this.ttime = val;
    notifyListeners();
  }

  void starttimer() {
    Timer(dur, keeprunning);
  }

  void keeprunning() {
    this.time = (swatch.elapsed.inHours + int.parse(this.ttime.split(':')[0]))
            .toString()
            .padLeft(2, "0") +
        ":" +
        (swatch.elapsed.inMinutes % 60 + int.parse(this.ttime.split(':')[1]))
            .toString()
            .padLeft(2, "0") +
        ":" +
        (swatch.elapsed.inSeconds % 60 + int.parse(this.ttime.split(':')[2]))
            .toString()
            .padLeft(2, "0");
    notifyListeners();
    if (swatch.isRunning) {
      starttimer();
    }
  }

  void startstopwatch() {
    swatch.start();
    this.isrunning = true;
    starttimer();
    notifyListeners();
  }

  void runningstate() {
    this.isrunning = !this.isrunning;
    notifyListeners();
  }

  void stopstopwatch() {
    swatch.reset();
    swatch.stop();
    this.isrunning = false;
    this.time = '00:00:00';
    this.ttime = '00:00:00';

    notifyListeners();
  }
}
