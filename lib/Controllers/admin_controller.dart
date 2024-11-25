import 'dart:io';

import 'package:appointment_booking_app/Widgets/notification_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AdminController extends GetxController {
  var isLoading = true;
  var hosList = [];
  final pickedImageFile = Rx<File?>(null);
  var allHospitals = [];
  var selectedDishes = [];


// Setting Loading ---------------------------------------------------------
  setLoading(value) {
    isLoading = value;
    update();
  }
// Hospitals Settings -------------------------------------------------------

// Get Data================
  getHospitalsList() async {
    setLoading(true);
    hosList.clear();
    CollectionReference hospitalsInst =
        FirebaseFirestore.instance.collection("Hospitals");
    await hospitalsInst.get().then((QuerySnapshot data) {
      for (var element in data.docs) {
        hosList.add(element.data());
      }
    });
    setLoading(false);
    update();
  }

  getHospitals() async {
    setLoading(true);
    CollectionReference hospitalsInst =
        FirebaseFirestore.instance.collection("Hospitals");
    await hospitalsInst
        .where("status", isEqualTo: true)
        .get()
        .then((QuerySnapshot data) {
      allHospitals = data.docs.map((doc) => doc.data()).toList();
      var newData = {
        "HosKey": "",
        "name": "All",
        "status": true,
        "imageUrl": "https://firebasestorage.googleapis.com/v0/b/humanlibrary-1c35f.appspot.com/o/dish%2Fdata%2Fuser%2F0%2Fcom.example.my_ecom_app%2Fcache%2Fddef191b-ec35-409a-97d0-97f477f3ba23%2F1000340493.jpg?alt=media&token=73b61dd1-a8f8-441f-87cb-24eb4af30c7e",
        "selected" : false,
      };
      allHospitals = allHospitals;
      allHospitals.insert(0, newData);
      getAmbulances(0);
    });
    setLoading(false);
    update();
  }

// Get Dish via Hospitals==========
  getAmbulances(index) async {
    for(int i = 0; i <allHospitals.length; i++){
      allHospitals[i]["selected"] = false;
    }
    allHospitals[index]["selected"] = true;
    if (allHospitals[index]["HosKey"] == "") {
      CollectionReference dishInst =
          FirebaseFirestore.instance.collection("Dishes");
      await dishInst
          .get()
          .then((QuerySnapshot data) {
        var allDishesData = data.docs.map((doc) => doc.data()).toList();

        selectedDishes = allDishesData;
        update();});
      } else {
      CollectionReference dishInst =
          FirebaseFirestore.instance.collection("Dishes");
      await dishInst
          .where("HosKey", isEqualTo: allHospitals[index]["HosKey"])
          .get()
          .then((QuerySnapshot data) {
        var allDishesData = data.docs.map((doc) => doc.data()).toList();

        selectedDishes = allDishesData;
        update();
      });
    }
  }
// Delete Dishes
   deletDish(index) async {
    CollectionReference dishInst = FirebaseFirestore.instance.collection("Dishes");
    await dishInst.doc(selectedDishes[index]["dishKey"]).delete();
    selectedDishes.removeAt(index);
    update();
  }


// Delete Hospitals============
  deletHospital(index) async {
    setLoading(true);
    CollectionReference hospitalsInst =
        FirebaseFirestore.instance.collection("Hospitals");
    await hospitalsInst.doc(hosList[index]["HosKey"]).delete();
    hosList.removeAt(index);
    setLoading(false);
    update();
  }

// Update Hospitals Status=======
  updateHosStatus(index) async {
    setLoading(true);
    CollectionReference hospitalsInst =
        FirebaseFirestore.instance.collection("Hospitals");
    await hospitalsInst
        .doc(hosList[index]["HosKey"])
        .update({"status": !hosList[index]["status"]});
    hosList[index]["status"] = !hosList[index]["status"];
    setLoading(false);
    update();
  }

