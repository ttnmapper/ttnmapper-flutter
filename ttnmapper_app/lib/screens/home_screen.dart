import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ttnmapper_app/widgets/placeholder.dart';

import '../constants.dart';
import 'map_screen.dart';
import 'settings_screen.dart';


class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomeScreen> {
  static const int _defaultSelectedIndex = 0;
  int _selectedIndex = _defaultSelectedIndex;
  Position _currentPosition;

  void _onTabTapped(int index) async {
    Position position;
    if (index == 1) {
      position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    }

    setState(() {
      if (position != null) {
        _currentPosition = position;
      }
      _selectedIndex = index;
    });
  }

  Widget _activeWidget(index) {
    switch (index) {
      case 0:
        return PlaceholderWidget(Colors.black12);
        break;
      case 1:
        return MapScreen(_currentPosition);
        break;
      case 2:
        return SettingsScreen();
        break;
      default:
        return PlaceholderWidget(Colors.black12);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(Constants.primaryColor),
          brightness: Brightness.dark,
          elevation: 0.7,
          title: Text(Constants.appTitle,
              style: new TextStyle(color: Colors.white.withOpacity(0.9)))),
      body: _activeWidget(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.info),
            title: new Text('Info'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.map),
            title: new Text('Map'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), title: Text('Settings'))
        ],
      ),
    );
  }
}
