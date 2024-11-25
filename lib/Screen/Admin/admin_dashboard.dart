import 'package:appointment_booking_app/Controllers/admin_dashboard_controller.dart';
import 'package:appointment_booking_app/Controllers/admin_notfication_sevices.dart';
import 'package:appointment_booking_app/Screen/Admin/admin_ambu_categorized.dart';
import 'package:appointment_booking_app/Widgets/Admin/admin_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminDashboard extends StatefulWidget {
  final String userUid, userName, userEmail;
  const AdminDashboard({
    super.key,
    required this.userUid,
    required this.userName,
    required this.userEmail,
  });

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {

  NotificationServices notificationServices = NotificationServices();

  final AdminDashboardController adminDashboardController =
      Get.put(AdminDashboardController());
  // final TokenController tokenController = Get.put(TokenController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      adminDashboardController.getDashBoardData();
      // tokenController.initializeFCM(widget.userUid, true);
      notificationServices.requestNotificationPermissions(context);
      notificationServices.firebaseInit(context);
      notificationServices.setupInteractMessage(context);
      notificationServices.getDeviceToken().then((token) {
        if (token.isNotEmpty) {
      notificationServices.storeAdminFCMToken(widget.userUid, token);
    }
    // Start listening for new requests and trigger notifications
    notificationServices.listenForNewRequests(widget.userUid);
      });
    });
  }

@override
Widget build(BuildContext context) {
  return SafeArea(
    child: Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 222, 224),
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        titleSpacing: 1,
        foregroundColor: const Color(0xFFE63946),
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
              'Appointment Booking',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                shadows: [BoxShadow(blurRadius: 5, spreadRadius: 10)],
              ),
            ),
          ],
        ),
      ),
      drawer: AdminDrawerWidget(
        userUid: widget.userUid,
        accountName: widget.userName,
        accountEmail: widget.userEmail,
      ),
      body: Obx(
        () {
          if (adminDashboardController.hos.isEmpty) {
            return const Center(
              child: Text("No Category Available", style: TextStyle(color: Color(0xFFE63946)),),
            );
          } else {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3 / 4,
              ),
              itemCount: adminDashboardController.hos.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Get.to(AmbulanceViaHospitals(
                              userUid: widget.userUid,
                              userName: widget.userName,
                              userEmail: widget.userEmail,
                              index: index,
                              hospital: adminDashboardController.hos[index]["name"],
                            ));
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                adminDashboardController.hos[index]["name"],
                                style: const TextStyle(
                                  color: Color(0xFFE63946),
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    BoxShadow(blurRadius: 2, spreadRadius: 2),
                                  ],
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${adminDashboardController.hos[index]["ambuCount"] ?? 0} Doctors',
                                style:  TextStyle(
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
            );
          }
        },
      ),
    ));
  }
}

