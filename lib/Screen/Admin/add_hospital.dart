import 'package:appointment_booking_app/Controllers/admin_controller.dart';
import 'package:appointment_booking_app/Controllers/fire_controller.dart';
import 'package:appointment_booking_app/Widgets/Admin/hospital_type.dart';
import 'package:appointment_booking_app/Widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:appointment_booking_app/Widgets/notification_message.dart';

class AddHospital extends StatefulWidget {
  final String userName, userEmail, profilePicture;
  const AddHospital(
      {super.key,
      required this.userName,
      required this.userEmail,
      required this.profilePicture});

  @override
  State<AddHospital> createState() => _AddHospitalState();
}

class _AddHospitalState extends State<AddHospital> {
  var adminController = Get.put(AdminController());
  final FireController fireController = Get.put(FireController());
  TextEditingController editingNameController = TextEditingController();
  TextEditingController editingTypeController = TextEditingController();
  // TextEditingController editingAddressController = TextEditingController();
  late int selectedIndex;

  TextEditingController hospitalController = TextEditingController();
  final TextEditingController _type = TextEditingController();
  // TextEditingController addressController = TextEditingController();
  String? _selectedType;

  showBottomSheet() {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 60,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () async {
                        if (await adminController
                                .requestPermision(Permission.camera) ==
                            true) {
                          adminController.pickAndCropImage(
                              ImageSource.camera, context);
                          notify("success", "permision for storage is granted");
                        } else {
                          notify(
                              "error", "permision for storage is not granted");
                        }
                      },
                      icon: const CircleAvatar(
                        backgroundColor: Color(0xFFE63946),
                        child: Icon(
                          Icons.camera,
                          color: Colors.white,
                        ),
                      )),
                  IconButton(
                    onPressed: () async {
                      if (await adminController
                              .requestPermision(Permission.storage) ==
                          true) {
                        adminController.pickAndCropImage(
                            ImageSource.gallery, context);
                        notify("success", "permision for storage is granted");
                      } else {
                        notify("error", "permision for storage is not granted");
                      }
                    },
                    icon: const CircleAvatar(
                      backgroundColor: Color(0xFFE63946),
                      child: Icon(
                        Icons.photo,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    getAllHospitals();
  }

  getAllHospitals() {
    adminController.getHospitalsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
              onPressed: () {
                Get.back();
                fireController.setLoading(false);
              },
              icon: const Icon(Icons.arrow_back_ios_new),
            ),
        centerTitle: true,
        title: const Text(
          "Categories",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 245, 222, 224),
        foregroundColor: const Color(0xFFE63946),
      ),
      body: GetBuilder<AdminController>(builder: (adminController) {
        return SizedBox(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFieldWidget(
                    controller: hospitalController,
                    focusBorderColor: const Color(0xFFE63946),
                    hintText: "Enter your Category",
                    errorBorderColor: Colors.red,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: HopitalTypeChoose(
                    controller: _type,
                    selectedType: _selectedType,
                    onChange: (value) {
                      setState(() {
                        _selectedType = value;
                        _type.text = value!;
                      });
                    },
                    width: MediaQuery.of(context).size.width,
                    fillColor: Colors.white,
                    labelColor: const Color(0xFFE63946),
                    focusBorderColor: const Color(0xFFE63946),
                    errorBorderColor: Colors.red,
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: TextFieldWidget(
                //     controller: addressController,
                //     focusBorderColor: const Color(0xFFE63946),
                //     hintText: "Enter hospital's Address",
                //     errorBorderColor: Colors.red,
                //   ),
                // ),
                const SizedBox(
                  height: 10,
                ),
                adminController.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFE63946),
                        ),
                      )
                    : ElevatedButton(
                        style: const ButtonStyle(
                            fixedSize:
                                MaterialStatePropertyAll<Size>(Size(160, 20)),
                            backgroundColor:
                                MaterialStatePropertyAll(Color(0xFFE63946))),
                        onPressed: () {
                          adminController.addHospital(hospitalController.text,
                              _type.text,);
                          hospitalController.clear();
                          _type.clear();
                          // addressController.clear();
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.add_box, color: Colors.white),
                            Text(
                              "Add Category",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        )),
                const SizedBox(
                  height: 10,
                ),
                const Divider(),
                ListView(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      const Center(
                          child: Text(
                        'All Categories',
                        style: TextStyle(
                            color: Color(0xFFE63946),
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      )),
                      DataTable(
                        headingRowColor:
                            const MaterialStatePropertyAll(Color(0xFFE63946)),
                        columnSpacing: 20,
                        columns: const [
                          DataColumn(
                              label: Text('S.NO',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))),
                          DataColumn(
                              label: Text('Category',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))),
                          DataColumn(
                              label: Text('Type',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))),
                          DataColumn(
                              label: Text('Action',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))),
                        ],
                        rows: List.generate(adminController.hosList.length,
                            (index) {
                          return DataRow(cells: [
                            DataCell(Text((index + 1).toString())),
                            DataCell(
                                Text(adminController.hosList[index]["name"])),
                            DataCell(Row(
                              children: [
                                adminController.hosList[index]["status"]
                                    ? GestureDetector(
                                        onTap: () {
                                          adminController
                                              .updateHosStatus(index);
                                        },
                                        child: const Icon(
                                            Icons.check_box_outlined))
                                    : GestureDetector(
                                        onTap: () {
                                          adminController
                                              .updateHosStatus(index);
                                        },
                                        child: const Icon(Icons
                                            .check_box_outline_blank_outlined),
                                      ),
                                Text(adminController.hosList[index]["status"]
                                    .toString()),
                              ],
                            )),
                            DataCell(Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                                title: const Text(
                                                  "Are you sure?",
                                                  style:
                                                      TextStyle(fontSize: 20),
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
                                                            color:
                                                                Colors.white),
                                                      )),
                                                  ElevatedButton(
                                                      style: const ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStatePropertyAll(
                                                                  Color(
                                                                      0xFFE63946))),
                                                      onPressed: () {
                                                        adminController
                                                            .deletHospital(
                                                                index);
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text(
                                                        "Delete",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ))
                                                ],
                                              ));
                                    },
                                    icon: const Icon(Icons.delete)),
                                const SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedIndex = index;
                                        editingNameController.text =
                                            adminController.hosList[index]
                                                    ["name"]
                                                .toString();
                                        editingTypeController.text =
                                            adminController.hosList[index]
                                                    ["type"].toString();
                                                    // editingAddressController.text = adminController.hosList[index]["address"].toString();
                                      });
                                      showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                                title: Column(
                                                  children: [
                                                    HopitalTypeChoose(
                                                      controller:
                                                          editingTypeController,
                                                      selectedType:
                                                          _selectedType,
                                                      onChange: (value) {
                                                        setState(() {
                                                          _selectedType = value;
                                                          editingTypeController
                                                              .text = value!;
                                                        });
                                                      },
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      fillColor:
                                                          const Color.fromARGB(
                                                              31,
                                                              255,
                                                              255,
                                                              255),
                                                      labelColor: const Color(
                                                          0xFFE63946),
                                                      focusBorderColor:
                                                          const Color(
                                                              0xFFE63946),
                                                      errorBorderColor:
                                                          Colors.red,
                                                    ),
                                                    TextField(
                                                      controller:
                                                          editingNameController,
                                                    ),
                                                    // TextField(
                                                    //   controller:
                                                    //       editingAddressController,
                                                    // ),
                                                  ],
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
                                                            color:
                                                                Colors.white),
                                                      )),
                                                  ElevatedButton(
                                                      style: const ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStatePropertyAll(
                                                                  Color(
                                                                      0xFFE63946))),
                                                      onPressed: () {
                                                        adminController.updateHosData(
                                                            index,
                                                            editingNameController
                                                                .text,
                                                            editingTypeController
                                                                .text
                                                                );
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text(
                                                        "Update",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ))
                                                ],
                                              ));
                                    },
                                    icon: const Icon(Icons.edit))
                              ],
                            ))
                          ]);
                        }),
                      ),
                    ])
              ],
            ),
          ),
        );
      }),
    );
  }
}
