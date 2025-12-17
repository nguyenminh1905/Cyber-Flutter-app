import 'package:flutter/material.dart';
import 'package:flutter_cyber_app/model/car_info.dart';
import 'package:flutter_cyber_app/providers/car_provider.dart';
import 'package:flutter_cyber_app/widget/cyber_car_tile.dart';
import 'package:flutter_cyber_app/widget/cyber_custom_button.dart';
import 'package:flutter_cyber_app/widget/cyber_search_bar.dart';

import 'package:provider/provider.dart';

class CarSelectScreen extends StatefulWidget {
  const CarSelectScreen({super.key});

  @override
  State<CarSelectScreen> createState() => _CarSelectScreenState();
}

class _CarSelectScreenState extends State<CarSelectScreen> {
  bool isGrid = false;

  // Danh sách
  final List<CarInfo> cars = [
  CarInfo(
    tenxe: "Toyota Fortuner",
    color: "Mau trang",
    namsx: 2020,
    dgia: 1000,
    thuthem: 0,
    giamgia: 0,
    thanhtien: 1000,
  ),
  ...List.generate(
    30,
    (i) => CarInfo(
      tenxe: "Hilux Adventure",
      color: "Mau den",
      namsx: 2019,
      dgia: 900,
      thuthem: 0,
      giamgia: 0,
      thanhtien: 900,
    ),
  )
];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CarProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Chọn kiểu xe",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () => setState(() => isGrid = false),
          ),
          IconButton(
            icon: const Icon(Icons.grid_view),
            onPressed: () => setState(() => isGrid = true),
          ),
        ],
      ),
      body: Column(
        children: [
          CyberSearchBar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 70),
              child: isGrid
                  ? GridView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: cars.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 1.4,
                          ),
                      itemBuilder: (context, index) {
                        final car = cars[index];
                        return CarTile(
                          car: car,
                          isSelected: provider.selectedCars.contains(car),
                          onTap: () => provider.toggleCar(car),
                        );
                      },
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: cars.length,
                      itemBuilder: (context, index) {
                        final car = cars[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: CarTile(
                            car: car,
                            isSelected: provider.selectedCars.contains(car),
                            onTap: () => provider.toggleCar(car),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 36),
        color: Colors.transparent,
        child: CyberButton(
          title: "Xac nhan",
          color: Colors.green,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
