import 'package:flutter/material.dart';
import 'package:flutter_cyber_app/model/car_info.dart';


class CarTile extends StatelessWidget {
  final CarInfo car;
  final bool isSelected;
  final VoidCallback onTap;

  const CarTile({
    super.key,
    required this.car,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.withValues(alpha: 0.15) : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey.shade300,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    car.tenxe,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(width: 8),
                Text(car.color, overflow: TextOverflow.ellipsis, maxLines: 1),
              ],
            ),

            const SizedBox(height: 4),
            Text("${car.namsx}"),
            const SizedBox(height: 4),
            Text(
              "Giá: ${car.thanhtien} đ",
              style: const TextStyle(color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
