
import 'package:appointment_booking_app/Controllers/animation_controller.dart';
import 'package:appointment_booking_app/Screen/User/ambu_detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserHorizontalAmbuCard extends StatelessWidget {
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

  const UserHorizontalAmbuCard({
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
     required this.hosName, required this.docUid,
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
                  
                   Get.to(() => DoctorDetailScreen(
          ambuName: ambuName,
          ambuContact: ambuContact,
          // ambuPlate: ambuPlate,
          // ambuSize: ambuSize,
          description: description,
          imageUrl: imageUrl,
          userUid: userUid,
          userName: userName,
          userEmail: userEmail,
          ambuKey: ambuKey,
          hosName: hosName,
          docUid: docUid,
          index: index,
        ));
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
                      const SizedBox(height: 5),
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
