import 'package:appointment_booking_app/Controllers/business_controller.dart';
import 'package:appointment_booking_app/Controllers/fire_controller.dart';
// import 'package:appointment_booking_app/Widgets/Admin/Doctor_size.dart';
import 'package:appointment_booking_app/Widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:appointment_booking_app/Widgets/notification_message.dart';

class AddDoctor extends StatefulWidget {
  final String userUid, userName, userEmail, profilePicture;

  const AddDoctor(
      {super.key,
      required this.userUid,
      required this.userName,
      required this.userEmail,
      required this.profilePicture});

  @override
  State<AddDoctor> createState() => _AddDoctorState();
}

class _AddDoctorState extends State<AddDoctor> {
  var businessController = Get.put(BusinessController());
  final FireController fireController = Get.put(FireController());
  TextEditingController ambuNameController = TextEditingController();
  TextEditingController ambuContactController = TextEditingController();
  TextEditingController ambuEmailController = TextEditingController();
  TextEditingController ambuDiscriptionController = TextEditingController();
  final TextEditingController ambuPassController = TextEditingController();
  // String? _selectedSize;
  //Password Settings-------------------------------------------------------------
  var _checkCapital = false;
  var _checkSmall = false;
  var _checkNumbers = false;
  var _checkSpecial = false;

  bool _hidePassword = true;
  var _passwordIcon = FontAwesomeIcons.eyeSlash;

