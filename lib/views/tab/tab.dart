import 'package:flutter/material.dart';
import 'package:smile_x/views/map/map.dart';
import 'package:smile_x/views/profile/profile.dart';

import 'package:smile_x/views/timeline/timeline.dart';
import 'package:smile_x/views/theme/theme.dart';
import 'package:smile_x/views/point/point.dart';

class TabBarController extends StatefulWidget {
  @override
  State<TabBarController> createState() => TabBarControllerState();
}

class TabBarControllerState extends State<TabBarController> {
  // Property
  int _currentIndex = 0;
  List<Widget> _children = [];

  @override
  void initState() {
    // Add children
    _children = [
      TimelineController(),
      ThemeController(),
      PointController(),
      ProfileController(),
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        showSelectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.grey),
            activeIcon: Icon(Icons.home, color: Colors.blue),
            title: Container(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group, color: Colors.grey),
            activeIcon: Icon(Icons.group, color: Colors.blue),
            title: Container(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star, color: Colors.grey),
            activeIcon: Icon(Icons.star, color: Colors.blue),
            title: Container(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle, color: Colors.grey),
            activeIcon: Icon(Icons.account_circle, color: Colors.blue),
            title: Container(),
          ),
        ],
        onTap: onTap,
        currentIndex: _currentIndex,
      ),
    );
  }

  void moveTimeline() {
    setState(() {
      _currentIndex = 0;
    });
  }

  void onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
