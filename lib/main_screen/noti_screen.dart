import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: TabBar(
            isScrollable: true,
            labelColor: Colors.green,
            unselectedLabelColor: Colors.black,
            indicatorColor: Colors.green,
            tabs: [
              Tab(text: "Thông báo chung"),
              Tab(text: "Kinh doanh"),
              Tab(text: "Nhân sự"),
              Tab(text: "Tab moi"),
              Tab(text: "Tab test"),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
          onPressed: () {},
        ),

        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== TAB CONTENT =====
            Expanded(
              child: TabBarView(
                children: [
                  buildNotificationList(),
                  buildNotificationList(),
                  buildNotificationList(),
                  buildNotificationList(),
                  buildNotificationList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== LISTVIEW UI =====
  Widget buildNotificationList() {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: 10, // dummy 10 items
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        return notificationItem(
          title: "Title $index",
          subtitle: "Nội dung thông báo số $index",
          date: DateTime.now(),
        );
      },
    );
  }

  // ===== SINGLE ITEM UI =====
  Widget notificationItem({
    required String title,
    required String subtitle,
    required DateTime date,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: () {},
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // LEFT SIDE: TEXT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        DateFormat("dd-MM-yyyy HH:mm").format(date),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // RIGHT SIDE: "Readme"
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Readme",
                style: TextStyle(color: Colors.orange.shade700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
