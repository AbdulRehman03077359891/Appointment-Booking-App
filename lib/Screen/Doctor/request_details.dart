import 'package:appointment_booking_app/Controllers/chat_controller.dart';
import 'package:appointment_booking_app/Controllers/doc_dashboard.dart';
import 'package:appointment_booking_app/Widgets/e1_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RequestDetailScreen extends StatefulWidget {
  final String adminUid, adminName, adminEmail;
  final String? adminProfilePic;
  final String userUid;
  final String userName;
  final String userEmail;
  final String? userProfilePic;
  final String userContact;
  final String userCnic;
  final String userGender;
  final String userBloodType;
  final String ambuKey;
  final String ambuPic;
  final String status;
  final String appliedAt;
  final String reqKey;

  const RequestDetailScreen({
    super.key,
    required this.userUid,
    required this.userName,
    required this.userEmail,
    required this.userContact,
    required this.userCnic,
    required this.userGender,
    required this.userBloodType,
    required this.ambuKey,
    required this.ambuPic,
    required this.status,
    required this.appliedAt,
    required this.reqKey,
    required this.adminUid,
    required this.adminName,
    required this.adminEmail,
    this.adminProfilePic,
    this.userProfilePic,
  });
  

  @override
  State<RequestDetailScreen> createState() => _RequestDetailScreenState();
}

class _RequestDetailScreenState extends State<RequestDetailScreen> {
  final DocDashboardController docDashboardController = Get.put(DocDashboardController());
    final ChatController chatController = Get.put(ChatController());


  @override
  Widget build(BuildContext context) {
    // final AdminDashboardController adminDashboardController =
    //     Get.put(AdminDashboardController());
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Request Details',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
        ),
        backgroundColor: const Color(0xFFE63946),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Align(
              alignment: Alignment.center,
              child: Text(
                "Details",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFE63946)),
              ),
            ),
            const Divider(),
            buildDetailRow('user Name:', widget.userName),
            buildDetailRow('user Email:', widget.userEmail),
            buildDetailRow('user Contact:', widget.userContact),
            buildDetailRow('user CNIC:', widget.userCnic),
            buildDetailRow('Gender:', widget.userGender),
            buildDetailRow('BloodType:', widget.userBloodType),
            buildDetailRow('Status:', widget.status),
            buildDetailRow('Applied At:', widget.appliedAt),
            const SizedBox(height: 20),
            const Divider(),
            widget.ambuPic.isNotEmpty
                ? Image.network(
                    widget.ambuPic,
                    fit: BoxFit.fitWidth,
                  )
                : const SizedBox(),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                E1Button(
                    onPressed: () {
                      docDashboardController.updateRequest(
                          widget.reqKey, 'Rejected', widget.adminUid, widget.adminName, widget.adminEmail);
                    },
                    backColor: Colors.white,
                    text: "Reject",
                    textColor: const Color(0xFFE63946)),
                E1Button(
                    onPressed: () {
                      docDashboardController.updateRequest(
                          widget.reqKey, 'Accepted', widget.adminUid, widget.adminName, widget.adminEmail);
                      chatController.createConversation(
                        widget.adminUid,
                        widget.adminName,
                        widget.adminEmail,
                        widget.adminProfilePic,
                        widget.userUid,
                        widget.userName,
                        widget.userEmail,
                        widget.userProfilePic,
                      );
                    },
                    backColor: Colors.white,
                    text: "Accept",
                    textColor: const Color(0xFFE63946)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
