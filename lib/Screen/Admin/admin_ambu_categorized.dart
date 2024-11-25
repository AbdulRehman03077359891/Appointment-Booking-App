import 'package:appointment_booking_app/Controllers/admin_dashboard_controller.dart';
import 'package:appointment_booking_app/Controllers/animation_controller.dart';
import 'package:appointment_booking_app/Controllers/business_controller.dart';
import 'package:appointment_booking_app/Widgets/Admin/admin_horizontal_ambu_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AmbulanceViaHospitals extends StatefulWidget {
  final String userUid, userName, userEmail, hospital;
  // profilePicture;
  final int index;
  const AmbulanceViaHospitals(
      {super.key,
      required this.userUid,
      required this.userName,
      required this.userEmail,
      required this.hospital,
      // required this.profilePicture,
      required this.index});

  @override
  State<AmbulanceViaHospitals> createState() => _AmbulanceViaHospitalsState();
}

class _AmbulanceViaHospitalsState extends State<AmbulanceViaHospitals> {
  var animateController = Get.put(AnimateController());
  var businessController = Get.put(BusinessController());
  final AdminDashboardController adminDashboardController =
      Get.put(AdminDashboardController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((value) {
      getAllHospitals();
    });
  }

  getAllHospitals() {
    adminDashboardController.getAmbu(widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: Text(
          "${widget.hospital}'s Doctor",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFFE63946),
      ),
      body: Obx(
        () {
          return adminDashboardController.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(
                  color: Color(0xFFE63946),
                ))
              : adminDashboardController.selectedAmbu.isEmpty
                  ? Center(
                      child: Text(
                          "No Doctor available in this ${widget.hospital}"),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:
                                  adminDashboardController.selectedAmbu.length,
                              itemBuilder: (context, index) {
                                print("${adminDashboardController.selectedAmbu}");
                                return AdminHorizontalAmbuCard(
                                  ambuName: adminDashboardController
                                      .selectedAmbu[index]["ambuName"],
                                  ambuContact: adminDashboardController
                                      .selectedAmbu[index]["ambuContact"],
                                  // ambuPlate: adminDashboardController
                                  //     .selectedAmbu[index]["ambuPlate"],
                                  // ambuSize: adminDashboardController
                                  //     .selectedAmbu[index]["ambuSize"],
                                  description: adminDashboardController
                                      .selectedAmbu[index]["discription"],
                                  imageUrl: adminDashboardController
                                      .selectedAmbu[index]["ambuPic"],
                                  index: index,
                                  ambuKey: adminDashboardController
                                      .selectedAmbu[index]["ambuKey"],
                                  userUid: widget.userUid,
                                  userName: widget.userName,
                                  userEmail: widget.userEmail,
                                );
                              })
                        ],
                      ),
                    );
        },
      ),
    );
  }
}
