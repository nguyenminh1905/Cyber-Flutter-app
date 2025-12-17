import 'package:flutter/material.dart';
import 'package:flutter_cyber_app/widget/cyber_icon_place.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final ValueNotifier<List<PlacedIcon>> placedIconsNotifier =
      ValueNotifier<List<PlacedIcon>>([]);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    placedIconsNotifier.value = await IconStorage.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: CyberIconDraw(
          imagePath: "assets/images/Audi_A8L.png",
          listIcons: const [
            {"icon": Icons.home, "color": Colors.green},
            {"icon": Icons.star, "color": Colors.orange},
            {"icon": Icons.settings, "color": Colors.blue},
            {"icon": Icons.person, "color": Colors.pink},
            {"icon": Icons.donut_small, "color": Colors.yellow},
            {"icon": Icons.alarm, "color": Colors.red},
          ],
          placedIconsNotifier: placedIconsNotifier,
        ),
      ),
    );
  }
}
