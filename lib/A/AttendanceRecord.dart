// ignore: file_names

class AttendanceRecord {
  final int? id;
  final String user;
  final String phone;
  final String time;

  AttendanceRecord({
    this.id,
    required this.user,
    required this.phone,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user': user,
      'phone': phone,
      'time': time,
    };
  }

  static AttendanceRecord fromMap(Map<String, dynamic> map) {
    return AttendanceRecord(
      id: map['id'],
      user: map['user'],
      phone: map['phone'],
      time: map['time'],
    );
  }

  
}

