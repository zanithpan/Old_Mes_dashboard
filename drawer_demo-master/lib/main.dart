import 'package:drawer_demo/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
 
void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
   
    //flutterLocalNotificationsPlugin.initialize(initializationSettings);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    /*return new MaterialApp(
      title: 'NavigationDrawer Demo',
      theme: new ThemeData(
           brightness: Brightness.dark,
           primarySwatch: Colors.green,
    primaryColor: Colors.lightGreen[200],
    
    
    // Define the default Font Family
    fontFamily: 'Montserrat',
      ),
      home: new HomePage(title: 'MES CPF Dashboard'),
    );*/
     return new DynamicTheme(
      defaultBrightness: Brightness.dark,
      data: (brightness) => new ThemeData(
        primarySwatch: Colors.green,
         primaryColor: Colors.lightGreen[200],
        brightness: brightness,
      ),
      themedWidgetBuilder: (context, theme) {
        return new MaterialApp(
          title: 'Flutter Demo',
          theme: theme,
          home: new HomePage(title: 'Flutter Demo Home Page'),
        );
      }
    );
  }
}

 
