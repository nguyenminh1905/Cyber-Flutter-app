import 'package:flutter/material.dart';
import 'package:flutter_cyber_app/providers/car_provider.dart';
import 'package:flutter_cyber_app/menu_screen/khachhang/chon_xe_screen.dart';
import 'package:flutter_cyber_app/widget/cyber_custom_slidable.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';



class XeTab extends StatelessWidget {
  const XeTab({super.key});

  void _confirmDelete(BuildContext context, CarProvider provider, car) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Xac nhan xoa"),
        content: Text("Ban co muon xoa ${car.tenxe} khong?"),
        actions: [
          TextButton(
            onPressed: () {
              provider.removeCar(car);
              Navigator.pop(context);
            },
            child: const Text("Yes", style: TextStyle(color: Colors.green)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showCarDetail(BuildContext context, car) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Text(
                car.tenxe,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _detailRow("Màu sắc:", car.color),
              _detailRow("Năm sản xuất:", "${car.namsx}"),
              _detailRow("Đơn giá:", "${car.dgia}"),
              _detailRow("Thu thêm:", "${car.thuthem}"),
              _detailRow("Giảm giá:", "${car.giamgia}"),
              _detailRow("Thành tiền:", "${car.thanhtien}"),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showOption(BuildContext context, car) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Center(
                child: Text(
                  "Tuy chon",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 6),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final carProvider = Provider.of<CarProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CarSelectScreen()),
            );
          },
        ),
      ),
      body: carProvider.selectedCars.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sentiment_dissatisfied, size: 40),
                  SizedBox(height: 10),
                  Text("No items to display"),
                ],
              ),
            )
          : SlidableAutoCloseBehavior(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: carProvider.selectedCars.length,
                itemBuilder: (context, index) {
                  final car = carProvider.selectedCars[index];
                  return Slidable(
                    key: UniqueKey(),
                    endActionPane: ActionPane(
                      extentRatio: 0.65,
                      motion: const DrawerMotion(),
                      children: [
                        CyberSlidableAction(
                          icon: Icons.more,
                          label: "More",
                          color: Colors.grey,
                          onPressed: (_) => _showOption(context, car),
                        ),
                        CyberSlidableAction(
                          icon: Icons.info,
                          label: "Detail",
                          color: Colors.blue,
                          onPressed: (_) => _showCarDetail(context, car),
                        ),
                        CyberSlidableAction(
                          icon: Icons.delete,
                          label: "Delete",
                          color: Colors.red,
                          onPressed: (_) =>
                              _confirmDelete(context, carProvider, car),
                        ),
                      ],
                    ),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(car.tenxe),
                        subtitle: Text("${car.namsx}"),
                        trailing: Text(
                          "${car.thanhtien}",
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
