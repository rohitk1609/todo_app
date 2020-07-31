import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/database/database.dart';
import 'package:todo/models/teammember.dart';
import 'package:todo/models/user.dart';
import 'package:todo/screens/Profile/workspaceloading.dart';
import 'package:todo/wrapper.dart';

class Invite extends StatefulWidget {
  String workspacename;
  Invite({this.workspacename});
  @override
  _InviteState createState() => _InviteState();
}

class _InviteState extends State<Invite> {
  TextEditingController _emailcontroller = TextEditingController();

  List<String> emaillist = [];
  String email = '';
  bool visible = false;
  String errormessage = '';
  bool loading = false;
  Widget _email() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
      child: Row(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.70,
            padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 10),
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[900],
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[200], spreadRadius: 1, blurRadius: 4)
                ]),
            child: TextFormField(
              controller: _emailcontroller,
              keyboardType: TextInputType.text,
              maxLines: 1,
              onChanged: (val) {
                setState(() {
                  email = val;
                  visible = false;
                });
              },
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 15),
              decoration: InputDecoration(
                fillColor: Colors.white,
                focusColor: Colors.yellow,
                border: InputBorder.none,
                hintText: 'Enter the user email',
                hintStyle: TextStyle(
                    color: visible ? Colors.red : Colors.white,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'OpenSans'),
              ),
            ),
          ),
          Expanded(
            child: FloatingActionButton(
              onPressed: () {
                if (email.isEmpty) {
                  setState(() {
                    visible = true;
                  });
                }
                if (email.isNotEmpty) {
                  if (emaillist.length < 4) {
                    setState(() {
                      emaillist.add(email);
                      _emailcontroller.clear();
                      email = '';
                      visible = false;
                    });
                  } else {
                    setState(() {
                      visible = true;
                    });
                  }
                }
              },
              backgroundColor: Colors.black,
              child: Icon(
                Icons.done_all,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Image.asset('assets/images/people.jpg'),
              Padding(
                padding: const EdgeInsets.only(
                    top: 15, bottom: 8, left: 10, right: 10),
                child: Text(
                  "Invite People to Your Workspace",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 10, left: 30, right: 30),
                child: Text(
                  "You can invite upto 4 people using their email address. Later You can invite and Manage all Your Members in workspace Page",
                  style: TextStyle(
                      color: visible ? Colors.red : Colors.grey[600],
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
              emaillist.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: emaillist.length,
                            itemBuilder: (c, i) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: 5.0, bottom: 5, left: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.black),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          emaillist[i],
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              emaillist.removeAt(i);
                                            });
                                          },
                                          color: Colors.white,
                                          icon: Icon(Icons.clear),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    )
                  : Container(),
              _email(),
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 15),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      loading = true;
                      emaillist.add(user.email);
                    });

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Workspaceloading(
                            email: user.email,
                            workspacename: widget.workspacename,
                            team: emaillist,
                          ),
                        ));
                    //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>wrapper()), (route) => false);

                    //check email verification
                    //DatabaseService(uid:user.uid).UpdateWorkspaceDetails(widget.workspacename, [],[],emaillist, []);
                  },
                  borderRadius: BorderRadius.circular(40),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.05,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        'Next',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    emaillist.add(user.email);
                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Workspaceloading(
                          email: user.email,
                          workspacename: widget.workspacename,
                          team: emaillist,
                        ),
                      ));
                },
                child: Text(
                  "skip",
                  style: TextStyle(
                      color: Colors.grey[700],
                      decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
