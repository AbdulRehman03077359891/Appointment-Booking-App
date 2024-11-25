
import 'package:appointment_booking_app/Controllers/animation_controller.dart';
import 'package:appointment_booking_app/Controllers/business_controller.dart';
import 'package:appointment_booking_app/Screen/Admin/update_ambu.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminHorizontalAmbuCard extends StatelessWidget {
  final String ambuName,
      description,
      ambuContact,
      // ambuPlate,
      // ambuSize,
      imageUrl,
      ambuKey;
  final int index;
  final String userUid, userName, userEmail;

  const AdminHorizontalAmbuCard({
    super.key,
    required this.ambuName,
    required this.description,
    required this.imageUrl,
    required this.index,
    required this.ambuKey,
    required this.userUid,
    required this.userName,
    required this.userEmail,
    required this.ambuContact,
    // required this.ambuPlate,
    // required this.ambuSize,
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
                  animateController.showSecondPage("$index", imageUrl, context),
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
                    imageUrl: imageUrl,
                  ),
                ),
              ),
            ),
            // Text Information on the right side
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: InkWell(
                  onTap: () {
                    // Show a dialog with the full description
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(ambuName),
                          content: Text(description),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Get.to(() => UpdateDoctor(
                                        ambuKey: ambuKey,
                                        userUid: userUid,
                                        userName: userName,
                                        userEmail: userEmail,
                                      ));
                                },
                                child: const Text("Update")),
                            TextButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                            title: const Text(
                                              "Are you sure?",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            actions: [
                                              ElevatedButton(
                                                  style: const ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStatePropertyAll(
                                                              Color(
                                                                  0xFFE63946))),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )),
                                              ElevatedButton(
                                                  style: const ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStatePropertyAll(
                                                              Color(
                                                                  0xFFE63946))),
                                                  onPressed: () {
                                                    final businessController =
                                                        Get.put(
                                                            BusinessController());
                                                    businessController
                                                        .deletAmbu(
                                                            ambuKey,
                                                            userUid,
                                                            userName,
                                                            userEmail);
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    "Delete",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ))
                                            ],
                                          ));
                                },
                                child: const Text("Delete")),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Close"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Ambu Name
                      Text(
                        ambuName,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE63946)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Contact: $ambuContact",
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black54),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      // Text(
                      //   "Plate No: $ambuPlate",
                      //   style: const TextStyle(
                      //       fontSize: 14, color: Colors.black54),
                      //   maxLines: 1,
                      //   overflow: TextOverflow.ellipsis,
                      // ),
                      // const SizedBox(height: 5),
                      // Text(
                      //   "Size: $ambuSize",
                      //   style: const TextStyle(
                      //       fontSize: 14, color: Colors.black54),
                      //   maxLines: 1,
                      //   overflow: TextOverflow.ellipsis,
                      // ),
                      // const SizedBox(height: 5),
                      // Description with tap functionality
                      Text(
                        description,
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black54),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
