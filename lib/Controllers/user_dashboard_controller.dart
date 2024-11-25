import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UserDashboardController extends GetxController{
  RxBool isLoading = false.obs;
  var usersMap = <Map<String, dynamic>>[].obs;
  var userCount = 0.obs;
  var hos = <Map<String, dynamic>>[].obs;
  var hosCount = 0.obs;
  var ambu = <Map<String, dynamic>>[].obs;
  var ambuCount = 0.obs;
  RxList<Map<String, dynamic>> selectedAmbu = <Map<String, dynamic>>[].obs;

  setLoading(val){
    isLoading.value = val;
  }


    // Function to get dashboard data
  void getDashBoardData() {
    fetchHospitals();
    fetchAmbu();
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
  void fetchAmbu() {
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
        if (data != null && data['HosKey'] != null && hospitals['HosKey'] != null) {
          if (data['HosKey'] == hospitals['HosKey']) {
            count++;
          }
        }
      }
      hospitals['ambuCount'] = count; // Add ambu count to each Hospitals
    }

      update(); // Notify listeners
    });
  }

  // Get Dishes via Hospitals
  Future<void> getAmbu(int index,) async {

    hos.refresh(); // To trigger UI updates

    if (hos[index]["HosKey"] == "") {
      CollectionReference ambuInst = FirebaseFirestore.instance.collection("Doctors");
      await ambuInst.get().then((QuerySnapshot data) {
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