// Update Hospitals Data=============
  updateHosData(index, name, type,) async {
    setLoading(true);
    if (name.isEmpty) {
      notify("error", "Please enter a valid name");
      return;
    } else if (type.isEmpty) {
      notify("error", "Please enter a valid type");
      return;
    } 
    try {
      updateHospital(index, name, type,);
      update();
      
    } catch (e) {
      setLoading(false);
      notify("error", "ImageStorages ${e.toString()}");
    }
    

    
  }
  updateHospital(index,name, type,) async {
    CollectionReference hospitalsInst =
        FirebaseFirestore.instance.collection("Hospitals");

    var docKey = hosList[index]["HosKey"];
    var doc = await hospitalsInst.doc(docKey).get();

    if (doc.exists) {
      await hospitalsInst.doc(docKey).update({
        "name": name,
        "type": type,
        // "address": address,
      }).then((_) {
        getHospitalsList();
        pickedImageFile.value = null;
        setLoading(false);
        update();
        notify("Success", "Hospitals updated successfully");
      }).catchError((error) {
        setLoading(false);
        notify("error", "Failed to update name: $error");
      });
    } else {
      setLoading(false);
      notify("error", "Document not found");
    }
  }
// Adding New Hospital======
  addHospital(String name, String type,) {
    setLoading(true);
    if (name.isEmpty) {
      notify("error", "Please enter Category's name");
    } else if (type.isEmpty) {
      notify("error", "Please enter Category's type");
    // } else if (address.isEmpty) {
    //   notify("error", "Please enter hospital's address");
    } else {
      fireStoreDBase(name, type);
    }
  }


// Storing New Hospital Data in Firebase Data Base===
  fireStoreDBase(name, type) async {
    CollectionReference hospitalsInst =
        FirebaseFirestore.instance.collection("Hospitals");
    var key = FirebaseDatabase.instance.ref("Hospitals").push().key;
    var hospitalObj = {
      "name": name,
      "type" : type,
      "status": true,
      "HosKey": key,
      "selected": false,  
    };
    await hospitalsInst.doc(key).set(hospitalObj);
    notify("Success", "Hospital added Successfully");
    pickedImageFile.value = null ;
    getHospitalsList();
    setLoading(false);
    update();
  }

// Taking permission to from Mobile ==========================
  Future<bool> requestPermision(Permission permission) async {
    AndroidDeviceInfo build = await DeviceInfoPlugin().androidInfo;
    if (build.version.sdkInt >= 30) {
      var re = await Permission.manageExternalStorage.request();
      if (re.isGranted) {
        return true;
      } else {
        return false;
      }
    } else {
      if (await permission.isGranted) {
        return true;
      } else {
        var result = await permission.request();
        if (result.isGranted) {
          return true;
        } else {
          return false;
        }
      }
    }
  }

// Taking Hospital Picture from Camera/Storage =====================
  Future<void> pickAndCropImage(ImageSource source, context) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        File? croppedFile = await _cropImage(File(pickedFile.path));
        if (croppedFile != null) {
          pickedImageFile.value = croppedFile;
          update();
        }else {
        notify("error", "Image cropping was canceled or failed.");
      }
    } else {
      notify("error", "Image picking was canceled.");
    }
      
    } catch (e) {
      notify("error", "Failed to pick or crop image: $e");
    }
    finally{
      Navigator.pop(context);
    }
  }
// Cropping Image=================================
  Future<File?> _cropImage(File imageFile) async {
    try {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,

        uiSettings: [
          AndroidUiSettings(
            
            toolbarTitle: "Image Cropper",
            toolbarColor: const Color.fromARGB(255, 111, 2, 43),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.ratio3x2,
            lockAspectRatio: true,
            hideBottomControls: true
          ),
          IOSUiSettings(
            title: "Image Cropper",
          ),
        ],
      );
      if (croppedFile != null) {
        return File(croppedFile.path);
      } else {
      notify("error", "No image was cropped.");
      return null;
      }
    } catch (e) {
      notify("error", "Failed to crop image: $e");
    }
    return null;
  }
  
  

}
