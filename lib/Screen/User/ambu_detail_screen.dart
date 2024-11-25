import 'package:appointment_booking_app/Controllers/fire_controller.dart';
import 'package:appointment_booking_app/Screen/User/apply_form.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoctorDetailScreen extends StatefulWidget {
  final String ambuName,
      description,
      ambuContact,
      // ambuPlate,
      // ambuSize,
      imageUrl,
      ambuKey,
      hosName,
      docUid;
  final int index;
  final String userUid, userName, userEmail;

  const DoctorDetailScreen({
    super.key,
    required this.ambuName,
    required this.description,
    required this.imageUrl,
    required this.userUid,
    required this.userName,
    required this.userEmail,
    required this.ambuKey,
    required this.ambuContact,
    // required this.ambuPlate,
    // required this.ambuSize,
    required this.index, required this.hosName, required this.docUid,
  });

  @override
  State<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  final FireController fireController = Get.put(FireController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchData();
    });
  }

  Future<void> fetchData() async {
    await fireController.fireBaseDataFetch(context, widget.userUid, "go");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back_ios_new),
            ),
        title: Text(
          widget.ambuName,
          style: const TextStyle(fontWeight: FontWeight.bold),
          softWrap: true,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFFE63946),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display the Doctor image
              Center(
                child: CachedNetworkImage(
                  imageUrl: widget.imageUrl,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fitWidth,
                ),
              ),
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
              buildDetailRow('Doctor Name:', widget.ambuName),
              buildDetailRow('Doctor Contact:', widget.ambuContact),
              // buildDetailRow('Plate Number:', widget.ambuPlate),
              // buildDetailRow('Doctor Size:', widget.ambuSize),
              const SizedBox(height: 20),
              const Divider(),

              const SizedBox(height: 16),
              // Display the Doctor description
              const Text(
                "Description",
                style: TextStyle(
                    color: Color(0xFFE63946),
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              Text(
                widget.description,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 20),

              // Button to apply
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle apply button functionality here
                    Get.to((FormApplication(
                      userName: fireController.userData["userName"],
                      userUid: widget.userUid,
                      gender: fireController.userData["userGender"],
                      contact: fireController.userData["userContact"],
                      dob: fireController.userData["dateOfBirth"],
                      userEmail: fireController.userData["userEmail"],
                      userPic: fireController.userData["profilePic"],
                      ambuKey: widget.ambuKey,
                      ambuPic: widget.imageUrl,
                      ambuName: widget.ambuName,
                      hosName: widget.hosName,
                      docUid: widget.docUid,
                    )));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE63946),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Apply Now',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
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
