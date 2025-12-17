import 'package:flutter/material.dart';
import 'package:flutter_cyber_app/model/car_info.dart';


class CarProvider extends ChangeNotifier {
  List<CarInfo> selectedCars = [];

  void toggleCar(CarInfo car) {
    if (selectedCars.contains(car)) {
      selectedCars.remove(car);
    } else {
      selectedCars.add(car);
    }
    notifyListeners();
  }

  void removeCar(CarInfo car) {
    selectedCars.remove(car);
    notifyListeners();
  }

  void clear() {
    selectedCars.clear();
    notifyListeners();
  }
}
