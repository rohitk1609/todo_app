import 'dart:io';

import 'package:flutter/material.dart';
import 'package:todo/Shared/colors.dart';

class Imagepreview extends StatefulWidget {
  List<File> files;
  Function(List<File>) callback;
  Imagepreview({this.files, this.callback});
  @override
  _ImagepreviewState createState() => _ImagepreviewState();
}

class _ImagepreviewState extends State<Imagepreview> {
  imagepreviewbox(File file, int i) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.1,
        decoration: BoxDecoration(
            color: secondarycolor, borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.height * 0.1,
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: file.path.split('.').last == 'png' ||
                        file.path.split('.').last == 'jpg'
                    ? Image.file(
                        file,
                        fit: BoxFit.cover,
                      )
                    : Center(
                        child: Text(
                          '${file.path.split('.').last.toUpperCase()}',
                          style: TextStyle(
                              color: black, fontWeight: FontWeight.bold),
                        ),
                      ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10),
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    file.path.split('/').last,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'File Type : ${file.path.split('.').last.toUpperCase()}',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'File Size : ${file.lengthSync()}',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(
                  Icons.clear,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    widget.files.removeAt(i);
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<bool> _onwillpop() async {
    widget.callback(widget.files);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onwillpop,
      child: Scaffold(
        backgroundColor: secondarybackgroundcolor,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.06,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: white,
                          ),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.settings,
                            color: white,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Image Attachments",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.03,
                          color: white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Image Attachtments, supported files are jpg,png,etc,A package that allows you to use a native file explorer to pick single or multiple absolute file paths, with extensions filtering support.",
                      style:
                          TextStyle(color: white, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.files.length,
                    itemBuilder: (c, i) {
                      return imagepreviewbox(widget.files[i], i);
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
