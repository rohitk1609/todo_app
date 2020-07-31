class Slider{
  final String title;
  final List<String> list;
  Slider({this.title,this.list});



}

final sliderlist=[
  Slider(
    title: "What type of team do you work in ?",
    list: ["Finance","Operations","IT support","Marketing","Legal","Custom Service","Human Resource","Sales","Software Development","Other"]
  ),
  Slider(
    title: "Which of these best describes what you do ? This will appear in your profile?",
    list: ["Student","Scrum Master","Product Owner","Founder","CTO","Buisiness Analyst","Program Manager","Other"],
  ),
];