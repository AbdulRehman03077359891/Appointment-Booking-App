import 'package:appointment_booking_app/Controllers/admin_dashboard_controller.dart';
import 'package:appointment_booking_app/Controllers/animation_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewRequests extends StatefulWidget {
  final String userUid, userName, userEmail;
  final String? userProfilePic;  // final int index;
  const ViewRequests({
    super.key,
    required this.userUid,
    required this.userName,
    required this.userEmail, this.userProfilePic,
    // required this.profilePicture,
    // required this.index
  });

  @override
  State<ViewRequests> createState() => _ViewRequestsState();
}

class _ViewRequestsState extends State<ViewRequests> {
  var animateController = Get.put(AnimateController());
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
    adminDashboardController.fetchRequests();
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
          "Requests",
          style: TextStyle(fontWeight: FontWeight.bold),
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
              : adminDashboardController.req.isEmpty
                  ? const Center(
                      child: Text(
                        "No requests available",
                        style: TextStyle(
                            color: Color(0xFFE63946),
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: adminDashboardController.req.length,
                              itemBuilder: (context, index) {
                                return HorizontalPostCard(
                                  adminUid: widget.userUid,
                                  adminName: widget.userName,
                                  adminEmail: widget.userEmail,
                                  adminProfilePic: widget.userProfilePic,
                                  userUid: adminDashboardController
                                      .req[index]["userUid"],
                                  userName: adminDashboardController
                                      .req[index]["userName"],
                                  userEmail: adminDashboardController
                                      .req[index]["userEmail"],
                                  userProfilePic: adminDashboardController.req[index]["userPic"],
                                  userCnic: adminDashboardController
                                      .req[index]["userCnic"],
                                  userBloodType: adminDashboardController
                                      .req[index]["userBloodType"],
                                  userContact: adminDashboardController
                                      .req[index]["userContact"],
                                  userGender: adminDashboardController
                                      .req[index]["userGender"],
                                  appliedAt: adminDashboardController.req[index]
                                      ["appliedAt"],
                                  ambuKey: adminDashboardController.req[index]
                                      ["ambuKey"],
                                  ambuPic: adminDashboardController.req[index]
                                      ["ambuPic"],
                                  index: index,
                                  reqKey: adminDashboardController.req[index]
                                      ["reqKey"],
                                  status: adminDashboardController.req[index]
                                      ["status"],
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

class HorizontalPostCard extends StatelessWidget {
  final String adminUid, adminName, adminEmail;
  final String? adminProfilePic;
  final String userUid;
  final String userGender;
  final String ambuKey;
  final String userName;
  final String userEmail;
  final String? userProfilePic;
  final String appliedAt;
  final String ambuPic;
  final String reqKey;
  final String userCnic;
  final String status;
  final String userBloodType;
  final String userContact;
  final int index;

  const HorizontalPostCard({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.appliedAt,
    required this.ambuPic,
    required this.index,
    required this.reqKey,
    required this.userUid,
    required this.userCnic,
    required this.status,
    required this.userBloodType,
    required this.userContact,
    required this.userGender,
    required this.ambuKey, required this.adminUid, required this.adminName, required this.adminEmail, this.adminProfilePic, this.userProfilePic,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AnimateController>(builder: (animateController) {
      return Card(
        color: Colors.white,
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Row(
          children: [
            // Ambu Image on the left side
            GestureDetector(
              onTap: () =>
                  animateController.showSecondPage("$index", ambuPic, context),
              child: Hero(
                tag: "$index",
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15)),
                  child: CachedNetworkImage(
                    height: 160,
                    width: 120,
                    fit: BoxFit.cover,
                    imageUrl: ambuPic,
                  ),
                ),
              ),
            ),
            // Text Information on the right side
            Expanded(
              child: InkWell(
                onTap: () {
                  //  Get.to(RequestDetailScreen(
                  //   adminUid: adminUid,
                  //   adminName: adminName,
                  //   adminEmail: adminEmail,
                  //   adminProfilePic: adminProfilePic,
                  //   userUid: userUid,
                  //   userName: userName,
                  //   userEmail: userEmail,
                  //   userProfilePic: userProfilePic,
                  //   userContact: userContact,
                  //   userCnic: userCnic,
                  //   userGender: userGender,
                  //   userBloodType: userBloodType,
                  //   ambuKey: ambuKey,
                  //   ambuPic: ambuPic,
                  //   status: status,
                  //   appliedAt: appliedAt,
                  //   reqKey: reqKey,
                  // ));
                  },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ambu Name
                      Text(
                        userName,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFE63946)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),

                      Text(
                        userEmail,
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black54),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Contact: $userContact",
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black54),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        userBloodType,
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black54),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      // appliedAt
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            status,
                            style: TextStyle(
                                fontSize: 14,
                                color: status == "pending"
                                    ? Colors.grey.shade600
                                    : status == "Accepted"
                                        ? Colors.green
                                        : Colors.red,
                                fontWeight: FontWeight.w600),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "Applied at:$appliedAt",
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
