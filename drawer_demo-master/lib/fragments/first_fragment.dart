import 'package:flutter/material.dart';



class FirstFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
       MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    // TODO: implement build
    List<Task> tasks = [
  new Task(
      name: "Catch up with Brian",
      category: "Mobile Project",
      time: "5pm",
      color: Colors.orange,
      completed: false),
  new Task(
      name: "Make new icons",
      category: "Web App",
      time: "3pm",
      color: Colors.cyan,
      completed: true),
  new Task(
      name: "Design explorations",
      category: "Company Website",
      time: "2pm",
      color: Colors.pink,
      completed: false),
  new Task(
      name: "Lunch with Mary",
      category: "Grill House",
      time: "12pm",
      color: Colors.cyan,
      completed: true),
  new Task(
      name: "Teem Meeting",
      category: "Hangouts",
      time: "10am",
      color: Colors.cyan,
      completed: true),
];
 return new Scaffold(
  body:  
  new Image.asset("assets/image/factory.jpg",
    fit: BoxFit.fill,
    height: double.infinity,
    width: queryData.size.width,
    alignment: Alignment.center,
  ),
);
  }

}

class Task {
  final String name;
  final String category;
  final String time;
  final Color color;
  final bool completed;

  Task({this.name, this.category, this.time, this.color, this.completed});
}