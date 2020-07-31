class Category{
  final String name;
  Category({this.name});

  static List<Category> getTag(){
    return <Category>[
      Category(name: 'Student'),
      Category(name: 'Scrum Master'),
      Category(name: 'Product Owner'),
      Category(name: 'Founder'),
      Category(name: 'CTO'),
      Category(name: 'Buisiness Analyst'),
      Category(name: 'Program Manager'),
      Category(name: 'Other'),
    ];
  } 
}