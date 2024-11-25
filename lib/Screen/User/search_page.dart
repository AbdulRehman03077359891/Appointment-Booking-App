import 'package:appointment_booking_app/Screen/User/ambu_detail_screen.dart';
import 'package:appointment_booking_app/Widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appointment_booking_app/Controllers/user_dashboard_controller.dart';
import 'package:appointment_booking_app/Controllers/user_controller.dart';

class SearchPage extends StatelessWidget {
  final String userUid, userName, userEmail;
  final UserDashboardController userDashboardController =
      Get.put(UserDashboardController());
  final UserController userController = Get.put(UserController());
  final TextEditingController searchController = TextEditingController();
  final RxList<dynamic> suggestions = <dynamic>[].obs; // List to hold suggestions

  SearchPage(
      {super.key,
      required this.userUid,
      required this.userName,
      required this.userEmail});

  @override
  Widget build(BuildContext context) {
    // Add listener to the search controller to update suggestions
    searchController.addListener(() {
      performSearchSuggestions(searchController.text.toLowerCase());
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text(
          "Search Doctors",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            shadows: [BoxShadow(blurRadius: 5, spreadRadius: 10)],
          ),
        ),
        centerTitle: true,
        foregroundColor: const Color(0xFFE63946),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFieldWidget(
              suffixIconColor: const Color(0xFFE63946),
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  // Trigger search functionality
                  performSearch();
                  searchController.clear();
                },
              ),
              labelColor: const Color(0xFFE63946),
              labelText: "Search by Hospital or Doctor Name",
              controller: searchController,
              focusBorderColor: const Color(0xFFE63946),
              errorBorderColor: Colors.red,
            ),
            const SizedBox(height: 10), // Adjust spacing if needed

            // Display suggestions if available
            Obx(() {
              if (suggestions.isNotEmpty) {
                return SizedBox(
                  // Wrap suggestions in a scrollable view
                  height: MediaQuery.of(context).size.height * 0.4, // Set a reasonable height for the suggestions
                  child: ListView.builder(
                    itemCount: suggestions.length,
                    itemBuilder: (context, index) {
                      final Doctor = suggestions[index];
                      return ListTile(
                        title: Text(Doctor['ambuName'] ?? "Unknown"),
                        subtitle: Text("Hospital: ${Doctor['hospital'] ?? 'Unknown'}"),
                        onTap: () {
                          // Handle suggestion tap
                          searchController.text = Doctor['ambuName'] ?? ""; // Fill the text field
                          performSearch(); // Trigger the search
                        },
                      );
                    },
                  ),
                );
              }
              return Container(); // Return empty container if no suggestions
            }),

            const SizedBox(height: 20), // Adjust spacing if needed
            Expanded(
              child: Obx(() {
                if (userDashboardController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Check if selected Doctors list is empty after search
                if (userDashboardController.selectedAmbu.isEmpty && suggestions.isEmpty) {
                  return const Center(child: Text("No results found."));
                }

                // Display the searched Doctors
                return ListView.builder(
                  itemCount: userDashboardController.selectedAmbu.length,
                  itemBuilder: (context, index) {
                    final Doctor = userDashboardController.selectedAmbu[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 8.0),
                      leading: CircleAvatar(
                        radius: 30, // Adjust size as needed
                        backgroundImage: NetworkImage(Doctor['ambuPic'] ?? ""),
                        backgroundColor: Colors.grey[300],
                      ),
                      title: Text(
                        Doctor['ambuName'] ?? "Unknown",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("Hospital: ${Doctor['hospital'] ?? 'Unknown'}"),
                      onTap: () {
                        // Handle tap on the Doctor to navigate to detail screen
                        Get.to(DoctorDetailScreen(
                          ambuName: Doctor['ambuName'],
                          description: Doctor['discription'] ?? "No description",
                          imageUrl: Doctor['ambuPic'] ?? "",
                          docUid: Doctor['ambuUid'] ?? "",
                          userUid: userUid,
                          userName: userName,
                          userEmail: userEmail,
                          ambuKey: Doctor['ambuKey'],
                          ambuContact: Doctor['ambuContact'] ?? "N/A",
                          // ambuPlate: Doctor['ambuPlate'] ?? "N/A",
                          // ambuSize: Doctor['ambuSize'] ?? "N/A",
                          hosName: Doctor['hospital'] ?? "N/A",
                          index: index,
                        ));
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void performSearch() {
    String query = searchController.text.toLowerCase();
    userDashboardController.selectedAmbu.clear();

    // Search for Doctors based on the query
    for (var Doctor in userDashboardController.ambu) {
      if (Doctor['ambuName']?.toLowerCase().contains(query) == true ||
          Doctor['hospital']?.toLowerCase().contains(query) == true) {
        userDashboardController.selectedAmbu.add(Doctor);
      }
    }

    userDashboardController.update(); // Notify listeners
  }

  void performSearchSuggestions(String query) {
    suggestions.clear();

    // Only search for suggestions if the query is not empty
    if (query.isNotEmpty) {
      for (var Doctor in userDashboardController.ambu) {
        if (Doctor['ambuName']?.toLowerCase().contains(query) == true ||
            Doctor['hospital']?.toLowerCase().contains(query) == true) {
          suggestions.add(Doctor);
        }
      }
    }
  }
}
