import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_cyber_app/menu_screen/appointment/book_appointment_screen.dart';
import 'package:flutter_cyber_app/menu_screen/catalog/car_catalog_screen.dart';
import 'package:flutter_cyber_app/menu_screen/drawicon/draw_icon_screen.dart';
import 'package:flutter_cyber_app/menu_screen/face_regconition/cham_cong/face_camera_screen.dart';
import 'package:flutter_cyber_app/menu_screen/face_regconition/dangki_khuonmat/register_face_screen.dart';
import 'package:flutter_cyber_app/menu_screen/khachhang/khach_hang_screen.dart';
import 'package:flutter_cyber_app/menu_screen/biometric/biometric_screen.dart';
import 'package:flutter_cyber_app/menu_screen/test_screen.dart';
import 'package:flutter_cyber_app/widget/cyber_build_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeScreen> {
  final List<String> headerImages = [
    "assets/images/header1.jpg",
    "assets/images/header2.jpg",
  ];
  final List<Map<String, dynamic>> items = [
    {
      "color": Colors.green,
      "icon": Icons.book,
      "name": "Khach hang",
      "screen": KhachHangScreen(),
    },
    {
      "color": Colors.orange,
      "icon": Icons.car_rental,
      "name": "Catalog xe",
      "screen": CarCatalogScreen(),
    },
    {
      "color": Colors.blue,
      "icon": Icons.book,
      "name": "Dat lich hen",
      "screen": BookAppointmentScreen(),
    },
    {
      "color": Colors.pink,
      "icon": Icons.people,
      "name": "Ve icon",
      "screen": DrawIconScreen(),
    },
    {
      "color": Colors.deepOrange,
      "icon": Icons.fingerprint,
      "name": "Biometric",
      "screen": BiometricTest(),
    },
    {
      "color": Colors.yellow,
      "icon": Icons.face,
      "name": "Dang ki khuon mat",
      "screen": RegisterFaceScreen(),
    },
    {
      "color": Colors.brown,
      "icon": Icons.verified_user,
      "name": "Cham cong",
      "screen": KYCCameraScreen(),
    },
    {
      "color": Colors.red,
      "icon": Icons.donut_large,
      "name": "Test",
      "screen": TestScreen(),
    },
    {
      "color": Colors.red,
      "icon": Icons.donut_large,
      "name": "Test",
      "screen": TestScreen(),
    },
    {
      "color": Colors.red,
      "icon": Icons.donut_large,
      "name": "Test",
      "screen": TestScreen(),
    },
    {
      "color": Colors.red,
      "icon": Icons.donut_large,
      "name": "Test",
      "screen": TestScreen(),
    },
    {
      "color": Colors.red,
      "icon": Icons.donut_large,
      "name": "Test",
      "screen": TestScreen(),
    },
    {
      "color": Colors.red,
      "icon": Icons.donut_large,
      "name": "Test",
      "screen": TestScreen(),
    },
  ];
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        _currentPage = (_currentPage + 1) % headerImages.length;
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          SizedBox(
            height: 250,
            child: Stack(
              children: [
                PageView(
                  controller: _pageController,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  children: headerImages.map((img) {
                    return Image.asset(img, fit: BoxFit.cover);
                  }).toList(),
                ),

                Positioned(
                  top: 40,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Welcome",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Nguyễn Văn A",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Container(
            color: Colors.white,
            child: const TabBar(
              labelColor: Colors.black,
              indicatorColor: Colors.green,
              labelStyle: TextStyle(fontSize: 14),

              tabs: [
                Tab(text: "BÁN HÀNG"),
                Tab(text: "BÁN HÀNG"),
                Tab(text: "BÁN HÀNG"),
                Tab(text: "DỊCH VỤ"),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              children: [
                CyberBuildService(items: items),
                CyberBuildService(items: items),
                CyberBuildService(items: items),
                CyberBuildService(items: items),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
