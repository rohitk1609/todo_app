import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ProjectLists extends StatefulWidget {
  @override
  _ProjectListsState createState() => _ProjectListsState();
}

class _ProjectListsState extends State<ProjectLists> {
  Widget _projectbox() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 10),
      child: Container(
        padding: EdgeInsets.only(left:15,right: 15,top: 10,bottom: 10),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.15,
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(5)),
        child: Row(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width*0.5,
              
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                Text('Otimer Clone Project',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize:MediaQuery.of(context).size.height*0.025),maxLines: 1,overflow: TextOverflow.ellipsis,),
                SizedBox(height:5,),
                Text('142 Tasks',style: TextStyle(color: Colors.grey[800],fontWeight: FontWeight.w400),maxLines: 1,overflow: TextOverflow.ellipsis,),
                
                Expanded(
                                child: Row(
                    children: <Widget>[
                      Text('Created By ',style: TextStyle(color: Colors.grey[800],fontWeight: FontWeight.w400),maxLines: 1,overflow: TextOverflow.ellipsis,),
                      SizedBox(width: 10,),
                      CircleAvatar(backgroundColor: Colors.black,)
                    ],
                  ),
                ),
                
              ],),
            ),
            Expanded(child: CircularPercentIndicator(
                  radius: MediaQuery.of(context).size.width*0.18,
                  lineWidth: 5.0,
                  percent: 0.7,
                  center: new Text("70%",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
                  progressColor: Colors.black,
                  backgroundColor: Colors.white,
                  circularStrokeCap: CircularStrokeCap.round,
                ),)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10),
      child: ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return _projectbox();
          }),
    );
  }
}
