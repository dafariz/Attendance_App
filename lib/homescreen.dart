import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'A/AttendanceRecord.dart';
import 'detailsScreen.dart';
import 'package:share/share.dart';

class AttendanceRecordScreen extends StatefulWidget {
  const AttendanceRecordScreen({super.key});

  @override
  _AttendanceRecordScreenState createState() => _AttendanceRecordScreenState();
}

class _AttendanceRecordScreenState extends State<AttendanceRecordScreen> {
  List<AttendanceRecord> records = [];
  List<AttendanceRecord> listRecords = [];

  late Database _database;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();

  bool showEndOfListIndicator = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        showEndOfListIndicator = true;
      });
    } else {
      setState(() {
        showEndOfListIndicator = false;
      });
    }
  }

  Future<String> getContactInfoFromDatabase() async {
    // Open the database
    // Shaer contact information
    Database database = await openDatabase(
      join(await getDatabasesPath(), 'attendance.db'),
      version: 1, // Specify the database version
      onCreate: (db, version) {
        // Call the function to create the 'contacts' table
        createContactsTable(db);
      },
    );

    // Query the database and retrieve the contact information
    List<Map<String, dynamic>> queryResult =
        await database.rawQuery('SELECT * FROM attendance');

    // Close the database
    await database.close();

    // Process the query result and format contact information
    String contactInfo = '';
    for (Map<String, dynamic> contact in queryResult) {
      String user = contact['user'];
      String phone = contact['phone'];
      contactInfo += '$user\\n$phone\n\n';
    }

    return contactInfo;
  }

  void shareContactInfo(BuildContext context, String contactInfo) {
    if (contactInfo.isNotEmpty) {
      Share.share(contactInfo);
    } else {

    }
  }

  Future<void> createContactsTable(Database database) async {
    await database.execute('''
      CREATE TABLE attendance (
        id INTEGER PRIMARY KEY,
        user TEXT,
        phone TEXT
      )
    ''');
  }

  Future<void> _initializeDatabase() async {
    // Database initialization
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'attendance.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE attendance(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user TEXT,
            phone TEXT,
            time TEXT
          )
          ''',
        );
      },
    );

    _takeAttRec();
  }

  Future<void> _takeAttRec() async {
    // grab attendace records data
    final recordsMap = await _database.query('attendance');
    setState(() {
      records = recordsMap.map((map) => AttendanceRecord.fromMap(map)).toList();
      listRecords = records;
    });
  }

  void _searchDetails(String keyword) {
    // Search through the list
    setState(() {
      listRecords = records.where((record) {
        final user = record.user.toLowerCase();
        final phone = record.phone.toLowerCase();
        return user.contains(keyword.toLowerCase()) ||
            phone.contains(keyword.toLowerCase());
      }).toList();
    });
  }

  Future<void> _addNewRecord(AttendanceRecord record) async {
    // Adding attendance record
    await _database.insert('attendance', record.toMap());
    _takeAttRec();

    _submitnotification();
  }

  void _submitnotification() {
    const snackBar = SnackBar(
      content: Text('Submitted 🥳!!'),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    records.sort((a, b) => b.time.compareTo(a.time));

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Welcome to Attendance Record'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                _searchDetails(value);
              },
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              controller: _scrollController,
              itemCount: listRecords.length + 1,
              itemBuilder: (context, index) {
                if (index == listRecords.length) {
                  // Display end of list notification
                  return ListTile(
                    title: showEndOfListIndicator
                        ? const Text(
                            'end of the list',
                            textAlign: TextAlign.center,
                          )
                        : const SizedBox.shrink(),
                  );
                }

                final record = listRecords[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SearchDetailsScreen(record: record),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: const Icon(Icons.schedule_rounded),
                    dense: true,
                    title: Column(
                      children: [
                        Text('User: "${record.user}"',
                            textAlign: TextAlign.left),
                        Text('Phone: "${record.phone}"',
                            textAlign: TextAlign.left),
                        Text('Check-In: "${record.time}"',
                            textAlign: TextAlign.left)
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  thickness: 3,
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              String contactInfo = await getContactInfoFromDatabase();
              shareContactInfo(context, contactInfo);
            },
            child: const Text('Share Contact Info'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDialog(context);
        },
        child: const Icon(Icons.add_circle_outline_rounded),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final userController = TextEditingController();
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Please Input Attendance Data:'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: userController,
                decoration: const InputDecoration(labelText: 'User'),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final user = userController.text;
                final phone = phoneController.text;
                final time =
                    DateFormat('dd-MM-yyyy hh:mm').format(DateTime.now());
                final record =
                    AttendanceRecord(user: user, phone: phone, time: time);

                _addNewRecord(record);
                Navigator.of(context).pop();
              },
              child: const Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
