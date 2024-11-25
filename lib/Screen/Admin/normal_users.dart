import 'package:appointment_booking_app/Controllers/animation_controller.dart';
import 'package:appointment_booking_app/Controllers/fire_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NormUsers extends StatefulWidget {
  final String userName, userEmail, profilePicture;
   NormUsers(
      {super.key,
      required this.userName,
      required this.userEmail,
      required this.profilePicture});

  @override
  State<NormUsers> createState() => _NormUsersState();
}

class _NormUsersState extends State<NormUsers> {
  var controller = Get.put(FireController());
  final AnimateController animateController = Get.put(AnimateController());
  @override
  void initState() {
    super.initState();
    getAllUsers();
  }

  getAllUsers() {
    controller.getAllNormUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Text("NormUsers"),
        backgroundColor:  const Color(0xFFE63946),
        foregroundColor: Colors.white,
      ),
      body: GetBuilder<FireController>(builder: (controller) {
        return Center(
          child: controller.isLoading.value
              ?  const CircularProgressIndicator(
                  color: Color(0xFFE63946),
                )
              : ListView.builder(
                  itemCount: controller.usersListN.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color:  const Color(0xFFE63946),
                      shadowColor:  const Color(0xFFE63946),
                      elevation: 30,
                      child: ListTile(
                        leading: Wrap(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    animateController.showSecondPage(
                                        "image$index",
                                        controller.usersListN[index]
                                            ["imageUrl"],
                                        context);
                                  },
                                  child: Hero(
                                    tag: "image$index",
                                    child: Card(
                                      elevation: 10,
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                              image: controller
                                                              .usersListN[index]
                                                          ["imageUrl"] !=
                                                      null
                                                  ? CachedNetworkImageProvider(
                                                      controller
                                                              .usersListN[index]
                                                          ["imageUrl"],
                                                    )
                                                  :  const AssetImage(
                                                          'assets/images/profilePlaceHolder.jpg')
                                                      as ImageProvider,
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        title: Text(
                          controller.usersListN[index]["userName"],
                          style:  const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          controller.usersListN[index]["userEmail"],
                          style:  const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }),
        );
      }),
    );
  }
}