  // is Form Filled---------------------------------------------------------------
  final GlobalKey<FormState> _goodToGo = GlobalKey<FormState>();

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
                        if (await businessController
                                .requestPermision(Permission.camera) ==
                            true) {
                          businessController.pickAndCropImage(
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
                      if (await businessController
                              .requestPermision(Permission.storage) ==
                          true) {
                        businessController.pickAndCropImage(
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
    WidgetsBinding.instance.addPostFrameCallback((value) {
      getAllHospitals();
    });
  }

  getAllHospitals() {
    businessController.getHospitals(widget.userUid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 40,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.back();
            fireController.setLoading(false);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text(
          "Add Dorctors",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFFE63946),
      ),
      body: GetBuilder<BusinessController>(
        builder: (businessController) {
          return businessController.isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                  color: Color(0xFFE63946),
                ))
              : SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            showBottomSheet();
                          },
                          child: businessController.pickedImageFile.value ==
                                  null
                              ? Card(
                                  elevation: 10,
                                  child: Container(
                                    height: 200,
                                    width: 150,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: const DecorationImage(
                                            image: AssetImage(
                                                "assets/images/postPlaceHolder.jpeg"),
                                            fit: BoxFit.cover)),
                                  ))
                              : Card(
                                  elevation: 10,
                                  child: Container(
                                    height: 200,
                                    width: 150,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                            image: FileImage(businessController
                                                .pickedImageFile.value!),
                                            fit: BoxFit.cover)),
                                  )),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFieldWidget(
                          textCapitalization: TextCapitalization.sentences,
                          prefixIcon: const Icon(
                            FontAwesomeIcons.person,
                            color: Color(0xFFE63946),
                          ),
                          lines: 1,
                          width: MediaQuery.of(context).size.width * 0.95,
                          controller: ambuNameController,
                          focusBorderColor: const Color(0xFFE63946),
                          hintText: "Enter your Doctor Name",
                          errorBorderColor: Colors.red,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFieldWidget(
                          keyboardType: const TextInputType.numberWithOptions(),
                          prefixIcon: const Icon(
                            Icons.phone,
                            color: Color(0xFFE63946),
                          ),
                          lines: 1,
                          width: MediaQuery.of(context).size.width * 0.95,
                          controller: ambuContactController,
                          focusBorderColor: const Color(0xFFE63946),
                          hintText: "Enter your Doctor Contact",
                          errorBorderColor: Colors.red,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFieldWidget(
                          prefixIcon: const Icon(
                            Icons.email,
                            color: Color(0xFFE63946),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          lines: 1,
                          width: MediaQuery.of(context).size.width * 0.95,
                          controller: ambuEmailController,
                          focusBorderColor: const Color(0xFFE63946),
                          hintText: "Enter your Doctor Email",
                          errorBorderColor: Colors.red,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Form(
                          key: _goodToGo,
                          child: TextFieldWidget(
                            validate: (value) {
                              for (var i = 0; i < value!.length; i++) {
                                debugPrint(value[i]);
                                if (value.codeUnitAt(i) >= 65 &&
                                    value.codeUnitAt(i) <= 90) {
                                  _checkCapital = true;
                                }
                                if (value.codeUnitAt(i) >= 97 &&
                                    value.codeUnitAt(i) <= 122) {
                                  _checkSmall = true;
                                }
                                if (value.codeUnitAt(i) >= 48 &&
                                    value.codeUnitAt(i) <= 57) {
                                  _checkNumbers = true;
                                }
                                if (value.codeUnitAt(i) >= 33 &&
                                        value.codeUnitAt(i) <= 47 ||
                                    value.codeUnitAt(i) >= 58 &&
                                        value.codeUnitAt(i) <= 64) {
                                  _checkSpecial = true;
                                }
                              }
                              if (value.isEmpty) {
                                return "Password Required";
                              } else if (!_checkCapital) {
                                return "Capital Letter Required";
                              } else if (!_checkSmall) {
                                return "Small Letter Required";
                              } else if (!_checkNumbers) {
                                return "Number Required";
                              } else if (!_checkSpecial) {
                                return "Special Character Required";
                              } else if (value.length < 8) {
                                return "Atleast 8 characters Required";
                              } else {
                                return null;
                              }
                            },
                            suffixIcon: GestureDetector(
                              onTap: () {
                                _hidePassword = !_hidePassword;
                                if (_passwordIcon ==
                                    FontAwesomeIcons.eyeSlash) {
                                  _passwordIcon = FontAwesomeIcons.eye;
                                } else {
                                  _passwordIcon = FontAwesomeIcons.eyeSlash;
                                }
                                setState(() {});
                              },
                              child: Icon(_passwordIcon),
                            ),
                            keyboardType: TextInputType.visiblePassword,
                            hidePassword: _hidePassword,
                            prefixIcon: const Icon(
                              Icons.password,
                              color: Color(0xFFE63946),
                            ),
                            lines: 1,
                            width: MediaQuery.of(context).size.width * 0.95,
                            controller: ambuPassController,
                            focusBorderColor: const Color(0xFFE63946),
                            hintText: "Enter your Doctor Password",
                            errorBorderColor: Colors.red,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(9.5),
                        //   child: DoctorSizeChoose(
                        //                       controller: ambusizeController,
                        //                       selectedSize: _selectedSize,
                        //                       onChange: (value) {
                        //                         setState(() {
                        //   _selectedSize = value;
                        //   ambusizeController.text = value!;
                        //                         });
                        //                       },
                        //                       width: MediaQuery.of(context).size.width,
                        //                       fillColor: Colors.white,
                        //                       labelColor: const Color(0xFFE63946),
                        //                       focusBorderColor: const Color(0xFFE63946),
                        //                       errorBorderColor: Colors.red,
                        //                     ),
                        // ),
                        TextFieldWidget(
                          lines: 8,
                          width: MediaQuery.of(context).size.width * 0.95,
                          controller: ambuDiscriptionController,
                          focusBorderColor: const Color(0xFFE63946),
                          hintText: "Enter your Doctor Discription",
                          errorBorderColor: Colors.red,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 5, right: 5),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Color(0xFFE63946),
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16, right: 8),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15)),
                                  hint: businessController.dropDownValue == ""
                                      ? const Text(
                                          "Select Category",
                                          style: TextStyle(color: Colors.white),
                                        )
                                      : Text(
                                          businessController.dropDownValue
                                              .toString(),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                  isExpanded: true,
                                  dropdownColor: const Color(0xFFE63946),
                                  iconEnabledColor: Colors.white,
                                  // value: businessController.dropDownValue,
                                  items: businessController.allHospitals
                                      .map((items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(
                                        items["name"],
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      businessController
                                          .setDropDownValue(newValue);
                                    });
                                  }),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              maximumSize: const Size.fromWidth(180),
                              shape: const ContinuousRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                ),
                              ),
                              backgroundColor: const Color(0xFFE63946),
                              shadowColor: Colors.black,
                              elevation: 10,
                            ),
                            onPressed: () {
                              if (_goodToGo.currentState!.validate()){
                              businessController.addAmbu(
                                  ambuNameController.text,
                                  ambuContactController.text,
                                  ambuEmailController.text,
                                  ambuPassController.text,
                                  ambuDiscriptionController.text,
                                  widget.userUid,
                                  widget.userName,
                                  widget.userEmail,
                                  widget.profilePicture);
                              ambuNameController.clear();
                              ambuContactController.clear();
                              ambuEmailController.clear();
                              // ambusizeController.clear();
                              ambuDiscriptionController.clear();
                              // _selectedSize = null;
                            };},
                            child: const Row(
                              children: [
                                Icon(Icons.add_box, color: Colors.white),
                                Text(
                                  "Add Doctor",
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            )),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}
