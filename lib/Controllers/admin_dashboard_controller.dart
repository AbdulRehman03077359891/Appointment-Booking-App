import 'package:appointment_booking_app/Screen/Doctor/docDashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:appointment_booking_app/Widgets/notification_message.dart';

class AdminDashboardController extends GetxController{
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
  void getDashBoardData() {
    fetchUsers();
    fetchHospitals();
    fetchRequests();
    fetchambu();
  }
    // Function to fetch all users from the 'user' collection
  void fetchUsers() {
    FirebaseFirestore.instance.collection("User").snapshots().listen((QuerySnapshot snapshot) async {
      usersMap.clear();
      userCount.value = 0;

      try {
        for (var doc in snapshot.docs) {
          usersMap.add(doc.data() as Map<String, dynamic>);
          userCount.value = usersMap.length;
        }

      } catch (e) {
        print("Error fetching users: $e");
      }
    });
  }
  
  // Function to fetch all leave requests
  void fetchHospitals() {
    FirebaseFirestore.instance.collection("Hospitals").where("status", isEqualTo: true).snapshots().listen((QuerySnapshot snapshot) {
      hos.clear();
      hosCount.value = 0;

      for (var doc in snapshot.docs) {
        hos.add(doc.data() as Map<String, dynamic>);
        hosCount.value = hos.length;
      }
    });
  }  

  // Function to fetch all leave requests
  void fetchRequests() {
    FirebaseFirestore.instance.collection("Requests").snapshots().listen((QuerySnapshot snapshot) {
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
  // Function to fetch all leave requests
  void fetchambu() {
    FirebaseFirestore.instance.collection("Doctors")
    .snapshots().listen((QuerySnapshot snapshot) {
      ambu.clear();
      ambuCount.value = 0;

      for (var doc in snapshot.docs) {
        ambu.add(doc.data() as Map<String, dynamic>);
        ambuCount.value = ambu.length;
      }
      // Count ambu per hospitals
    for (var hospitals in hos) {
      int count = 0;
      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>?; // Make sure data is not null
        if (data != null && data["HosKey"] != null && hospitals["HosKey"] != null) {
          if (data["HosKey"] == hospitals["HosKey"]) {
            count++;
          }
        }
      }
      hospitals['ambuCount'] = count; // Add post count to each hospitals
    }

      update(); // Notify listeners
    });
  }

  // Get Dishes via Hospitals
  Future<void> getAmbu(int index,) async {

    hos.refresh(); // To trigger UI updates

    if (hos[index]["HosKey"] == "") {
      CollectionReference postInst = FirebaseFirestore.instance.collection("Doctors");
      await postInst.get().then((QuerySnapshot data) {
        var allAmbuData = data.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

        selectedAmbu.value = allAmbuData;
      });
    } else {
      CollectionReference dishInst = FirebaseFirestore.instance.collection("Doctors");
      await dishInst
          .where("HosKey", isEqualTo: hos[index]["HosKey"])
          .get()
          .then((QuerySnapshot data) {
        var allAmbuData = data.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

        selectedAmbu.value = allAmbuData;
      });
    }
  }




}