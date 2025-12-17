import 'package:flutter/material.dart';
import 'package:flutter_cyber_app/widget/cyber_custom_button.dart';
import 'package:flutter_cyber_app/widget/cyber_custom_input.dart';


class KhachHangTab extends StatelessWidget {
  const KhachHangTab({super.key});

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.green,
        fontSize: 14,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel("KHÁCH HÀNG"),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: CustomInput(title: "Điện thoại")),
              const SizedBox(width: 12),
              Expanded(child: CustomInput(title: "Chức vụ")),
            ],
          ),
          const SizedBox(height: 12),

          CustomInput(title: "Họ và tên"),
          const SizedBox(height: 12),

          CustomInput(title: "Email"),
          const SizedBox(height: 12),

          CustomInput(title: "Địa chỉ"),
          const SizedBox(height: 25),
          _buildLabel("LIÊN HỆ"),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(child: CustomInput(title: "Họ và tên")),
              const SizedBox(width: 12),
              Expanded(child: CustomInput(title: "Điện thoại")),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(child: CustomInput(title: "Tỉnh/TP")),
              const SizedBox(width: 12),
              Expanded(child: CustomInput(title: "Phường/Xã")),
            ],
          ),
          const SizedBox(height: 12),

          CustomInput(title: "Địa chỉ GX"),
          const SizedBox(height: 25),
          CyberButton(
            title: "save data",
            color: Colors.green,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
