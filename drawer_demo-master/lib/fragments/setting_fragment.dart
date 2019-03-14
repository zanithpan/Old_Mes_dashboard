import 'package:flutter/material.dart';
import 'package:card_settings/card_settings.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:dynamic_theme/theme_switcher_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingFragment extends StatelessWidget {
  SettingFragment(this._ateOut, this._ateOutTheme);
  bool _ateOut;
  bool _ateOutTheme;
  @override
  Widget build(BuildContext context) {
    return new MySetting(_ateOut, _ateOutTheme); //Text(snapshot.data[1].title);

    /*return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MySecondFragment(title: 'Flutter Demo Home Page'),
    );*/
  }
}

class MySetting extends StatefulWidget {
  MySetting(this._ateOut, this._ateOutTheme);
  bool _ateOut;
  bool _ateOutTheme;

  @override
  _MySettingState createState() => _MySettingState(_ateOut,_ateOutTheme);
}

class _MySettingState extends State<MySetting> {
   _MySettingState(this._ateOut, this._ateOutTheme);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String title = "Spheria";
  String author = "Cody Leet";
  String url = "http://www.codyleet.com/spheria";
  bool _ateOut;
  bool _ateOutTheme;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        // here we display the title corresponding to the fragment
        // you can instead choose to have a static title
        title: new Text("Settings"),
      ),
      body: Form(
        key: _formKey,
        child: CardSettings(
          children: <Widget>[
            CardSettingsHeader(label: 'App Settings'),
            CardSettingsSwitch(
              label: 'Theme Brightness:',
              trueLabel: "Light",
              falseLabel: "Dark",
              onSaved:   (value) {
                _ateOutTheme = value;},
              initialValue: _ateOutTheme,
              onChanged: (value) {
                _ateOutTheme = value;
                changeBrightness();
                // changeState(value,context);
                // _ateOut =true;
                //  value= true;
              },
            ),
            CardSettingsSwitch(
              label: 'Theme Colors:',
              trueLabel: "Light",
              falseLabel: "Dark",
              initialValue: _ateOut,
              onChanged: (value) { _ateOut = value;
              changeColor();
              },
            ),
          ],
        ),
      ),
    );
  }

  void showChooser() {
    showDialog<void>(
        context: context,
        builder: (context) {
          return BrightnessSwitcherDialog(
            onSelectedTheme: (brightness) {
              DynamicTheme.of(context).setBrightness(brightness);
            },
          );
        });
  }

  void changeBrightness() {
    DynamicTheme.of(context).setBrightness(
        Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark);
  }

  void changeColor() {
    DynamicTheme.of(context).setThemeData(ThemeData(
        primaryColor: Theme.of(context).primaryColor == Colors.lightGreen[200]
            ? Colors.blue[300]
            : Colors.lightGreen[200]));

            DynamicTheme.of(context).setThemeData(ThemeData(
        primarySwatch: Theme.of(context).primaryColor == Colors.green
            ? Colors.blue[300]
            : Colors.green));
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
