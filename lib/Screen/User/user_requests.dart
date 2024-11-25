import 'package:appointment_booking_app/Controllers/animation_controller.dart';
import 'package:appointment_booking_app/Controllers/user_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UsersRequests extends StatefulWidget {
  final String userUid, userName, userEmail;
  // profilePicture;
  // final int index;
  const UsersRequests({
    super.key,
    required this.userUid,
    required this.userName,
    required this.userEmail,
    // required this.profilePicture,
    // required this.index
  });

  @override
  State<UsersRequests> createState() => _UsersRequestsState();
}

class _UsersRequestsState extends State<UsersRequests> {
  var animateController = Get.put(AnimateController());
  final UserController userController = Get.put(UserController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((value) {
      getAllHospitals();
    });
  }

  getAllHospitals() {
    userController.fetchRequests(widget.userUid);
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
          return userController.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(
                  color: Color(0xFFE63946),
                ))
              : userController.req.isEmpty
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
                              itemCount: userController.req.length,
                              itemBuilder: (context, index) {
                                return HorizontalPostCard(
                                  usersName: userController.req[index]
                                      ["userName"],
                                  usersEmail: userController.req[index]
                                      ["userEmail"],
                                  appliedAt: userController.req[index]
                                      ["appliedAt"],
                                  ambuPic: userController.req[index]
                                      ["ambuPic"],
                                  index: index,
                                  reqKey: userController.req[index]
                                      ["reqKey"],
                                  userUid: widget.userUid,
                                  userName: widget.userName,
                                  userEmail: widget.userEmail,
                                  userCnic: userController.req[index]
                                      ["userCnic"],
                                  userBloodType: userController.req[index]
                                      ["userBloodType"],
                                  status: userController.req[index]
                                      ["status"],
                                      userContact: userController.req[index]
                                      ["userContact"],
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
  final String usersName;
  final String usersEmail;
  final String appliedAt;
  final String ambuPic;
  final String reqKey;
  final String userCnic;
  final String status;
  final String userBloodType;
  final String userContact;
  final int index;
  final String userUid, userName, userEmail;

  const HorizontalPostCard({
    super.key,
    required this.usersName,
    required this.usersEmail,
    required this.appliedAt,
    required this.ambuPic,
    required this.index,
    required this.reqKey,
    required this.userUid,
    required this.userName,
    required this.userEmail,
    required this.userCnic,
    required this.status,
    required this.userBloodType,
    required this.userContact,
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
            // Ambulance Image on the left side
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
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Ambulance Name
                      Text(
                        usersName,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFE63946)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),

                      Text(
                        usersEmail,
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
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                        status,
                        style:  TextStyle(
                            fontSize: 14, color: status == "pending"? Colors.grey.shade600: status == "Accepted"? Colors.green: Colors.red,fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                          Text(
                            "Applied at:$appliedAt",
                            style:
                                const TextStyle(fontSize: 12, color: Colors.grey),
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
