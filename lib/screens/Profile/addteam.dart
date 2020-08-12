import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/database/database.dart';
import 'package:todo/models/user.dart';
import 'package:todo/models/userdata.dart';
import 'package:todo/models/workspace.dart';

class Addteam extends StatefulWidget {
  Workspace workspace;
  List<String> projectteam;
  List<UserData> workspaceteamdata;
  Addteam({this.workspace, this.projectteam, this.workspaceteamdata});
  @override
  _AddteamState createState() => _AddteamState();
}

class _AddteamState extends State<Addteam> {
  Widget _search() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.grey[200], spreadRadius: 2, blurRadius: 4)
            ]),
        child: TextFormField(
          keyboardType: TextInputType.text,
          maxLines: 1,
          onChanged: (val) {
            setState(() {});
          },
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
            fontSize: MediaQuery.of(context).size.height * 0.015,
          ),
          decoration: InputDecoration(
            fillColor: Colors.black,
            border: InputBorder.none,
            hintText: 'Search By username',
            hintStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: MediaQuery.of(context).size.height * 0.015,
                fontFamily: 'OpenSans'),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  List<bool> selected = [];
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/people.jpg'))),
                ),
                _search(),
                widget.workspaceteamdata.isEmpty
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        //height: MediaQuery.of(context).size.height * 0.6,
                        child: Center(child: CircularProgressIndicator()))
                    : Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20, bottom: 10),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          //height: MediaQuery.of(context).size.height * 0.6,
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: widget.workspaceteamdata.length,
                              itemBuilder: (c, i) {
                                if (widget.workspaceteamdata[i].email !=
                                    widget.workspace.owner) {
                                  return InkWell(
                                    onTap: () {
                                      if (widget.projectteam.contains(
                                          widget.workspaceteamdata[i].email)) {
                                        setState(() {
                                          widget.projectteam.remove(widget
                                              .workspaceteamdata[i].email);
                                        });
                                      } else {
                                        setState(() {
                                          widget.projectteam.add(widget
                                              .workspaceteamdata[i].email);
                                        });
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.11,
                                        decoration: BoxDecoration(
                                            color: widget.projectteam.contains(
                                                    widget.workspaceteamdata[i]
                                                        .email)
                                                ? Colors.deepOrange[300]
                                                : Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0, right: 10),
                                              child: CircleAvatar(
                                                radius: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.04,
                                                backgroundImage: NetworkImage(
                                                    widget.workspaceteamdata[i]
                                                        .profilepic),
                                              ),
                                            ),
                                            VerticalDivider(
                                              indent: 10,
                                              endIndent: 10,
                                              color: Colors.black,
                                              width: 4,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0, right: 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    widget.workspaceteamdata[i]
                                                        .username,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.008),
                                                  Text(
                                                    widget.workspaceteamdata[i]
                                                        .category,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              }),
                        ),
                      ),
                Expanded(
                  child: Center(
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        print("in team");
                        print(widget.projectteam);
                        Navigator.pop(context, widget.projectteam);
                      },
                      backgroundColor: Colors.black,
                      label: Text(
                        "add members",
                        style: TextStyle(color: Colors.white),
                      ),
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
