import 'package:flutter/material.dart';
import 'package:flutter_cyber_app/second_screen/appointment/create_appointment_screen.dart';

class BookAppointmentScreen extends StatefulWidget {
  const BookAppointmentScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _BookAppointmentScreenState();
  }
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  bool isGrid = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Đặt lịch hẹn",
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateAppointmentScreen()),
          );
        },
      ),
      body: Center(
        child: Text("Something")),
    );
  }
}
