import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});
  // HÀM GỌI ĐIỆN
  Future<void> callPhone(String phone) async {
    final Uri uri = Uri(scheme: 'tel', path: phone.replaceAll(' ', ''));
    await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/images/logo.jpg", height: 80),
              const SizedBox(height: 10),
              const Text(
                "CÔNG TY CỔ PHẦN PHẦN MỀM QUẢN TRỊ\nDOANH NGHIỆP (CYBERSOFT)",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                "Platform: Android 16    Version: 10.3 (Build 10)",
                style: TextStyle(color: Colors.green),
              ),
              const SizedBox(height: 20),
              const Divider(endIndent: 50, indent: 50),
              const SizedBox(height: 20),
              titleSection("VĂN PHÒNG HÀ NỘI"),
              officeInfo(
                address:
                    "Tầng 5, Tòa Nhà Viện Công Nghệ,\nSố 25 Vũ Ngọc Phan, Láng Hạ, Đống Đa, Hà Nội",
                phoneMain: "0243.7765.046 / 047 / 048",
                phoneFax: "0243.7765.047",
                email: "Sales@cybersoft.com.vn",
              ),
              const Divider(endIndent: 50, indent: 50),
              const SizedBox(height: 20),
              titleSection("VĂN PHÒNG TP. HỒ CHÍ MINH"),
              officeInfo(
                address:
                    "Tầng 2, tòa nhà Galaxy 9 Residence,\nSố 9 Nguyễn Khoái, P1, Q4, TP HCM",
                phoneMain: "(028) 3636 5236",
                phoneFax: "0243.7765.047",
                email: "Sales@cybersoft.com.vn",
              ),
              const SizedBox(height: 50),
              SizedBox(
                width: 350,
                height: 45,
                child: ElevatedButton(
                  onPressed: () => callPhone("1900 54 54 34"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "1900 54 54 34",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget titleSection(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
    );
  }

  Widget officeInfo({
    required String address,
    required String phoneMain,
    required String phoneFax,
    required String email,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          officeRow(Icons.location_city, address),
          officeRow(Icons.phone, phoneMain),
          officeRow(Icons.print, phoneFax),
          officeRow(Icons.email, email),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget officeRow(IconData icon, String text) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.green),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 14),
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
