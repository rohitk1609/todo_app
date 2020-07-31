import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:todo/models/timermodel.dart';
import 'package:todo/models/user.dart';
import 'package:todo/models/workspacemodel.dart';
import 'package:todo/services/auth.dart';
import 'package:todo/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );

  runApp(MyApp(
    timermodel: Timermodel(),
    workpsacemodel: Workpsacemodel(),
  ));
}

class MyApp extends StatelessWidget {
  final Timermodel timermodel;
  final Workpsacemodel workpsacemodel;

  const MyApp({Key key, this.timermodel, this.workpsacemodel})
      : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: ScopedModel<Timermodel>(
        model: timermodel,
        child: ScopedModel<Workpsacemodel>(
          model: workpsacemodel,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: wrapper(),
          ),
        ),
      ),
    );
  }
}
