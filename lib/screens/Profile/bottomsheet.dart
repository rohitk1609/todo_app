import 'package:flutter/material.dart';
import 'package:todo/Shared/colors.dart';
import 'package:todo/models/workspace.dart';
import 'package:todo/screens/Profile/addworkspace.dart';

class Bottomsheet extends StatefulWidget {
  List<Workspace> workspaces;
  Bottomsheet({this.workspaces});
  @override
  _BottomsheetState createState() => _BottomsheetState();
}

class _BottomsheetState extends State<Bottomsheet>
    with SingleTickerProviderStateMixin {
  int selectedradiotile;
  setselectedradiotile(val) {
    print(val);
    selectedradiotile = val;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: whitebg,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        child: Wrap(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: Container(
                  height: 10,
                  width: MediaQuery.of(context).size.width * 0.1,
                  decoration: BoxDecoration(
                      color: whitebg, borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: widget.workspaces.length,
                itemBuilder: (c, i) {
                  return Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: RadioListTile(
                        activeColor: white,
                        groupValue: selectedradiotile,
                        onChanged: (val) {
                          setselectedradiotile(val);
                        },
                        value: i,
                        title: Text(
                          '${widget.workspaces[i].workspacename}',
                          style: TextStyle(color: white),
                        ),
                      ));
                }),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: FlatButton(
                    color: Colors.black,
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddWorkspace(),
                          ));
                    },
                    child: Text(
                      "Add Workspace",
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
            ),
          ],
        ));
  }
}
