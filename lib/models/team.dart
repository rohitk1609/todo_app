class Team{
  final String name;
  bool isselected;
  Team({this.name,this.isselected});

  static List<Team> getTag(){
    return <Team>[
      Team(name: 'Finance',isselected: false),
      Team(name: 'IT support',isselected: false),
      Team(name: 'Operations',isselected: false),
      Team(name: 'Marketing',isselected: false),
      Team(name: 'legal',isselected: false),
      Team(name: 'Custom Service',isselected: false),
      Team(name: 'Human Resources',isselected: false),
      Team(name: 'Sales',isselected: false),
      Team(name: 'Software Development',isselected: false),
      Team(name: 'Other',isselected: false),
    ];
  } 
}