import 'package:flutter/material.dart';
import 'package:flutter_cyber_app/widget/cyber_custom_button.dart';
import 'package:flutter_cyber_app/widget/cyber_custom_input.dart';


class ThongTinTab extends StatefulWidget {
  const ThongTinTab({super.key});

  @override
  State<ThongTinTab> createState() => _ThongTinTabState();
}

class _ThongTinTabState extends State<ThongTinTab> {
  String _hinhThuc = "";

  Widget buildRadio(String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio(
          value: value,
          groupValue: _hinhThuc,
          onChanged: (val) {
            setState(() => _hinhThuc = val!);
          },
          activeColor: Colors.green,
        ),
        Text(value),
      ],
    );
  }

  Widget sectionTitle(String title) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget amountRow(String label, String amount, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isBold ? 7 : 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    "Nguyễn Văn An",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  const Text(
                    "14:19 04-12-2025",
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: CustomInput(
                      title: "Trạng thái",
                      hint: "Báo giá đã duyệt",
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomInput(
                      title: "Địa điểm KD",
                      hint: "Bán xe mới",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: CustomInput(title: "Ngày BG", hint: "04/12/2025"),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: CustomInput(title: "Số BG")),
                ],
              ),

              const SizedBox(height: 20),
              sectionTitle("HÌNH THỨC"),
              Wrap(
                spacing: 10,
                runSpacing: 5,
                children: [
                  buildRadio("Cá nhân"),
                  buildRadio("Thuê mua"),
                  buildRadio("Trả góp"),
                  buildRadio("Fleet"),
                  buildRadio("Trả thẳng"),
                  buildRadio("Trả chậm"),
                ],
              ),
              const SizedBox(height: 10),
              sectionTitle("THANH TOÁN"),

              amountRow("Tiền hàng", "0"),
              amountRow("Giảm giá", "22 000 000"),
              amountRow("Thu thêm", "0"),
              amountRow("Tổng TT", "515 000 000", isBold: true),
              const SizedBox(height: 20),
              sectionTitle("KHUYẾN MẠI"),
              amountRow("Phụ kiện", "0"),
              amountRow("Bảo hiểm", "0"),
              amountRow("Khác", "0"),
              amountRow("Tổng cộng", "0", isBold: true),
              const SizedBox(height: 20),
              sectionTitle("MUA THÊM"),
              amountRow("Phụ kiện", "0"),
              const SizedBox(height: 20),
              sectionTitle("MÔI GIỚI"),
              amountRow("Giá trị", "0", isBold: true),
              const SizedBox(height: 40),

              CyberButton(
                color: Colors.green,
                title: "Luu du lieu",
                onPressed: () {},
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
