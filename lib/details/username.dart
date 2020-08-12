import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/Shared/colors.dart';
import 'package:todo/database/database.dart';
import 'package:todo/details/details.dart';
import 'package:todo/models/user.dart';

class Username extends StatefulWidget {
  @override
  _UsernameState createState() => _UsernameState();
}

class _UsernameState extends State<Username> {
  String errormessage = '';
  bool visible = false;
  String username = '';
  bool loading = false;

  Widget _username() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.06,
        decoration: BoxDecoration(
          color: secondarycolor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: TextFormField(
            onChanged: (val) {
              setState(() {
                visible = false;
                username = val;
              });
            },
            keyboardType: TextInputType.emailAddress,
            textAlign: TextAlign.left,
            style: TextStyle(color: white, fontWeight: FontWeight.normal),
            decoration: InputDecoration(
              fillColor: black,
              focusColor: Colors.yellow,
              border: InputBorder.none,
              hintText: 'Username',
              hintStyle: TextStyle(
                  color: Colors.grey[200],
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                  fontFamily: 'OpenSans'),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Scaffold(
      backgroundColor: whitebg,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            child: RaisedButton(
              color: Colors.black,
              onPressed: () async {
                if (username.isNotEmpty) {
                  if (username.length < 4) {
                    setState(() {
                      errormessage = "username should be atleast 3 characters";
                      visible = true;
                    });
                  } else {
                    setState(() {
                      loading = true;
                    });
                    DatabaseService(email: user.email)
                        .isUsernameAvailable(username)
                        .then((value) async {
                      if (value == true) {
                        await new Future.delayed(const Duration(seconds: 2));
                        setState(() {
                          visible = false;
                          loading = false;
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Details(
                                      username: username,
                                    )));
                      } else {
                        setState(() {
                          errormessage = "username not available";
                          visible = true;
                          loading = false;
                        });
                      }
                    });
                  }
                }
                if (username.isEmpty) {
                  setState(() {
                    errormessage = "enter username";
                    visible = true;
                  });
                }
              },
              child: loading
                  ? CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    )
                  : Text(
                      "Next",
                      style: TextStyle(color: Colors.white),
                    ),
            )),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Choose a Unique username to create your account',
                  style: TextStyle(color: white, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 10,
                ),
                _username(),
                //SizedBox(height: 5,),
                Padding(
                  padding: const EdgeInsets.only(left: 35.0),
                  child: Row(
                    children: <Widget>[
                      visible
                          ? Text(
                              errormessage,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w400),
                            )
                          : Text(''),
                    ],
                  ),
                ),

                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
