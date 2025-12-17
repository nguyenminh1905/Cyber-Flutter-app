import 'package:flutter/material.dart';
import 'package:flutter_cyber_app/widget/cyber_search_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class CarCatalogScreen extends StatefulWidget {
  const CarCatalogScreen({super.key});

  @override
  State<CarCatalogScreen> createState() => _CarCatalogScreenState();
}

class _CarCatalogScreenState extends State<CarCatalogScreen> {
  bool isGrid = true;

  final List<CarCatalogModel> cars = [
    CarCatalogModel(
      name: "TOYOTA AVANZA PREMIO",
      price: 0,
      image: "assets/images/toyota.jpg",
      link: "https://google.com",
    ),
    CarCatalogModel(
      name: "ALPHARD",
      price: 0,
      image: "assets/images/toyota.jpg",
      link: "https://google.com",
    ),
    CarCatalogModel(
      name: "Toyota Corolla Altis 1.8HV",
      price: 0,
      image: "assets/images/toyota.jpg",
      link: "https://google.com",
    ),
    CarCatalogModel(
      name: "Toyota Corolla Altis 1.8HV",
      price: 0,
      image: "assets/images/toyota.jpg",
      link: "https://google.com",
    ),
    CarCatalogModel(
      name: "Toyota Corolla Altis 1.8HV",
      price: 0,
      image: "assets/images/toyota.jpg",
      link: "https://google.com",
    ),
    CarCatalogModel(
      name: "Toyota Corolla Altis 1.8HV",
      price: 0,
      image: "assets/images/toyota.jpg",
      link: "https://google.com",
    ),
  ];

  //launch url
  Future<void> openLink(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri);
  }

  Widget buildGridItem(CarCatalogModel car) {
    return InkWell(
      onTap: () => openLink(car.link),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            car.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),

          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.asset(
              car.image,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(car.price.toString()),
              const Text(
                "Chi tiết",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===== ITEM LIST =====
  Widget buildListItem(CarCatalogModel car) {
    return InkWell(
      onTap: () => openLink(car.link),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(car.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                car.image,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(car.price.toString()),
                Text(
                  "Chi tiết",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "CATALOG",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.list, color: !isGrid ? Colors.green : Colors.grey),
            onPressed: () => setState(() => isGrid = false),
          ),
          IconButton(
            icon: Icon(
              Icons.grid_view,
              color: isGrid ? Colors.green : Colors.grey,
            ),
            onPressed: () => setState(() => isGrid = true),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.all(8), child: CyberSearchBar()),
          Expanded(
            child: isGrid
                ? GridView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: cars.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1.1,
                        ),
                    itemBuilder: (context, index) {
                      return buildGridItem(cars[index]);
                    },
                  )
                : ListView.builder(
                    itemCount: cars.length,
                    itemBuilder: (context, index) {
                      return buildListItem(cars[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class CarCatalogModel {
  final String name;
  final int price;
  final String image;
  final String link;

  CarCatalogModel({
    required this.name,
    required this.price,
    required this.image,
    required this.link,
  });
}
