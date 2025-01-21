import 'package:dass/colortheme/theme_maneger.dart';
import 'package:dass/webservices/api.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LeaveRequestPage extends StatefulWidget {
  final String? name;
  final String? email;
  LeaveRequestPage({Key? key, this.name, this.email}) : super(key: key);
  @override
  _LeaveRequestPageState createState() => _LeaveRequestPageState();
}

class _LeaveRequestPageState extends State<LeaveRequestPage> {
  bool _isLoading = false;
  bool _isPressed = false;
  String? leaveType;
  String? leaveDuration;
  DateTime? startDate;
  DateTime? endDate;
  TextEditingController reasonController = TextEditingController();
  TextEditingController daysController = TextEditingController();
  int numberOfDays = 0;
  String? fileUrl;
  String? role;

  void calculateDays() {
    if (leaveDuration == "FirstHalf" || leaveDuration == "SecondHalf") {
      // Half-day leave
      setState(() {
        daysController.text = "0.5";
      });
    } else if (startDate != null && endDate != null) {
      // Full-day leave spanning multiple days
      setState(() {
        int days = endDate!.difference(startDate!).inDays + 1;
        daysController.text = days.toString();
      });
    } else if (startDate != null) {
      // Single full day leave
      setState(() {
        daysController.text = "1";
      });
    } else {
      // No valid dates selected
      daysController.text = "0";
    }
  }

