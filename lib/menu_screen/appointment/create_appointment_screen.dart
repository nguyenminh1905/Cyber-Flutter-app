import 'package:flutter/material.dart';
import 'package:flutter_cyber_app/widget/cyber_custom_input.dart';

class CreateAppointmentScreen extends StatefulWidget {
  const CreateAppointmentScreen({super.key});

  @override
  State<CreateAppointmentScreen> createState() =>
      _CreateAppointmentScreenState();
}

class _CreateAppointmentScreenState extends State<CreateAppointmentScreen> {
  final phoneCtrl = TextEditingController();
  final plateCtrl = TextEditingController();
  final customerCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String repairType = "SBD";
  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();

  final List<String> staffList = [
    "Nguyen Van Tan",
    "Pham Thi Bich Ngoc",
    "Pham Thi Hai",
    "Pham Thi Lan Nhi",
    "Pham To Uyen",
    "Ta Thi Man",
    "Tran Van Nam",
    "Tran Thi Hoa",
    "Tran Thi Mai",
    "Le Van Hung",
    "Le Thi Thu",
  ];

  String? selectedStaff;

  void save() {
    Navigator.pop(context, {
      "phone": phoneCtrl.text,
      "plate": plateCtrl.text,
      "customer": customerCtrl.text,
      "type": repairType,
      "dateTime": DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      ),
      "description": descCtrl.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tạo Lịch Hẹn"), centerTitle: true),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus(); // 👈 TẮT BÀN PHÍM
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomInput(title: "SDT", controller: phoneCtrl),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomInput(title: "BKS", controller: plateCtrl),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              CustomInput(title: "Nguoi dat hen", controller: customerCtrl),
              const SizedBox(height: 12),
              const Text(
                "Loai sua chua:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: ["SSC", "SBD", "SDS", "SSQ"].map((e) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<String>(
                        value: e,
                        groupValue: repairType,
                        onChanged: (val) {
                          setState(() => repairType = val!);
                        },
                      ),
                      Text(e, style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildDatePicker()),
                  const SizedBox(width: 12),
                  Expanded(child: _buildTimePicker()),
                ],
              ),
              const SizedBox(height: 12),
              CustomInput(
                title: "Dien giai",
                controller: descCtrl,
                maxLines: 4,
              ),
              const SizedBox(height: 12),

              GestureDetector(
                onTap: _selectStaff,
                child: AbsorbPointer(
                  child: CustomInput(
                    title: "CVDV",
                    hint: selectedStaff ?? "Chọn CVDV",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
          helpText: "Chọn ngày tháng năm",
          cancelText: "Huỷ bỏ",
          confirmText: "Xác nhận",
        );

        if (picked != null) {
          setState(() => selectedDate = picked);
        }
      },
      child: AbsorbPointer(
        child: CustomInput(
          title: "Ngày đến",
          hint: selectedDate == null
              ? "Chọn ngày"
              : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
        ),
      ),
    );
  }

  Widget _buildTimePicker() {
    return GestureDetector(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: selectedTime ?? TimeOfDay.now(),
          helpText: "Chon gio",
          cancelText: "Huy bo",
          confirmText: "Xac nhan",
        );
        if (picked != null) {
          setState(() => selectedTime = picked);
        }
      },
      child: AbsorbPointer(
        child: CustomInput(
          title: "Giờ đến",
          hint: selectedTime == null
              ? "Chọn giờ"
              : "${selectedTime!.hour}:${selectedTime!.minute}",
        ),
      ),
    );
  }

  void _selectStaff() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.65, // 👈 CỐ ĐỊNH
          child: Column(
            children: [
              const SizedBox(height: 12),
              const Text(
                "Chọn CVDV",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              /// LIST SCROLL
              Expanded(
                child: ListView.builder(
                  itemCount: staffList.length,
                  itemBuilder: (_, i) {
                    final name = staffList[i];
                    final selected = name == selectedStaff;

                    return ListTile(
                      title: Center(
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: selected
                                ? Colors.orange
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: selected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        setState(() => selectedStaff = name);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Xác nhận"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
