import 'package:appointment_booking_app/Controllers/animation_controller.dart';
import 'package:appointment_booking_app/Controllers/doc_dashboard.dart';
import 'package:appointment_booking_app/Controllers/doctor_notification.dart';
import 'package:appointment_booking_app/Screen/Doctor/request_details.dart';
import 'package:appointment_booking_app/Widgets/Doctor/doc_drawer_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoctorScreen extends StatefulWidget {
  final String userUid, userName, userEmail;
  final String? userProfilePic;  // final int index;
  const DoctorScreen({
    super.key,
    required this.userUid,
    required this.userName,
    required this.userEmail, this.userProfilePic,
    // required this.profilePicture,
    // required this.index
  });

  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  var animateController = Get.put(AnimateController());
  // final AdminDashboardController adminDashboardController =
  //     Get.put(AdminDashboardController());
  final DocDashboardController docDashboardController = Get.put(DocDashboardController());
      DocNotificationServices notificationServices = Get.put(DocNotificationServices());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((value) {
      getAllHospitals();
       // tokenController.initializeFCM(widget.userUid, true);
      notificationServices.requestNotificationPermissions(context);
      notificationServices.firebaseInit(context);
      notificationServices.setupInteractMessage(context);
      notificationServices.getDeviceToken().then((token) {
        if (token.isNotEmpty) {
      // notificationServices.storeDoctorFCMToken(widget.userUid, token);
    }
    // Start listening for new requests and trigger notifications
    notificationServices.listenForNewRequests(widget.userUid);
      });
    });
  }

  getAllHospitals() {
    docDashboardController.fetchRequests(widget.userUid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        // leading: IconButton(
        //   onPressed: () {
        //     Get.back();
        //   },
        //   icon: const Icon(Icons.arrow_back_ios_new),
        // ),
        title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  height: 55,
                  child: Image.asset('assets/images/Logo.jpg'),
                ),
              ),
              const Text(
                "Doctor's Appointment Booking",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [BoxShadow(blurRadius: 5, spreadRadius: 10)],
                ),
              ),
            ],
          ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFFE63946),
      ),
      drawer: DocDrawerWidget(
        userUid: widget.userUid,
        accountName: widget.userName,
        accountEmail: widget.userEmail,
      ),
      body: Obx(
        () {
          return docDashboardController.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(
                  color: Color(0xFFE63946),
                ))
              : docDashboardController.req.isEmpty
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
                              itemCount: docDashboardController.req.length,
                              itemBuilder: (context, index) {
                                return HorizontalPostCard(
                                  adminUid: widget.userUid,
                                  adminName: widget.userName,
                                  adminEmail: widget.userEmail,
                                  adminProfilePic: widget.userProfilePic,
                                  userUid: docDashboardController
                                      .req[index]["userUid"],
                                  userName: docDashboardController
                                      .req[index]["userName"],
                                  userEmail: docDashboardController
                                      .req[index]["userEmail"],
                                  userProfilePic: docDashboardController.req[index]["userPic"],
                                  userCnic: docDashboardController
                                      .req[index]["userCnic"],
                                  userBloodType: docDashboardController
                                      .req[index]["userBloodType"],
                                  userContact: docDashboardController
                                      .req[index]["userContact"],
                                  userGender: docDashboardController
                                      .req[index]["userGender"],
                                  appliedAt: docDashboardController.req[index]
                                      ["appliedAt"],
                                  ambuKey: docDashboardController.req[index]
                                      ["ambuKey"],
                                  ambuPic: docDashboardController.req[index]
                                      ["ambuPic"],
                                  index: index,
                                  reqKey: docDashboardController.req[index]
                                      ["reqKey"],
                                  status: docDashboardController.req[index]
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
                onTap: () { Get.to(RequestDetailScreen(
                    adminUid: adminUid,
                    adminName: adminName,
                    adminEmail: adminEmail,
                    adminProfilePic: adminProfilePic,
                    userUid: userUid,
                    userName: userName,
                    userEmail: userEmail,
                    userProfilePic: userProfilePic,
                    userContact: userContact,
                    userCnic: userCnic,
                    userGender: userGender,
                    userBloodType: userBloodType,
                    ambuKey: ambuKey,
                    ambuPic: ambuPic,
                    status: status,
                    appliedAt: appliedAt,
                    reqKey: reqKey,
                  ));},
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