  Future<void> pickDate(BuildContext context, {bool isStartDate = true}) async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    DateTime initialDate = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: themeProvider.themeData.copyWith(
            dialogBackgroundColor:
                themeProvider.themeData.brightness == Brightness.dark
                    ? Colors.grey.shade900
                    : Colors.white,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    themeProvider.themeData.brightness == Brightness.dark
                        ? Colors.white
                        : Colors.indigo.shade900,
              ),
            ),
            colorScheme: themeProvider.themeData.colorScheme.copyWith(
              primary: themeProvider.themeData.brightness == Brightness.dark
                  ? Color(0xFF57C9E7)
                  : Colors.indigo.shade900,
              surface: themeProvider.themeData.brightness == Brightness.dark
                  ? Colors.grey.shade900
                  : Colors.white,
              onSurface: themeProvider.themeData.brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          startDate = pickedDate;
          if (leaveDuration != "Multiple Days") endDate = null;
        } else {
          endDate = pickedDate;
        }
        calculateDays();
      });
    }
  }

  Future<void> pickFile() async {
    try {
      // Select a file using the file picker
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        if (kIsWeb) {
          Uint8List? fileBytes = result.files.first.bytes;
          String fileName = result.files.first.name;

          fileUrl = "$fileName";

          print("File picked (Web): Name: $fileName, URL: $fileUrl");
        } else {
          // For mobile, get the file path
          String? filePath = result.files.single.path;
          if (filePath != null) {
            fileUrl = filePath;
            print("File picked (Mobile): Path: $fileUrl");
          } else {
            print("File path is null. File selection failed.");
          }
        }

        setState(() {}); // Update the UI with the fileUrl
      } else {
        print("No file selected.");
      }
    } catch (e) {
      print("Error picking file: $e");
    }
  }

  Future<void> submitLeaveRequest() async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    if (leaveType == null || leaveDuration == null || startDate == null) {
      Fluttertoast.showToast(
        msg: "Please fill all required fields!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    String durationType;
    switch (leaveDuration) {
      case "FirstHalf":
      case "SecondHalf":
        durationType = "halfday";
        break;
      case "SingleDay":
        durationType = "fullday";
        break;
      case "MultipleDays":
        durationType = "multipledays";
        break;
      default:
        durationType = "unknown";
    }

    Map<String, dynamic> leaveData = {
      "name": widget.name ?? "Unknown",
      "email": widget.email ?? "Unknown",
      "reason": reasonController.text.trim(),
      "leaveType": leaveType,
      "durationType": durationType, // Send the formatted duration
      "days": int.tryParse(daysController.text) ?? 0,
      "startDate": DateFormat('yyyy-MM-dd').format(startDate!),
      "endDate":
          endDate != null ? DateFormat('yyyy-MM-dd').format(endDate!) : null,
      "status": "PENDING",

      "appliedMonth": DateFormat('yyyy-MM').format(DateTime.now()),
    };

    try {
      final response = await ApiService.submitLeaveRequest(
        leaveData: leaveData,
        fileUrl: fileUrl, // Pass the file URL
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          leaveType = null; // Reset dropdown value
          leaveDuration = null; // Reset dropdown value
          startDate = null; // Reset date picker
          endDate = null; // Reset date picker
          role = null; // Reset dropdown value
          reasonController.clear(); // Clear the reason text field
          daysController.clear(); // Clear the number of days field
          fileUrl = null; // Reset the attachment
        });
        Fluttertoast.showToast(
          msg: "Leave request submitted successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor:
              themeProvider.themeData.brightness == Brightness.light
                  ? Colors.indigo.shade900
                  : Color(0xFF57C9E7),
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Failed to submit leave request. Try again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "An error occurred: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.themeData.brightness == Brightness.light
          ? const Color.fromARGB(255, 246, 244, 244)
          : Color(0xFF1C1F26),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: themeProvider.themeData.brightness == Brightness.light
              ? Colors.white
              : Color(0xFF57C9E7),
        ),
        title: Text("Leave Request",
            style: TextStyle(
              color: themeProvider.themeData.brightness == Brightness.light
                  ? Colors.white
                  : Color(0xFF57C9E7),
            )),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: themeProvider.themeData.brightness == Brightness.light
                ? LinearGradient(
                    colors: [Colors.indigo.shade900, Colors.indigo.shade900],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null, // You can use null for no gradient in dark mode
            color: themeProvider.themeData.brightness == Brightness.dark
                ? Color.fromARGB(255, 24, 28, 37)
                : null, // This is used when brightness is dark for a solid color
          ),
        ),
        //iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Leave Type Dropdown
              Text("Leave Type",
                  style: TextStyle(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.indigo.shade900
                              : Colors.white,
                      fontWeight: FontWeight.bold)),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.white
                      : Color.fromARGB(255, 21, 24, 30),
                  // border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: themeProvider.themeData.brightness ==
                              Brightness.light
                          ? Colors.grey.withOpacity(0.5)
                          : const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: DropdownButtonFormField<String>(
                  value: leaveType,
                  hint: Text(
                    "Select Leave Type",
                  ),
                  items: ["Casual", "Sick", "Paternity", "Optional"]
                      .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(
                            type,
                            style: TextStyle(
                              color: themeProvider.themeData.brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          )))
                      .toList(),
                  onChanged: (value) => setState(() => leaveType = value),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Leave Duration Dropdown
              Text("Leave Duration",
                  style: TextStyle(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.indigo.shade900
                              : Colors.white,
                      fontWeight: FontWeight.bold)),
              SizedBox(
                height: 10,
              ),

              Container(
                decoration: BoxDecoration(
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.white
                      : Color.fromARGB(255, 21, 24, 30),
                  // border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: themeProvider.themeData.brightness ==
                              Brightness.light
                          ? Colors.grey.withOpacity(0.5)
                          : const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: DropdownButtonFormField<String>(
                  value: leaveDuration,
                  hint: Text("Select Leave Duration"),
                  items:
                      ["FirstHalf", "SecondHalf", "SingleDay", "MultipleDays"]
                          .map((duration) => DropdownMenuItem(
                              value: duration,
                              child: Text(
                                duration,
                                style: TextStyle(
                                  color: themeProvider.themeData.brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              )))
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      leaveDuration = value;
                      if (value != "Multiple Days") {
                        endDate = null;
                      }
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Start Date Picker
              if (leaveDuration != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Start Date",
                        style: TextStyle(
                            color: themeProvider.themeData.brightness ==
                                    Brightness.light
                                ? Colors.indigo.shade900
                                : Colors.white,
                            fontWeight: FontWeight.bold)),
                    GestureDetector(
                      onTap: () => pickDate(context),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          startDate == null
                              ? "Select Start Date"
                              : DateFormat.yMMMd().format(startDate!),
                          style: TextStyle(
                            color: themeProvider.themeData.brightness ==
                                    Brightness.light
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 16),
              // End Date Picker for Multiple Days
              if (leaveDuration == "MultipleDays")
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("End Date",
                        style: TextStyle(
                            color: themeProvider.themeData.brightness ==
                                    Brightness.light
                                ? Colors.indigo.shade900
                                : Colors.black,
                            fontWeight: FontWeight.bold)),
                    GestureDetector(
                      onTap: () => pickDate(context, isStartDate: false),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          endDate == null
                              ? "Select End Date"
                              : DateFormat.yMMMd().format(endDate!),
                          style: TextStyle(
                            color: themeProvider.themeData.brightness ==
                                    Brightness.light
                                ? Colors.indigo.shade900
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 16),
              // Reason Text Field
              Text("Reason for Leave",
                  style: TextStyle(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.indigo.shade900
                              : Colors.white,
                      fontWeight: FontWeight.bold)),
              SizedBox(
                height: 3,
              ),
              Container(
                decoration: BoxDecoration(
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.white
                      : Color.fromARGB(255, 21, 24, 30),
                  // border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.grey.withOpacity(0.5)
                              : Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    controller: reasonController,
                    maxLines: 3,
                    style: TextStyle(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                    ),
                    decoration: InputDecoration(
                        hintText: "Enter reason for leave",
                        hintStyle: TextStyle(
                          color: themeProvider.themeData.brightness ==
                                  Brightness.light
                              ? Colors.grey[400]
                              : Colors.grey[600],
                        ),
                        border: InputBorder.none),
                  ),
                ),
              ),
              // SizedBox(height: 16),
              // Text("Role",
              //     style: TextStyle(
              //         color:
              //             themeProvider.themeData.brightness == Brightness.light
              //                 ? Colors.indigo.shade900
              //                 : Colors.white,
              //         fontWeight: FontWeight.bold)),
              // SizedBox(
              //   height: 10,
              // ),

              // Container(
              //   decoration: BoxDecoration(
              //     color: themeProvider.themeData.brightness == Brightness.light
              //         ? Colors.white
              //         : Color.fromARGB(255, 21, 24, 30),
              //     // border: Border.all(color: Colors.grey.shade400),
              //     borderRadius: BorderRadius.circular(8),
              //     boxShadow: [
              //       BoxShadow(
              //         color: themeProvider.themeData.brightness ==
              //                 Brightness.light
              //             ? Colors.grey.withOpacity(0.5)
              //             : const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
              //         spreadRadius: 2,
              //         blurRadius: 5,
              //         offset: Offset(0, 3),
              //       ),
              //     ],
              //   ),
              //   child: DropdownButtonFormField<String>(
              //     value: role,
              //     hint: Text("Select Role"),
              //     items: ["USER", "SUBADMIN"]
              //         .map((type) => DropdownMenuItem(
              //             value: type,
              //             child: Text(
              //               type,
              //               style: TextStyle(
              //                 color: themeProvider.themeData.brightness ==
              //                         Brightness.light
              //                     ? Colors.black
              //                     : Colors.white,
              //               ),
              //             )))
              //         .toList(),
              //     onChanged: (value) => setState(() => role = value),
              //     decoration: InputDecoration(
              //       border: InputBorder.none,
              //       contentPadding: EdgeInsets.symmetric(horizontal: 12),
              //     ),
              //   ),
              // ),
              SizedBox(height: 16),
              Text("Number of Days",
                  style: TextStyle(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.indigo.shade900
                              : Colors.white,
                      fontWeight: FontWeight.bold)),
              SizedBox(
                height: 3,
              ),
              Container(
                decoration: BoxDecoration(
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.white
                      : Color.fromARGB(255, 21, 24, 30),
                  // border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: themeProvider.themeData.brightness ==
                              Brightness.light
                          ? Colors.grey.withOpacity(0.5)
                          : const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    style: TextStyle(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                    ),
                    controller: daysController,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: "Auto-calculated days",
                      hintStyle: TextStyle(
                        color: themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Colors.black
                            : Colors.white,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Attachment
              Text("Attachment (Optional)",
                  style: TextStyle(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.indigo.shade900
                              : Colors.white,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: pickFile,
                icon: Icon(
                  Icons.attach_file,
                  color: Colors.white,
                ),
                label: Text(
                  "Upload File",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.indigo.shade900
                            : Color(0xFF57C9E7)),
              ),
              if (fileUrl != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text("File URL: $fileUrl",
                      style: TextStyle(color: Colors.blue)),
                ),

              SizedBox(height: 24),
              Center(
                child: GestureDetector(
                  onTapDown: (_) {
                    setState(() {
                      _isPressed = true; // Trigger animation on light press
                    });
                  },
                  onTapUp: (_) {
                    setState(() {
                      _isPressed = false; // Revert animation when released
                    });
                  },
                  onTapCancel: () {
                    setState(() {
                      _isPressed =
                          false; // Revert animation if press is canceled
                    });
                  },
                  child: AnimatedScale(
                    scale: _isPressed
                        ? 0.95
                        : 1.0, // Zoom in on press, zoom out when released
                    duration: Duration(milliseconds: 100),
                    child: ElevatedButton(
                      onPressed: submitLeaveRequest,
                      child: Text(
                        "Submit",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Colors.indigo.shade900
                            : Color(0xFF57C9E7),
                        padding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                    ),
                  ),
                ),
              ),
              if (_isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: CircularProgressIndicator(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.indigo.shade900
                              : Color(0xFF57C9E7),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
