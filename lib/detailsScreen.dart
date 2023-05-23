import 'package:flutter/material.dart';
import 'A/AttendanceRecord.dart';

class SearchDetailsScreen extends StatelessWidget {
  final AttendanceRecord record;

  const SearchDetailsScreen({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Here is details that you are looking for:'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('user: ${record.user}'),
            Text('Phone: ${record.phone}'),
            Text('Check-In: ${record.time}'),
          ],
        ),
      ),
    );
  }
}
