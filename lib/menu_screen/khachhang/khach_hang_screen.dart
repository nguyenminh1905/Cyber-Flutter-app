import 'package:flutter/material.dart';
import 'package:flutter_cyber_app/menu_screen/khachhang/khach_hang_tab.dart';
import 'package:flutter_cyber_app/menu_screen/khachhang/thongtin_tab.dart';
import 'package:flutter_cyber_app/menu_screen/khachhang/xe_tab.dart';


class KhachHangScreen extends StatelessWidget {
  const KhachHangScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Phiếu báo giá",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          bottom: const TabBar(
            labelColor: Colors.green,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: "Thong tin"),
              Tab(text: "Khach hang"),
              Tab(text: "Xe"),
              Tab(text: "Phu kien"),
            ],
          ),
        ),
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            ThongTinTab(),
            KhachHangTab(), 
            XeTab(),
            Center(child: Text("Màn hình Phụ kiện")),
          ],
        ),
      ),
    );
  }
}
