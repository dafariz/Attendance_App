import 'package:flutter/material.dart';
import 'package:attendance_rec_app_dafa/onboardingscreen.dart';

//Muhammad Dafa Rizqullah

void main() => runApp(const AttendanceRecordApp());

class AttendanceRecordApp extends StatelessWidget {
  const AttendanceRecordApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance Record System',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      //home: AttendanceRecordScreen(),
      home: OnboardingScreen(),
    );
  }
}


