
import 'package:appointment_booking_app/Controllers/user_notification_services.dart';
import 'package:appointment_booking_app/Screen/User/chatbot_screen.dart';
import 'package:appointment_booking_app/Screen/User/search_page.dart';
import 'package:appointment_booking_app/Widgets/e1_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appointment_booking_app/Controllers/user_dashboard_controller.dart';
import 'package:appointment_booking_app/Screen/User/user_ambu_via_categery.dart';
import 'package:appointment_booking_app/Widgets/User/user_drawer_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';

class UserScreen extends StatefulWidget {
  final String userUid, userName, userEmail;

  const UserScreen({
    super.key,
    required this.userUid,
    required this.userName,
    required this.userEmail,
  });

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final UserDashboardController userDashboardController =
      Get.put(UserDashboardController());
  UserNotificationServices userNotificationServices = UserNotificationServices();
  // final TokenController tokenController = Get.put(TokenController());
  // final ChatBotController chatBotController = ChatBotController();

  @override
  void initState() {
    super.initState();
    userDashboardController.getDashBoardData();
    // tokenController.initializeFCM(widget.userUid, false);
    userNotificationServices.requestNotificationPermissions(context);
      userNotificationServices.firebaseInit(context);
      userNotificationServices.setupInteractMessage(context);
      userNotificationServices.getDeviceToken().then((token) {
        if (token.isNotEmpty) {
      userNotificationServices.storeUserFCMToken(widget.userUid, token);
    }
    // Start listening for new requests and trigger notifications
    userNotificationServices.listenForNewRequests(widget.userUid);
    });
  }
   List imagesList = [
    "assets/images/adver1.jpeg",
    "assets/images/adver2.jpeg",
    "assets/images/adver3.jpeg"
  ];


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 245, 222, 224),
        appBar: AppBar(
          centerTitle: true,
          titleSpacing: 1,
          foregroundColor: const Color(0xFFE63946),
          backgroundColor: Colors.white,
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
        ),
        drawer: UserDrawerWidget(
          userUid: widget.userUid,
          accountName: widget.userName,
          accountEmail: widget.userEmail,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Obx(() {
                  if (userDashboardController.hos.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return CarouselSlider.builder(
                    itemCount: userDashboardController.hos.length,
                    itemBuilder: (BuildContext context, int itemIndex,
                        int pageViewIndex) {
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Wrap(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Get.to(UserAmbulanceViaHospitals(
                                    userUid: widget.userUid,
                                    userName: widget.userName,
                                    userEmail: widget.userEmail,
                                    index: itemIndex,
                                  ));
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      userDashboardController
                                          .hos[itemIndex]["name"],
                                      style: const TextStyle(
                                        color: Color(0xFFE63946),
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          BoxShadow(
                                              blurRadius: 2, spreadRadius: 2),
                                        ],
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${userDashboardController.hos[itemIndex]["ambuCount"] ?? 0} Doctors',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    options: CarouselOptions(
                      viewportFraction: .50,
                      height: 110,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      autoPlayInterval: const Duration(seconds: 10),
                      autoPlayAnimationDuration: const Duration(seconds: 4),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20,),
              CarouselSlider.builder(
                itemCount: imagesList.length,
                itemBuilder:
                    (BuildContext context, int itemIndex, int pageViewIndex) {
                  // final category = studentDashboardController.cat[itemIndex];
                  return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset(
                        imagesList[itemIndex],
                        fit: BoxFit.fitWidth,
                      ));
                },
                options: CarouselOptions(
                  viewportFraction: .90,
                  // height: 180,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  autoPlayInterval: const Duration(seconds: 5),
                  autoPlayAnimationDuration: const Duration(seconds: 3),
                ),
              ),
              const SizedBox(height: 30,),
               E1Button(backColor: const Color(0xFFE63946), text: "Search Doctors", textColor: Colors.white,onPressed: (){Get.to(SearchPage(userUid: widget.userUid, userName: widget.userName, userEmail: widget.userEmail));},),
              const Row(
                children: [
                  Expanded(child: Card()),
                  Expanded(child: Card()),
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigate to the ChatBotPage
            Get.to(() =>
              ChatScreen(),
            );
          },
          child: const Icon(Icons.chat, color: Colors.red,),
        ),
      ),
    );
  }
}
