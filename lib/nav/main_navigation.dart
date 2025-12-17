
import 'package:flutter/material.dart';
import 'package:flutter_cyber_app/main_screen/home_screen.dart';
import 'package:flutter_cyber_app/main_screen/noti_screen.dart';
import 'package:flutter_cyber_app/main_screen/setting_screen.dart';
import 'package:flutter_cyber_app/main_screen/support_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _bottomIndex = 0;
  
  final List<Widget> _screens = [
    HomeScreen(),            
    SupportScreen(),
    NotificationScreen(),
    SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_bottomIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomIndex,
        onTap: (index) => setState(() => _bottomIndex = index),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        backgroundColor: Colors.green,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Trang chủ"),
          BottomNavigationBarItem(icon: Icon(Icons.help), label: "Hỗ trợ"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Thông báo"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Cài đặt"),
        ],
      ),
    );
  }
}
