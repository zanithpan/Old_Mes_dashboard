import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;




//import 'dart:html';
//import 'dart:json';

Future<List<Post>> fetchPost() async {
  final response =
      await http.get('https://jsonplaceholder.typicode.com/posts');
List<Post> listRet = new List<Post>();

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    for(int i=0;i<= json.decode(response.body).length-1;i++)
    {
listRet.add(Post.fromJson(json.decode(response.body)[i]));

    }
    return  listRet;
  } 
  else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}


class PostList{
List<Post> listP = new List<Post>();
}

class Post {
final int userId;
  final int id;
  final String title;
  final String body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
/*
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({this.userId, this.id, this.title, this.body});
    factory Post.fromJson(Map<String, List<dynamic>> json) {

       for(int i=0;i<json.length;i++)
      {
 
  userId: json['userId'][i];
      }

*/

  }
 

 


 
class ThirdFragment extends StatelessWidget {
@override
  Widget build(BuildContext context) {
    return Container(
child:FutureBuilder<List<Post>>(
            future: fetchPost(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data[1].title);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner
              return CircularProgressIndicator();
            },
          ),
    );
    

    
  }


}