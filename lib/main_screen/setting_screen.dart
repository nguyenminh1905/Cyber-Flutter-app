import 'package:flutter/material.dart';
import 'package:flutter_cyber_app/widget/cyber_custom_button.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  void supportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, color: Colors.white, size: 24),
              ),
              SizedBox(height: 10),
              Text(
                "Thông báo",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text("Phiên bản hiện tại: 10.1", textAlign: TextAlign.center),
              SizedBox(height: 10),
              CyberButton(
                title: "OK",
                color: Colors.green,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            // =================== HEADER ===================
            const Text(
              "Chào mừng",
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 5),

            const Text(
              "Nguyễn Văn An",
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),

            const SizedBox(height: 15),

            // =========== THẺ THÔNG TIN NGẮN ===============
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Tài khoản:", style: TextStyle(color: Colors.white)),
                    Text(
                      "ABC",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text("Chức vụ: ", style: TextStyle(color: Colors.white)),
                    Text(
                      "Tong giam doc",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text("Điện thoại: ", style: TextStyle(color: Colors.white)),
                    Text(
                      "012323213231 ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text("Email: ", style: TextStyle(color: Colors.white)),
                    Text(
                      "nguyenquangminh@cybersoft.com.vn",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            //  EXPANDED LIST
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      settingItem(Icons.qr_code, "Quét QR Code", () {
                      }),
                      settingItem(Icons.fingerprint, "Check In", () {
                      }),
                      settingItem(Icons.lock, "Đổi mật khẩu", () {
                      }),
                      settingItem(Icons.language, "Đổi ngôn ngữ", () {
                      }),
                      settingItem(Icons.settings, "Thiết lập tài khoản", () {
                      }),
                      settingItemSwitch(Icons.face, "Xac thuc face id"),
                      settingItem(Icons.support_agent, "Hỗ trợ", () {
                      }),
                      settingItem(Icons.info, "Phiên bản: 10.1", () {
                        supportDialog(context);
                      }),
                    ],
                  ),
                ),
              ),
            ),

            // ============== NÚT ĐĂNG XUẤT ===================
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Đăng xuất",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget settingItem(IconData icon, String text, VoidCallback fun) {
    return InkWell(
      onTap: fun,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          children: [
            Icon(icon, color: Colors.green, size: 20),
            SizedBox(width: 10),
            Expanded(child: Text(text, style: TextStyle(fontSize: 14))),
            Icon(Icons.chevron_right, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  bool faceIdEnabled = true;
  Widget settingItemSwitch(IconData icon, String text) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          children: [
            Icon(icon, color: Colors.green, size: 20),
            SizedBox(width: 10),
            Expanded(child: Text(text, style: TextStyle(fontSize: 14))),
            Transform.scale(
              scale: 0.7,
              child: Switch(
                value: faceIdEnabled,
                onChanged: (bool v) {
                  setState(() {
                    faceIdEnabled = v;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
