import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo/Shared/colors.dart';
import 'package:todo/screens/Profile/invitepeople.dart';

class AddWorkspace extends StatefulWidget {
  @override
  _AddWorkspaceState createState() => _AddWorkspaceState();
}

class _AddWorkspaceState extends State<AddWorkspace> {
  TextEditingController _workspacecontroller = TextEditingController();

  String workspacename = '';
  bool loading = false;
  bool visible = false;
  String errormessage = '';

  Widget _workspacename() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
      child: Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 10),
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: whitebg,
        ),
        child: TextFormField(
          controller: _workspacecontroller,
          keyboardType: TextInputType.text,
          maxLines: 1,
          inputFormatters: [LengthLimitingTextInputFormatter(500)],
          onChanged: (val) {
            setState(() {
              workspacename = val;
              visible = false;
            });
          },
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.normal, fontSize: 15),
          decoration: InputDecoration(
            fillColor: Colors.white,
            focusColor: Colors.yellow,
            border: InputBorder.none,
            hintText: 'Workspace Name',
            hintStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w300,
                fontSize: 15,
                fontFamily: 'OpenSans'),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whitebg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    top: 15, bottom: 8, left: 10, right: 10),
                child: Text(
                  "Create a Workspace",
                  style: TextStyle(
                      color: white,
                      fontWeight: FontWeight.w500,
                      fontSize: MediaQuery.of(context).size.height * 0.03),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 15, bottom: 15, left: 30, right: 30),
                child: Text(
                  "Give your workspace a name. Don't worry, you can change it later",
                  style: TextStyle(
                      color: Colors.grey[300], fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
              _workspacename(),
              visible
                  ? Padding(
                      padding:
                          const EdgeInsets.only(left: 25.0, top: 5, bottom: 5),
                      child: Row(
                        children: <Widget>[
                          Text(
                            errormessage,
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: InkWell(
                  onTap: () async {
                    if (workspacename.isEmpty) {
                      setState(() {
                        errormessage = 'Enter Workspace name';
                        visible = true;
                      });
                    }
                    if (workspacename.isNotEmpty) {
                      setState(() {
                        loading = true;
                      });
                      await new Future.delayed(const Duration(seconds: 2));
                      setState(() {
                        loading = false;
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Invite(
                                    workspacename: workspacename,
                                  )));
                    }
                  },
                  borderRadius: BorderRadius.circular(40),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.05,
                    decoration: BoxDecoration(
                        color: secondarycolor,
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: loading
                          ? CircularProgressIndicator()
                          : Text(
                              'Next',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
