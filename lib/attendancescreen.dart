import 'package:attendwithqrcode/employeescreen.dart';
import 'package:attendwithqrcode/loginscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key, required this.scanResult}) : super(key: key);
  final String scanResult;

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  bool buildWidgets = false;

  @override
  void initState() {
    super.initState();
    checkKey();
  }

  Future<void> checkKey() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection("Key")
        .doc("loginkey1")
        .get();

    String key = snap['key'];

    if(widget.scanResult.toUpperCase() == key) {
      debugPrint("True");
      setState(() {
        buildWidgets = true;
      });
    } else {
      debugPrint("False");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const EmployeeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: buildWidgets ? Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                await FirebaseFirestore.instance.collection("Employee").doc(LoginInfo.id).update({
                  'checkIn': Timestamp.now(),
                });
              },
              child: button("CHECK IN"),
            ),
            const SizedBox(height: 20,),
            GestureDetector(
              onTap: () async {
                await FirebaseFirestore.instance.collection("Employee").doc(LoginInfo.id).update({
                  'checkOut': Timestamp.now(),
                });
              },
              child: button("CHECK OUT"),
            ),
          ],
        ) : const SizedBox(),
      ),
    );
  }

  Widget button(String text) {
    return Container(
      height: 80,
      width: 150,
      color: Colors.orange,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

}
