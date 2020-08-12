import 'package:flutter/material.dart';
import 'package:todo/Shared/colors.dart';
import 'package:todo/Shared/horizontaldivider.dart';
import 'package:todo/models/user.dart';
import 'package:todo/services/auth.dart';

class AuthenticateHome extends StatefulWidget {
  @override
  _AuthenticateHomeState createState() => _AuthenticateHomeState();
}

class _AuthenticateHomeState extends State<AuthenticateHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whitebg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                  child: Text(
                "Welcome  To",
                style: TextStyle(
                    color: white, fontWeight: FontWeight.w400, fontSize: 23),
              )),
              SizedBox(
                height: 5,
              ),
              Center(
                  child: Text(
                "To - Do",
                style: TextStyle(
                    color: white, fontWeight: FontWeight.bold, fontSize: 28),
              )),
              SizedBox(
                height: 8,
              ),
              HorizontalDivider(
                color: secondarycolor,
                height: 4,
                width: MediaQuery.of(context).size.width * 0.3,
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Center(
                      child: Text(
                    "Manage your projects and create your own workspace and assign tasks",
                    style: TextStyle(
                        color: white,
                        fontWeight: FontWeight.w300,
                        fontSize: 20),
                  ))),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.06,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(5)),
                  child: RaisedButton(
                    color: secondarycolor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Image.asset('assets/images/google.png'),
                        ),
                        Text(
                          "Continue with Google",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                    onPressed: () async {
                      User user = await AuthService().signinwithGoogle();
                      print(user.uid);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
