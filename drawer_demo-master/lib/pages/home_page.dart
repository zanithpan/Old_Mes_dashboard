import 'package:drawer_demo/fragments/first_fragment.dart';
import 'package:drawer_demo/fragments/second_fragment.dart';
import 'package:drawer_demo/fragments/third_fragment.dart';
import 'package:drawer_demo/fragments/home_fragment.dart';
import 'package:drawer_demo/fragments/setting_fragment.dart';
import 'package:flutter/material.dart';
 
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  final drawerItems = [
    new DrawerItem("HomePage", Icons.home),
    new DrawerItem("Overall", Icons.poll),
    new DrawerItem("OEE", Icons.show_chart),
    new DrawerItem("Realtime", Icons.timelapse),
       // new DrawerItem("Settings", Icons.settings)
  ];

  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
   
     @override
  void initState()
  {
        super.initState();
        flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

     var android = new AndroidInitializationSettings('@mipmap/logo2',);
    var iOS  = new IOSInitializationSettings();
   var initSettings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSettings,onSelectNotification:onSelectNotification );
 
  }
  Future onSelectNotification(String payload)
  {
showDialog(context: context, builder:(_)=> new AlertDialog(
  title: new Text('Notification'),content: new Text("Payload"),));
  }
 
    
  int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new HomePageFragment();
      case 1:
        return new FirstFragment();
      case 2:
        return new SecondFragment();
      case 3:
        return new ThirdFragment();
      case 4:
        return new SettingFragment(false,false);
      default:
        return new Text("Error");
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }
 
   showNotification() async
 {
   var android = new AndroidNotificationDetails("channelId", "channelName", "channelDescription");
   var iOS = new IOSNotificationDetails();
   var platform = new NotificationDetails(android, iOS);
   FlutterAppBadger.updateBadgeCount(1);
await flutterLocalNotificationsPlugin.show(0, "Alert", "Push Notification", platform,payload: 'Payload');
 } 
  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions = [];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(new ListTile(
        leading: new Icon(d.icon),
        title: new Text(d.title),
        onLongPress: showNotification,
        selected: i == _selectedDrawerIndex,
        onTap: () => _onSelectItem(i),
      ));
    }

    return new Scaffold(
      appBar: new AppBar(
        // here we display the title corresponding to the fragment
        // you can instead choose to have a static title
        title: new Text(widget.drawerItems[_selectedDrawerIndex].title),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: choicAction,
            itemBuilder: (BuildContext context) {
              return Constants.choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
      ),
      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text('Manufacturing Execution System',
                  style: new TextStyle(
                    fontFamily: "Rock Salt",
                    fontSize: 14.0,
                    color: Colors.black,
                  )),
              accountEmail: new Text("MES@cpf.co.th"),
              currentAccountPicture: new Container(
                child: new Image.asset("assets/image/logo1.png"),
              ),
            ),
            new Column(children: drawerOptions)
          ],
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }

  void choicAction(String choice) {
    if (choice == "Subscribe") {
     Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SecondFragment()),
                    );
    Navigator.of(context).pop(); // close the drawer
    } else if (choice == "Settings") {
     Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingFragment(false,false)),
                    );
    }
  }
}

class Constants {
  static const String Settings = 'Settings';
  static const String Subscribe = 'Subscribe';
  static const String Logout = 'Logout';
  static const List<String> choices = <String>[
    'Settings',
    'Subscribe',
    'Logout'
  ];
}
