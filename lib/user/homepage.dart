import 'package:emib_hospital/user/firstpage/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:emib_hospital/pages/exercise_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../pages/att_screen.dart'; // นำเข้า AttractionsScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyHomePage',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String? status; // รับค่าที่บันทึกมา เช่น "Normal", "Low", "High"
  final DateTime? date; // รับวันที่ที่บันทึก

  const MyHomePage({Key? key, this.status, this.date}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // ฟังก์ชันคืนค่าสีตามสถานะ
  Color getStatusColor(String? status) {
    switch (status) {
      case 'Low':
        return Colors.orange;
      case 'High':
        return Colors.red;
      case 'Normal':
        return Colors.green;
      default:
        return Colors.grey; // หากไม่มีสถานะ (Default)
    }
  }

  @override
  Widget build(BuildContext context) {
    // ใช้สถานะและวันที่จาก Widget
    String status = widget.status ?? 'No Data'; // ถ้าไม่มีสถานะ ให้แสดง No Data
    DateTime date =
        widget.date ?? DateTime.now(); // ถ้าไม่มีวันที่ ใช้วันที่ปัจจุบัน

    return DefaultTabController(
      length: 2, // จำนวนแท็บ
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: Colors.lightBlue[100],
                expandedHeight: 500.0, // ขนาด SliverAppBar
                floating: false,
                pinned: true,
                actions: [
                  // ไอคอน Notification
                  IconButton(
                    icon:
                        Icon(Icons.notifications_outlined, color: Colors.black),
                    onPressed: () {
                      // เพิ่มฟังก์ชันนำทางไปหน้า Notification
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotificationPage()),
                      );
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: EdgeInsets.only(bottom: 70.0),
                  background: Stack(
                    children: [
                      ClipPath(
                        clipper: CurvedClipper(),
                        child: Container(
                          color: Colors.purple[100],
                          child: Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // วันที่
                                  Text(
                                    'Today',
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${date.day} ${_getMonthName(date.month)}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 10),

                                  // สถานะ
                                  Text(
                                    status,
                                    style: TextStyle(
                                      fontSize: 40,
                                      color: getStatusColor(status),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),

                                  // วงกลมเปลี่ยนสีตามสถานะ
                                  Container(
                                    width: 200,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      color: getStatusColor(status),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.4),
                                          spreadRadius: 3,
                                          blurRadius: 7,
                                          offset: Offset(6, 12),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${date.day}',
                                        style: TextStyle(
                                          fontSize: 90,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(50.0),
                  child: TabBar(
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.blue,
                    tabs: [
                      Tab(
                        icon: FaIcon(FontAwesomeIcons.carrot),
                        text: "HealthFood for you",
                      ),
                      Tab(
                        icon: FaIcon(FontAwesomeIcons.dumbbell),
                        text: "Health inside",
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              AttractionsScreen(), // หน้าแรก
              ExerciseScreen(), // หน้าสอง
            ],
          ),
        ),
      ),
    );
  }

  // ฟังก์ชันดึงชื่อเดือน
  String _getMonthName(int month) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return monthNames[month - 1];
  }
}

class CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 120);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 120);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
