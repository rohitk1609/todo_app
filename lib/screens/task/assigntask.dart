import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/database/database.dart';
import 'package:todo/models/user.dart';
import 'package:todo/models/userdata.dart';
import 'package:todo/models/workspace.dart';

class Assignteam extends StatefulWidget {
  List<String> taskteam;
  List<UserData> projectteamdata;
  Assignteam({
    this.taskteam,
    this.projectteamdata,
  });
  @override
  _AssignteamState createState() => _AssignteamState();
}

class _AssignteamState extends State<Assignteam> {
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
                widget.projectteamdata.isEmpty
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
                              itemCount: widget.projectteamdata.length,
                              itemBuilder: (c, i) {
                                return InkWell(
                                  onTap: () {
                                    if (widget.taskteam.contains(
                                        widget.projectteamdata[i].email)) {
                                      setState(() {
                                        widget.taskteam.remove(
                                            widget.projectteamdata[i].email);
                                      });
                                    } else {
                                      setState(() {
                                        widget.taskteam.add(
                                            widget.projectteamdata[i].email);
                                      });
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.11,
                                      decoration: BoxDecoration(
                                          color: widget.taskteam.contains(widget
                                                  .projectteamdata[i].email)
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
                                                  widget.projectteamdata[i]
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
                                                  widget.projectteamdata[i]
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
                                                  widget.projectteamdata[i]
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
                              }),
                        ),
                      ),
                Expanded(
                  child: Center(
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        print("in team");
                        print(widget.taskteam);
                        Navigator.pop(context, widget.taskteam);
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
