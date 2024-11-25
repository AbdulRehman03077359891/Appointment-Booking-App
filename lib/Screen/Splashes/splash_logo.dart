// ignore_for_file: prefer_const_constructors

import 'package:appointment_booking_app/Screen/Admin/admin_dashboard.dart';
import 'package:appointment_booking_app/Screen/Doctor/docDashboard.dart';
import 'package:appointment_booking_app/Screen/Splashes/splash_screen.dart';
import 'package:appointment_booking_app/Screen/User/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashLogo extends StatefulWidget {
  const SplashLogo({super.key});

  @override
  State<SplashLogo> createState() => _SplashLogoState();
}

class _SplashLogoState extends State<SplashLogo> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), (() {
      checkUser();
      //  Get.to(SignInPage());
    }));
  }

  checkUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var userCheck = prefs.getBool("Login") ?? false;
    if (userCheck) {
      var userType = prefs.getString("userType");
      // Get.offAll(HumanLibrary());
      if (userType == "User") {
        Get.offAll(() => UserScreen(
          userUid: prefs.getString("userUid").toString(),
              userName: prefs.getString("userName").toString(),
              userEmail: prefs.getString("userEmail").toString(),
            ));
      } else if (userType == "Admin") {
        Get.offAll(() => AdminDashboard(
              userName: prefs.getString("userName").toString(),
              userEmail: prefs.getString("userEmail").toString(),
              userUid: prefs.getString("userUid").toString(),
            ));
      } else if (userType == "Doctor") {
        Get.offAll(() => DoctorScreen(
              userName: prefs.getString("userName").toString(),
              userEmail: prefs.getString("userEmail").toString(),
              userUid: prefs.getString("userUid").toString(),
            ));
      }
    } else {
      Get.offAll(SplashScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Image.asset('assets/images/Logo.jpg'),
        ),
      ),
    );
  }
}
