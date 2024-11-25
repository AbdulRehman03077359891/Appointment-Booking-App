import 'package:appointment_booking_app/Screen/Doctor/docDashboard.dart';
import 'package:appointment_booking_app/Widgets/notification_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class DocDashboardController extends GetxController{
  RxBool isLoading = false.obs;
  var usersMap = <Map<String, dynamic>>[].obs;
  var userCount = 0.obs;
  var hos = <Map<String, dynamic>>[].obs;
  var hosCount = 0.obs;
  var req = <Map<String, dynamic>>[].obs;
  var reqCount = 0.obs;
  var ambu = <Map<String, dynamic>>[].obs;
  var ambuCount = 0.obs;
  RxList<Map<String, dynamic>> selectedAmbu = <Map<String, dynamic>>[].obs;

  setLoading(val){
    isLoading.value = val;
  }

    // Function to get dashboard data
  void getDashBoardData(userUid) {
    fetchRequests(userUid);
  }
    // Function to fetch all users from the 'user' collection
  // Function to fetch all leave requests
  void fetchRequests(userUid) {
    FirebaseFirestore.instance.collection("Requests").where("docUid", isEqualTo: userUid).snapshots().listen((QuerySnapshot snapshot) {
      req.clear();
      reqCount.value = 0;

      for (var doc in snapshot.docs) {
        req.add(doc.data() as Map<String, dynamic>);
        reqCount.value = req.length;
      }
    });
  }
  Future<void> updateRequest(String reqKey, String status, String userUid, String userName, String userEmail) async {
    try {
      await FirebaseFirestore.instance
          .collection('Requests')
          .doc(reqKey)
          .update({"status" : status});
      notify('Success','Request updated successfully!');
      Get.off(() => DoctorScreen(userUid: userUid, userName: userName, userEmail: userEmail));
    } catch (e) {
      notify('error','Error updating request: $e');
    }
  }
  }