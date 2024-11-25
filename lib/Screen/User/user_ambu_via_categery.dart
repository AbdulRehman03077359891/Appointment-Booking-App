import 'package:appointment_booking_app/Controllers/animation_controller.dart';
import 'package:appointment_booking_app/Controllers/user_dashboard_controller.dart';
import 'package:appointment_booking_app/Widgets/User/user_horizontal_ambu_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserAmbulanceViaHospitals extends StatefulWidget {
  final String userUid, userName, userEmail;
  // profilePicture;
  final int index;
  const UserAmbulanceViaHospitals(
      {super.key,
      required this.userUid,
      required this.userName,
      required this.userEmail,
      // required this.profilePicture,
      required this.index});

  @override
  State<UserAmbulanceViaHospitals> createState() => _UserAmbulanceViaHospitalsState();
}

class _UserAmbulanceViaHospitalsState extends State<UserAmbulanceViaHospitals> {
  var animateController = Get.put(AnimateController());
  final UserDashboardController userDashboardController  =
      Get.put(UserDashboardController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((value) {
      getAllHospitals();
    });
  }

  getAllHospitals() {
    userDashboardController.getAmbu(widget.index);
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
        title: const Text(
          "View Ambulances",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFFE63946),
      ),
      body: Obx(
        () {
          return userDashboardController.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(
                  color: Color(0xFFE63946),
                ))
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:
                              userDashboardController.selectedAmbu.length,
                          itemBuilder: (context, index) {
                            return  UserHorizontalAmbuCard(
                                  ambuName: userDashboardController
                                  .selectedAmbu[index]["ambuName"],
                                  ambuContact: userDashboardController
                                  .selectedAmbu[index]["ambuContact"],
                                  // ambuPlate: userDashboardController
                                  // .selectedAmbu[index]["ambuPlate"],
                                  // ambuSize: userDashboardController
                                  // .selectedAmbu[index]["ambuSize"],
                                  description: userDashboardController
                                  .selectedAmbu[index]["discription"],
                                  imageUrl: userDashboardController
                                  .selectedAmbu[index]["ambuPic"],
                                  index: index,
                                  ambuKey: userDashboardController
                                  .selectedAmbu[index]["ambuKey"],
                                  hosName: userDashboardController
                                  .selectedAmbu[index]["hospital"],
                                  docUid: userDashboardController.selectedAmbu[index]["ambuUid"],
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
