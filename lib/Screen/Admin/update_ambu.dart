import 'package:appointment_booking_app/Controllers/business_controller.dart';
// import 'package:appointment_booking_app/Widgets/Admin/doctor_size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:intl/intl.dart';

class UpdateDoctor extends StatefulWidget {
  final String userUid, userName, userEmail;
  final String ambuKey;

  const UpdateDoctor({super.key, required this.ambuKey, required this.userUid, required this.userName, required this.userEmail});

  @override
  State<UpdateDoctor> createState() => _UpdateDoctorState();
}

class _UpdateDoctorState extends State<UpdateDoctor> {
  TextEditingController ambuNameController = TextEditingController();
  TextEditingController ambuContactController = TextEditingController();
  // TextEditingController ambuPlateController = TextEditingController();
  TextEditingController ambuDescriptionController = TextEditingController();
  // final TextEditingController ambuSizeController = TextEditingController();
  var businessController = Get.put(BusinessController());
  DateTime? selectedDate;
  // String? _selectedSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      businessController.getAmbuData(widget.ambuKey).then((_) {
        var ambuData = businessController.selectedAmbu;
        ambuNameController.text = ambuData['ambuName'];
        ambuContactController.text = ambuData['ambuContact'];
        // ambuPlateController.text = ambuData['ambuPlate'];
        // ambuSizeController.text = ambuData['ambuSize'];
        ambuDescriptionController.text = ambuData['discription'];
      });
    });
  }

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: selectedDate ?? DateTime.now(), // Set to current date or selected date
  //     firstDate: DateTime.now(), // Only allow dates from today onwards
  //     lastDate: DateTime(2100), // Set the farthest date allowed
  //   );
  //   if (pickedDate != null && pickedDate != selectedDate) {
  //     setState(() {
  //       selectedDate = pickedDate;
  //       ambuContactController.text = DateFormat('yyyy-MM-dd').format(selectedDate!); // Format date as YYYY-MM-DD
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Update Doctor",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 245, 222, 224),
        foregroundColor: const Color(0xFFE63946),
      ),
      body: GetBuilder<BusinessController>(
        builder: (businessController) {
          return businessController.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          textCapitalization: TextCapitalization.sentences,
                          controller: ambuNameController,
                          decoration: const InputDecoration(labelText: "Doctor Name"),
                        ),
                        TextField(
                          keyboardType: const TextInputType.numberWithOptions(),
                          controller: ambuContactController,
                          decoration: const InputDecoration(labelText: "Doctor Contact"),
                        ),
                        // TextField(
                        //   keyboardType: const TextInputType.numberWithOptions(),
                        //   controller: ambuPlateController,
                        //   decoration: const InputDecoration(labelText: "Doctor Plate Number"),
                        // ),
                        TextField(
                          controller: ambuDescriptionController,
                          decoration: const InputDecoration(labelText: "Description"),
                          maxLines: 4,
                        ),
                        // const SizedBox(height: 5,),
                        // DoctorSizeChoose(
                        //                         controller: ambuSizeController,
                        //                         selectedSize: _selectedSize,
                        //                         onChange: (value) {
                        //                           setState(() {
                        //     _selectedSize = value;
                        //     ambuSizeController.text = value!;
                        //                           });
                        //                         },
                        //                         width: MediaQuery.of(context).size.width,
                        //                         fillColor: Colors.white,
                        //                         labelColor: const Color(0xFFE63946),
                        //                         focusBorderColor: const Color(0xFFE63946),
                        //                         errorBorderColor: Colors.red,
                        //                       ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const ContinuousRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                            ),
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFFE63946),
                          ),
                          onPressed: () {
                            // Call the update method
                            businessController.updateAmbu(
                              widget.ambuKey,
                              ambuNameController.text,
                              ambuDescriptionController.text,
                              ambuContactController.text,
                              widget.userUid,
                              widget.userName,
                              widget.userEmail
                            );
                          },
                          child: const Text(
                            "Update Doctor",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
              );
        },
      ),
    );
  }
}
