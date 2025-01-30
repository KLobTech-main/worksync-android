import 'dart:convert';

import 'package:dass/colortheme/theme_maneger.dart';
import 'package:dass/modal/leavesummarymodel.dart';
import 'package:dass/modal/timelogmodelnew.dart';
import 'package:dass/screens/attendance_details_model.dart';
import 'package:dass/screens/attendance_request_model.dart';
import 'package:dass/screens/attendance_summary_model.dart';
import 'package:dass/screens/daily_log_model.dart';
import 'package:dass/ui/auth/login.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../modal/alluser.dart';
import '../modal/assetsmodel.dart';
import '../modal/docs.dart';
import '../modal/getallmeeeting.dart';
import '../modal/getuserbyemailmodel.dart';
import '../modal/jobhistorymodel.dart';
import '../modal/meetingsmodel.dart';
import '../modal/payslipmodel.dart';

class ApiService {
  static const String _baseUrl =
      "https://work-sync-gbf0h9d5amcxhwcr.canadacentral-01.azurewebsites.net/api";
  static String? _authToken;

  ///Login api
  static Future<http.Response?> loginUser(String email, String password) async {
    final String url = "$_baseUrl/users/login";
    print("CURL Command:");
    print(
        "curl -X POST $url -H 'Content-Type: application/json' -d '${jsonEncode({
          "email": email,
          "password": password
        })}'");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        _authToken = responseBody["token"];
        if (_authToken != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('authToken', _authToken!);
          print("Login successful. Token saved: $_authToken");
          await loadAuthToken();
        } else {
          print("Error: Token is null after login response.");
        }
        // final prefs = await SharedPreferences.getInstance();
        // await prefs.setString('authToken', _authToken!);
        //
        // print("Login successful. Token saved: $_authToken");
      } else {
        print("Login failed: ${response.statusCode} - ${response.body}");
      }

      return response;
    } catch (e) {
      print("Error during login: $e");
      return null; // Return null on error
    }
  }

  /// Example Function to Make Authenticated Requests
  static Future<void> loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString('authToken');
    print("Loaded token from SharedPreferences: $_authToken");
  }

  /// Example Function to Make Authenticated Requests
  static Future<http.Response> getAuthenticatedData(String endpoint) async {
    if (_authToken == null) {
      await loadAuthToken();
      if (_authToken == null) {
        throw Exception("No auth token available. Please log in first.");
      }
    }
    final String url = "$_baseUrl/$endpoint";
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authToken!,
        },
      );

      print("Authenticated Request Status: ${response.statusCode}");
      print("Response Body: ${response.body}");
      return response;
    } catch (e) {
      print("Error during authenticated request: $e");
      throw Exception("Failed to fetch data: $e");
    }
  }

  ///SignUp
  static Future<http.Response> registerUser(
      Map<String, dynamic> userData) async {
    final url = Uri.parse(
        'https://work-sync-gbf0h9d5amcxhwcr.canadacentral-01.azurewebsites.net/api/users/register');
    final headers = {"Content-Type": "application/json"};
    final body = json.encode(userData);

    print("CURL Command:");
    print("curl -X POST $url -H 'Content-Type: application/json' -d '$body'");

    try {
      final response = await http.post(url, headers: headers, body: body);

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      return response;
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }

  /// GET: Fetch tasks assigned by a specific user(Get Assigned Task)
  // GET: Fetch tasks assigned to a specific user
  static Future<List<dynamic>> getAssignedTasks(
      BuildContext context, String assignedBy) async {
    final String url = "$_baseUrl/tasks/get-assigned-tasks?email=$assignedBy";
    print("CURL Command:");
    print("curl -X GET $url -H 'Content-Type: application/json'");

    try {
      final response = await ApiService.makeRequest(
        context: context,
        url: url,
        method: 'GET',
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authToken!,
        },
      );

      print("Response Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else if (response.statusCode == 404) {
        Fluttertoast.showToast(
          msg: "No tasks found.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        throw Exception("No tasks found (404).");
      } else if (response.statusCode == 401) {
        Fluttertoast.showToast(
          msg: "Token expired. Please log in again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        throw Exception("Unauthorized (401): Token expired.");
      } else {
        throw Exception("Failed to fetch tasks: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error occurred: $e");
    }
  }

// GET: Fetch tasks given by a specific user
  static Future<List<dynamic>> getGivenTasks(
      BuildContext context, String assignedTo) async {
    final String url = "$_baseUrl/tasks/get-given-tasks?assignedTo=$assignedTo";
    print("CURL Command:");
    print("curl -X GET $url -H 'Content-Type: application/json'");

    try {
      final response = await ApiService.makeRequest(
        context: context,
        url: url,
        method: 'GET',
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authToken!,
        },
      );

      print("Response Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else if (response.statusCode == 404) {
        Fluttertoast.showToast(
          msg: "No tasks found.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        throw Exception("No tasks found (404).");
      } else if (response.statusCode == 401) {
        Fluttertoast.showToast(
          msg: "Token expired. Please log in again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        throw Exception("Unauthorized (401): Token expired.");
      } else {
        throw Exception("Failed to fetch tasks: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error occurred: $e");
    }
  }

  /// PATCH: Update Task Status
  static Future<void> updateTaskStatus(
      String taskId, String status, String email) async {
    final String url =
        "$_baseUrl/tasks/status?taskId=$taskId&status=$status&email=$email";
    print("CURL Command:");
    print("curl -X PATCH $url -H 'Content-Type: application/json' -d");

    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authToken!,
        },
      );

      if (response.statusCode == 200) {
        print("Task status updated successfully.");
      } else {
        throw Exception("Failed to update task status: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error occurred while updating task status: $e");
    }
  }

  ///post Create Meeting
  Future<http.Response> createMeeting(String email, BuildContext context,
      Map<String, dynamic> meetingDetails) async {
    final url = Uri.parse(
        'https://work-sync-gbf0h9d5amcxhwcr.canadacentral-01.azurewebsites.net/api/meetings?email=$email');

    // Check if token exists
    if (_authToken == null || _authToken!.isEmpty) {
      throw Exception("Authorization token is missing");
    }

    try {
      final response = await ApiService.makeRequest(
        context: context,
        url: url.toString(),
        method: 'POST',
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authToken!,
        },
        body: jsonEncode(meetingDetails),
      );

      return response;
    } catch (e) {
      throw Exception("Failed to create meeting: $e");
    }
  }

  /// GET: get Meetings
  static Future<List<dynamic>> getMeetingByEmail(
      BuildContext context, String email) async {
    final String url = "$_baseUrl/users/get/user?email=$email";
    try {
      final response = await ApiService.makeRequest(
        context: context,
        url: url,
        method: 'GET',
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authToken!,
        },
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        throw Exception("Failed to fetch tasks: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error occurred: $e");
    }
  }

  ///fetch Participants
  static Future<List<String>> fetchParticipants(BuildContext context) async {
    final String url = '$_baseUrl/admin/api/get-all-users';
    print("CURL Command:");
    print("curl -X GET $url -H 'Content-Type: application/json' -d");
    try {
      final response = await ApiService.makeRequest(
        context: context,
        url: url,
        method: 'GET',
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authToken!,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((json) => AllUsers.fromJson(json).name ?? '')
            .where((name) => name.isNotEmpty)
            .toList();
      } else {
        throw Exception("Failed to fetch participants: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error occurred while fetching participants: $e");
    }
  }

  /// POST: Create a new ticket
  static Future<http.Response> createTicket(
      BuildContext context, Map<String, dynamic> ticketData) async {
    final String url = "$_baseUrl/tickets";
    final headers = {"Content-Type": "application/json"};
    final body = json.encode(ticketData);

    print("CURL Command:");
    print("curl -X POST $url -H 'Content-Type: application/json' -d '$body'");
    // final String url = "$_baseUrl/tickets";
    try {
      final response = await ApiService.makeRequest(
        context: context,
        url: url,
        method: 'POST',
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authToken!,
        },
        body: jsonEncode(ticketData),
      );
      return response;
    } catch (e) {
      throw Exception("Failed to create task: $e");
    }
  }

  /// GET: get all tickets
  static Future<List<dynamic>> getTickets(
      String email, BuildContext context) async {
    final String url = "$_baseUrl/tickets/$email";
    try {
      final response = await ApiService.makeRequest(
        context: context,
        url: url,
        method: 'GET',
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authToken!,
        },
      );
      print(
          "curl -X GET $url -H 'Content-Type: application/json' -H 'Authorization: $_authToken'");
      print("\n--- Response for GET ---");
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        // Parse the JSON response into a list
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        throw Exception("Failed to fetch tasks: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error occurred: $e");
    }
  }

  static Future<List<dynamic>> getAllUsers(
      String email, BuildContext context) async {
    final String url = "$_baseUrl/users/get-all-users?email=$email";

    print("CURL Command:");
    print(
        "curl -X GET $url -H 'Content-Type: application/json' -H 'Authorization: $_authToken'");

    try {
      final response = await ApiService.makeRequest(
        context: context,
        url: url,
        method: 'GET',
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authToken!,
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else if (response.statusCode == 401) {
        print("Invalid token: Authorization failed");
        throw Exception("Invalid token: Please log in again.");
      } else if (response.statusCode == 404) {
        print("No tickets found for the user: $email");
        return [];
      } else {
        throw Exception("Failed to fetch users: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error occurred: $e");
    }
  }

  static Future<List<AllUsers>> getAllUsersEmergencyContact(
      BuildContext context, String email) async {
    final String url = "$_baseUrl/users/get-all-users?email=$email";

    print("CURL Command:");
    print(
        "curl -X GET $url -H 'Content-Type: application/json' -H 'Authorization: $_authToken'");

    try {
      final response = await ApiService.makeRequest(
        context: context,
        url: url,
        method: 'GET',
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authToken!,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);

        // Map the list into List<AllUsers>
        return responseData
            .map((userJson) =>
                AllUsers.fromJson(userJson as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception("Failed to fetch users: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error occurred: $e");
    }
  }

  static Future<List<dynamic>> getAllUsersName(
      String email, BuildContext context) async {
    final String url = "$_baseUrl/users/get-all-users?email=$email";

    print("CURL Command:");
    print(
        "curl -X GET $url -H 'Content-Type: application/json' -H 'Authorization: $_authToken'");

    try {
      final response = await ApiService.makeRequest(
        context: context,
        url: url,
        method: 'GET',
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authToken!,
        },
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        print("Response Body: $responseBody");

        // Ensure the response is a list of users
        if (responseBody is List) {
          return responseBody.map((user) {
            return {
              "name":
                  user["name"] ?? "Unknown", // Provide fallback for null name
              "email":
                  user["email"] ?? "Unknown", // Provide fallback for null email
            };
          }).toList();
        } else {
          print("Unexpected response structure: $responseBody");
          return [];
        }
      } else {
        print("Failed to fetch users: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error occurred: $e");
      return []; // Return an empty list on error
    }
  }

  static Future<void> createTask(
    BuildContext context, {
    required String? name,
    required String? assignedBy,
    required String assignedTo,
    required String title,
    required String description,
    required String deadLine,
    required String status,
    required String createdAt,
  }) async {
    final String url = "$_baseUrl/tasks/create-task";

    print("CURL Command:");
    print(
        "curl -X POST $url -H 'Content-Type: application/json' -H 'Authorization: $_authToken' -d "
        "'{\"assignedBy\":\"$assignedBy\", \"assignedTo\":\"$assignedTo\", \"title\":\"$title\", \"description\":\"$description\", \"deadLine\":\"$deadLine\", \"status\":\"$status\"}'");

    try {
      final response = await ApiService.makeRequest(
        context: context,
        url: url,
        method: 'POST',
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authToken!,
        },
        body: jsonEncode({
          "name": name,
          "assignedBy": assignedBy,
          "assignedTo": assignedTo,
          "title": title,
          "description": description,
          "deadLine": deadLine,
          "status": status,
          "createdAt": createdAt,
        }),
      );

      if (response.statusCode == 200) {
        print("Task created successfully.");
      } else {
        throw Exception(
            "Failed to create task: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      throw Exception("Error occurred: $e");
    }
  }

  static Future<List<MeetingModal>> getMeetings(
      String participantEmail, BuildContext context) async {
    final String url =
        "$_baseUrl/meetings/participant?participant=$participantEmail";

    try {
      final response = await ApiService.makeRequest(
        context: context,
        url: url,
        method: 'GET',
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authToken!,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseBody = jsonDecode(response.body);
        return responseBody.map((json) => MeetingModal.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        // Handle 404: No meetings scheduled
        print("No meetings scheduled for the participant: $participantEmail");
        return []; // Return an empty list
      } else {
        throw Exception("Failed to fetch meetings: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error occurred: $e");
    }
  }

  static Future<bool> postEmergencyContact(
      String email, EmergencyContact contact, BuildContext context) async {
    final String url = "$_baseUrl/users/emergency/contact?email=$email";

    try {
      // Prepare headers
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": _authToken!,
      };

      // Prepare body
      String body = jsonEncode(
          contact.toJson()); // Using toJson from EmergencyContactDetails

      // Make the POST request

      final response = await ApiService.makeRequest(
        context: context,
        url: url,
        method: 'POST',
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        return true; // Success
      } else {
        throw Exception(
            "Failed to post emergency contact: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error occurred while posting emergency contact: $e");
    }
  }

  static Future<bool> deleteEmergencyContact(
      String email, String name, BuildContext context) async {
    final String url =
        "$_baseUrl/users/emergency/contact?email=$email&contactName=$name";

    try {
      print("CURL Command:");
      print(
          "curl -X DELETE '$url' -H 'Content-Type: application/json' -H 'Authorization: $_authToken'");

      final response = await ApiService.makeRequest(
        context: context,
        url: url,
        method: 'DELETE',
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authToken!,
        },
      );

      if (response.statusCode == 200) {
        return true; // Success
      } else {
        throw Exception(
            "Failed to delete emergency contact: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error occurred while deleting emergency contact: $e");
    }
  }

  static Future<void> submitBankDetails(
    BuildContext context, {
    required String email,
    required Map<String, String> bankDetails,
  }) async {
    final String url = "$_baseUrl/users/bankDetails?email=$email";

    print("CURL Command:");
    print(
        "curl -X POST $url -H 'Content-Type: application/json' -H 'Authorization: $_authToken' -d '${jsonEncode(bankDetails)}'");

    try {
      final response = await ApiService.makeRequest(
        context: context,
        url: url,
        method: 'POST',
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authToken!,
        },
        body: jsonEncode(bankDetails),
      );

      if (response.statusCode == 200) {
        print("Bank details submitted successfully!");
      } else {
        throw Exception(
            "Failed to submit bank details: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error occurred: $e");
    }
  }

  static Future<BankDetails?> getUserBankDetailsByEmail(
      String email, BuildContext context) async {
    final String url = "$_baseUrl/users/get-all-users?email=$email";

    try {
      final response = await ApiService.makeRequest(
        context: context,
        url: url,
        method: 'GET',
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authToken!,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data =
            jsonDecode(response.body); // Decoding as List

        // Find the user with the matching email
        final user = data.firstWhere(
          (user) => user['email'] == email,
          orElse: () => null,
        );

        if (user != null) {
          if (user['bankDetails'] != null) {
            return BankDetails.fromJson(user['bankDetails']);
          } else {
            return null;
          }
        }
        return null; // If no user is found
      } else {
        throw Exception("Failed to fetch user details: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error occurred: $e");
    }
  }

  static Future<void> updateAddress(String email, String currentAddress,
      String permanentAddress, BuildContext context) async {
    final String url = "$_baseUrl/users/address?email=$email";
    final payload = {
      "currentAddress": currentAddress,
      "permanentAddress": permanentAddress,
    };

    try {
      // Generate and print cURL command for debugging
      final curl = 'curl -X POST "$url" -H "Content-Type: application/json" '
          '-H "Authorization: $_authToken" -d \'${jsonEncode(payload)}\'';
      print("\n--- cURL Command for POST ---\n$curl\n");

      final response = await ApiService.makeRequest(
        context: context,
        url: url,
        method: 'POST',
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authToken!,
        },
        body: jsonEncode(payload),
      );

      // Log full response
      print("\n--- Response for POST ---");
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode != 200) {
        throw Exception(
            "Failed to update address. Status: ${response.statusCode}\nResponse: ${response.body}");
      }
    } catch (e) {
      print("\nError during POST: $e");
      throw Exception("Error occurred: $e");
    }
  }

  // Get User By Email API
  static Future<GetUserByEmailModel?> getUserByEmail(
      String email, BuildContext context) async {
    final String url = "$_baseUrl/users/get/user?email=$email";

    try {
      // Generate and print cURL command for debugging
      final curl = 'curl -X GET "$url" -H "Content-Type: application/json" '
          '-H "Authorization: $_authToken"';
      print("\n--- cURL Command for GET ---\n$curl\n");

      final response = await ApiService.makeRequest(
        context: context,
        url: url,
        method: 'GET',
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authToken!,
        },
      );

      // Log full response
      print("\n--- Response for GET ---");
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return GetUserByEmailModel.fromJson(jsonData);
      } else {
        print(
            "Failed to fetch user. Status: ${response.statusCode}\nResponse: ${response.body}");
        return null;
      }
    } catch (e) {
      print("\nError during GET: $e");
      return null;
    }
  }

  static Future<http.Response> submitLeaveRequest({
    required Map<String, dynamic> leaveData,
    String? fileUrl, // Path of the file to be uploaded
  }) async {
    final url = Uri.parse('$_baseUrl/leaves');

    try {
      // Create a multipart request
      final request = http.MultipartRequest('POST', url)
        ..headers.addAll({
          'Authorization': _authToken!,
          // 'Content-Type' is automatically handled by MultipartRequest
        })
        ..fields['leave'] = json.encode(leaveData); // Add JSON data as a field

      // Add the file to the request if fileUrl is provided
      if (fileUrl != null && fileUrl.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath('file', fileUrl));
      }

      // Debug: Print request details
      print("Request URL: $url");
      print("Headers: ${request.headers}");
      print("Fields: ${request.fields}");
      print("File: ${fileUrl != null ? fileUrl : 'No file attached'}");

      // Send the request
      final streamedResponse = await request.send();

      // Convert streamed response to http.Response for consistent handling
      final response = await http.Response.fromStream(streamedResponse);

      // Debug: Print response details
      print("Response: ${response.statusCode}, Body: ${response.body}");

      return response;
    } catch (e) {
      print("Error submitting leave request: $e");
      rethrow;
    }
  }

  static Future<List<GetAllMeeting>> getAllMeetings(
      BuildContext context) async {
    try {
      final response = await ApiService.makeRequest(
        context: context,
        url: '$_baseUrl/meetings',
        method: 'GET',
        headers: {
          'Authorization': _authToken!, // Add your authorization token here
          'Content-Type': 'application/json',
        },
      );

      print('Request URL: ${response.request?.url}');
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((meeting) => GetAllMeeting.fromJson(meeting)).toList();
      } else {
        print('Error: ${response.statusCode}');
        print('Error Message: ${response.body}');
        throw Exception('Failed to load meetings');
      }
    } catch (e) {
      // Print the exception in case of an error
      print('Exception occurred: $e');
      throw Exception('Failed to load meetings: $e');
    }
  }

  static Future<List<DocumentsModel>> fetchDocuments(
      String email, BuildContext context) async {
    try {
      final response = await ApiService.makeRequest(
        context: context,
        url: '$_baseUrl/documents/?email=$email',
        method: 'GET',
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authToken!,
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((doc) => DocumentsModel.fromJson(doc)).toList();
      } else {
        throw Exception('Failed to fetch documents');
      }
    } catch (e) {
      print("Error fetching documents: $e");
      throw Exception('Failed to fetch documents');
    }
  }

  // Upload document (For both web and mobile platforms)
  static Future<bool> uploadDocument(String email, String filePath,
      String fileName, Uint8List? fileBytes) async {
    try {
      var dioInstance = dio.Dio();
      dioInstance.options.headers = {
        'Authorization': _authToken!,
        'Content-Type': 'multipart/form-data',
      };

      dio.FormData formData;

      if (kIsWeb) {
        // For Web: Use bytes
        formData = dio.FormData.fromMap({
          "file": dio.MultipartFile.fromBytes(fileBytes!, filename: fileName),
        });
      } else {
        // For Mobile: Use file path
        formData = dio.FormData.fromMap({
          "file":
              await dio.MultipartFile.fromFile(filePath, filename: fileName),
        });
      }

      final response = await dioInstance.post(
        '$_baseUrl/documents/upload?email=$email',
        data: formData,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Error: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error during document upload: $e');
      return false;
    }
  }

  Future<List<PaySlipModel>> getPaySlips(
      String email, BuildContext context) async {
    final url =
        'https://work-sync-gbf0h9d5amcxhwcr.canadacentral-01.azurewebsites.net/api/payslip/?email=$email';

    try {
      final response = await ApiService.makeRequest(
        context: context,
        url: url,
        method: 'GET',
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authToken!,
        },
      );
      print('Request URL: ${response.request?.url}');
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => PaySlipModel.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        // Handle the 204 No Content response
        print('No payslips found. Status code: 404');
        return []; // Return an empty list if no content
      } else {
        print('Error: ${response.statusCode}');
        print('Error Message: ${response.body}');
        throw Exception('Failed to load payslips');
      }
    } catch (e) {
      print('Exception occurred: $e');
      throw Exception('Failed to load payslips: $e');
    }
  }

  Future<JobHistoryModel?> getJobHistory(
      String email, BuildContext context) async {
    final url =
        'https://work-sync-gbf0h9d5amcxhwcr.canadacentral-01.azurewebsites.net/api/jobHistory/?email=$email';

    try {
      final response = await ApiService.makeRequest(
        context: context,
        url: url,
        method: 'GET',
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authToken!,
        },
      );

      print('Request URL: ${response.request?.url}');
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          print('Empty response body');
          return null; // or handle appropriately
        }
        final dynamic data = json.decode(response.body);

        if (data is Map<String, dynamic>) {
          return JobHistoryModel.fromJson(data);
        } else if (data is List && data.isEmpty) {
          print('Empty list received');
          return null;
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        print('Error: ${response.statusCode}');
        print('Error Message: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception occurred: $e');
      throw Exception('Failed to load job history: $e');
    }
  }

  Future<List<AssetsModel>> fetchAssets(
      String email, BuildContext context) async {
    final url = '$_baseUrl/assets/?email=$email';

    try {
      final response = await ApiService.makeRequest(
        context: context,
        url: url,
        method: 'GET',
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authToken!,
        },
      );

      print('Request URL: ${response.request?.url}');
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Assuming the assets list is under the "data" key
        final List<dynamic> assetsData = data['data'];

        if (assetsData.isEmpty) {
          return [];
        }

        return assetsData.map((json) => AssetsModel.fromJson(json)).toList();
      } else {
        print('Error: ${response.statusCode}');
        print('Error Message: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Exception occurred: $e');
      throw Exception('Failed to load assets: $e');
    }
  }

  /// Punch In
  static Future<http.Response> punchIn(Map<String, dynamic> punchIn,
      String punchInTime, String email, BuildContext context) async {
    // Use dynamic email and punch-in time in the URL
    String url =
        "$_baseUrl/attendance/punch-in?punchInTime=$punchInTime&email=$email";

    // Add required fields to the payload
    punchIn['email'] = email;
    punchIn['punchintime'] = punchInTime;

    final headers = {
      "Content-Type": "application/json",
      "Authorization": _authToken!, // Ensure the token is set
    };

    final body = json.encode(punchIn);

    // Debugging: Print the CURL equivalent for troubleshooting
    print("CURL Command:");
    print(
        "curl -X POST $url -H 'Content-Type: application/json' -H 'Authorization: $_authToken' -d '$body'");

    try {
      final response = await ApiService.makeRequest(
        context: context,
        url: url,
        method: 'POST',
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authToken!,
        },
        body: body,
      );

      // Log the response
      print("Response: ${response.statusCode}, Body: ${response.body}");
      return response;
    } catch (e) {
      print("Error in punch-in API: $e");
      throw Exception("Failed to punch in: $e");
    }
  }

  ///Tea Start Time
  /// Tea Start Time API
  static Future<http.Response> teaStart(
      Map<String, dynamic> punchIn,
      String email,
      String punchInId,
      String teaStartTime,
      BuildContext context) async {
    // Ensure the base URL is correctly defined
    String url =
        "$_baseUrl/attendance/tea-start?teaStartTime=$teaStartTime&email=$email&id=$punchInId";

    if (_authToken == null || _authToken!.isEmpty) {
      throw Exception("Authorization token is missing!");
    }

    final headers = {
      "Content-Type": "application/json",
      "Authorization": _authToken!,
    };

    try {
      final response = await ApiService.makeRequest(
        context: context,
        url: url,
        method: 'POST',
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authToken!,
        },
        body: json.encode(punchIn),
      );

      print("API Response: ${response.statusCode}");
      print("Response Body: ${response.body}");

      return response;
    } catch (e) {
      print("API Error: $e");
      throw Exception("Failed to start tea break: $e");
    }
  }

  ///Tea End Time
  static Future<http.Response> teaEnd(
      Map<String, dynamic> punchIn,
      String email,
      String punchInId,
      String teaEndTime,
      BuildContext context) async {
    String url =
        "$_baseUrl/attendance/tea-end?teaEndTime=$teaEndTime&email=$email&id=$punchInId";

    if (_authToken == null || _authToken!.isEmpty) {
      throw Exception("Authorization token is missing!");
    }
    final headers = {
      "Content-Type": "application/json",
      "Authorization": _authToken!, // Ensure token is set
    };

    try {
      final response = await ApiService.makeRequest(
        context: context,
        url: url,
        method: 'POST',
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authToken!,
        },
        body: json.encode(punchIn),
      );

      print("Response: ${response.statusCode}, Body: ${response.body}");
      return response;
    } catch (e) {
      print("API Error: $e");
      throw Exception("Failed to end tea break: $e");
    }
  }

  ///Start Lunch Break
  static Future<http.Response> startLunchBreak(
      Map<String, dynamic> punchIn,
      String email,
      String punchInId,
      String lunchStartTime,
      BuildContext context) async {
    String url =
        "$_baseUrl/attendance/lunch-start?lunchStartTime=$lunchStartTime&email=$email&id=$punchInId";

    if (_authToken == null || _authToken!.isEmpty) {
      throw Exception("Authorization token is missing!");
    }
    final headers = {
      "Content-Type": "application/json",
      "Authorization": _authToken!, // Ensure token is set
    };
    print("token:$_authToken");

    // Print cURL command
    print("cURL Command:\n");
    StringBuffer curlCommand = StringBuffer("curl -X POST '$url'");

    // Add headers to the cURL command
    headers.forEach((key, value) {
      curlCommand.write(" -H '$key: $value'");
    });

    // Add the body of the request as a JSON string
    curlCommand.write(" -d '${json.encode(punchIn)}'");

    // Print the final cURL command
    print(curlCommand);

    try {
      final response = await ApiService.makeRequest(
        context: context,
        url: url,
        method: 'POST',
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authToken!,
        },
        body: json.encode(punchIn),
      );

      print("Response: ${response.statusCode}, Body: ${response.body}");
      return response;
    } catch (e) {
      throw Exception("Failed to start lunch break: $e");
    }
  }

  static void printCurl(
      String url, Map<String, String> headers, Map<String, dynamic> body) {
    String curlCommand = "curl -X POST '$url' \\\n";
    headers.forEach((key, value) {
      curlCommand += "  -H '$key: $value' \\\n";
    });
    curlCommand += "  -d '${json.encode(body)}'";
    print("cURL Command:\n$curlCommand");
  }

  ///Start Lunch Break
  static Future<http.Response> endLunchBreak(
      Map<String, dynamic> punchIn,
      String email,
      String punchInId,
      String lunchEndTime,
      BuildContext context) async {
    String url =
        "$_baseUrl/attendance/lunch-end?lunchEndTime=$lunchEndTime&email=$email&id=$punchInId";

    if (_authToken == null || _authToken!.isEmpty) {
      throw Exception("Authorization token is missing!");
    }
    final headers = {
      "Content-Type": "application/json",
      "Authorization": _authToken!, // Ensure token is set
    };
    print("token:$_authToken");

    try {
      final response = await ApiService.makeRequest(
        context: context,
        url: url,
        method: 'GET',
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authToken!,
        },
        body: json.encode(punchIn),
      );

      print("Response: ${response.statusCode}, Body: ${response.body}");
      return response;
    } catch (e) {
      throw Exception("Failed to end lunch break: $e");
    }
  }

  ///Punch OUt
  static Future<http.Response> punchOut(
      Map<String, dynamic> punchOutData,
      String email,
      String punchInId,
      String name,
      String punchOutTime,
      BuildContext context) async {
    String url =
        "$_baseUrl/attendance?punchOutTime=$punchOutTime&email=$email&name=$name&id=$punchInId";

    // Ensure email is added to the payload
    punchOutData.addAll({
      "punchOutTime": DateTime.now().toIso8601String(),
      "email": email,
      "name": name,
      "id": punchInId,
    });

    final headers = {
      "Content-Type": "application/json",
      "Authorization": _authToken!,
    };

    print("token:$_authToken");

    if (_authToken == null || _authToken!.isEmpty) {
      throw Exception("Authorization token is missing!");
    }

    // Debugging: Print the CURL equivalent for troubleshooting
    print(
        "curl -X POST '$url' -H 'Content-Type: application/json' -H 'Authorization: $_authToken' -d '${json.encode(punchOutData)}'");
    try {
      final response = await ApiService.makeRequest(
        context: context,
        url: url,
        method: 'POST',
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authToken!,
        },
        body: json.encode(punchOutData),
      );
      print("Response Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      return response;
    } catch (e) {
      print("Error in punchOut API: $e");
      throw Exception("Failed to punch out: $e");
    }
  }

  ///TimeLog
  /// TimeLog
  static Future<TimeLogModelNew?> getTimeLog(
      String email, String year, String month, BuildContext context) async {
    final String url = "$_baseUrl/attendance/monthly/$email/$year/$month";

    try {
      // Construct the curl command
      final curlCommand = """
    curl -X GET "$url" \\
    -H "Content-Type: application/json" \\
    -H "Authorization: $_authToken"
    """;

      // Print the curl command
      print("CURL Command: $curlCommand");

      final response = await ApiService.makeRequest(
        context: context,
        url: url,
        method: 'GET',
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authToken!,
        },
      );

      print("Token: $_authToken");
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final responseJson = jsonDecode(response.body);

        // Extracting data from 'body' key
        if (responseJson is Map && responseJson.containsKey('body')) {
          final bodyData = responseJson['body'];
          if (bodyData is Map<String, dynamic>) {
            // Parse body data into TimeLogModel
            return TimeLogModelNew.fromJson(bodyData);
          }
        }
      } else {
        print('Failed to fetch data. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
    return null;
  }

//Attendance Request
  static Future<List<AttendanceRequestModel>> getAttendanceRequest(String email,
      String startDate, String endDate, BuildContext context) async {
    final String url =
        "$_baseUrl/attendance/range?email=$email&startDate=$startDate&endDate=$endDate";
    try {
      final response = await ApiService.makeRequest(
        context: context,
        url: url,
        method: 'GET',
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authToken!,
        },
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List)
            .map((item) => AttendanceRequestModel.fromJson(item))
            .toList();
      } else {
        throw Exception(
            "Failed to fetch data. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching attendance data: $e");
    }
  }

  ///Attendance summary
  static Future<List<AttendanceSummaryModel>> getAttendanceSummary(
      String email, BuildContext context) async {
    final url = "$_baseUrl/attendance/$email?email=$email";

    try {
      // Construct the curl command
      final curlCommand = """
    curl -X GET "$url" \\
    -H "Content-Type: application/json" \\
    -H "Authorization: $_authToken"
    """;

      // Print the curl command
      print("CURL Command: $curlCommand");

      final response = await ApiService.makeRequest(
        context: context,
        url: url,
        method: 'GET',
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authToken!,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        // Ensure 'data' is non-null and is a list
        final attendanceList = (jsonData['data'] as List<dynamic>? ?? []);
        return attendanceList
            .map((item) => AttendanceSummaryModel.fromJson(item))
            .toList();
      } else {
        throw Exception("Failed to fetch data: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error during API call: $e");
    }
  }

  ///Daily Log
  static Future<DailyLogModel?> getDailyLog(
      String email, String date, BuildContext context) async {
    final String url = "$_baseUrl/attendance/day?email=$email&date=$date";
    try {
      final response = await ApiService.makeRequest(
        context: context,
        url: url,
        method: 'GET',
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authToken!,
        },
      );
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          return DailyLogModel.fromJson(data[0]);
        } else {
          print("No logs available");
          return null;
        }
      } else {
        print('Failed to fetch data. Status Code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching data: $e');
      return null;
    }
  }

  ///AttendanceDetails

  static Future<List<AttendanceDetailsModel>?> getAttendanceDetails(
      BuildContext context, String email, String date) async {
    final String url = "$_baseUrl/attendance/day?email=$email&date=$date";
    try {
      final response = await ApiService.makeRequest(
        context: context,
        url: url,
        method: 'GET',
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authToken!,
        },
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => AttendanceDetailsModel.fromJson(e)).toList();
      } else {
        print('Failed to fetch data. Status Code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  ///leavestatus

  static Future<List<Map<String, dynamic>>> getLeaveStatus(
      String email, String date, BuildContext context) async {
    final String url = "$_baseUrl/leaves/$email?email=$email";

    try {
      final response = await ApiService.makeRequest(
        context: context,
        url: url,
        method: 'GET',
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authToken!,
        },
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      _printCurlCommand(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => Map<String, dynamic>.from(e)).toList();
      } else if (response.statusCode == 404) {
        final responseBody = jsonDecode(response.body);
        final message = responseBody['message'] ?? "No leave requests found.";
        print("404 Not Found: $message");

        Fluttertoast.showToast(
          msg: "No leave requests found for the email: $email",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        return [];
      } else {
        print("Failed to fetch data. Status code: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching leave data: $e");
      return [];
    }
  }

  static void _printCurlCommand(String url) {
    print('Equivalent curl command:');
    print('curl -X GET "$url" \\');
    print('     -H "Content-Type: application/json" \\');
    print('     -H "Authorization: $_authToken"');
  }

  ///leavesummary

  static Future<Map<String, dynamic>?> getLeaveSummary(
      String email, BuildContext context) async {
    final String url = "$_baseUrl/users/get/user?email=$email";
    try {
      final response = await ApiService.makeRequest(
        context: context,
        url: url,
        method: 'GET',
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authToken!,
        },
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 404) {
        print("404 Not Found: No leave requests found for the given email.");
        Fluttertoast.showToast(
          msg: "No leave requests found for the email: $email",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return null;
      } else {
        debugPrint('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching leave summary: $e');
      return null;
    }
  }

  Future<List<dynamic>> fetchNotifications(
      String recipientEmail, BuildContext context) async {
    final url =
        Uri.parse('$_baseUrl/notification?recipientEmail=$recipientEmail');

    final response = await ApiService.makeRequest(
      context: context,
      url: url.toString(),
      method: 'GET',
      headers: {
        "Content-Type": "application/json",
        "Authorization": _authToken!,
      },
    );

    print("GET Response Code: ${response.statusCode}");
    print("GET Response Body: ${response.body}");
    if (response.statusCode == 200) {
      print("GET API Response: ${response.body}");
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to fetch notifications: ${response.statusCode}");
    }
  }

  Future<void> markNotificationAsRead(String notificationId,
      String recipientEmail, BuildContext context) async {
    final url = Uri.parse(
        '$_baseUrl/notification/$notificationId/read?recipientEmail=$recipientEmail');

    final response = await ApiService.makeRequest(
      context: context,
      url: url.toString(),
      method: 'PATCH',
      headers: {
        "Content-Type": "application/json",
        "Authorization": _authToken!,
      },
    );
    print("PATCH Response Code: ${response.statusCode}");
    print("PATCH Response Body: ${response.body}");
    if (response.statusCode == 200) {
      print("PATCH API Response: ${response.body}");
    } else {
      throw Exception(
          "Failed to mark notification as read: ${response.statusCode}");
    }
  }

  Future<bool> resetPassword(
      String email, String newPassword, BuildContext context) async {
    final url = Uri.parse('$_baseUrl/users/reset/password');
    try {
      print('API URL: $url'); // Print the API URL
      print('Request Body: ${jsonEncode({
            'email': email,
            'newPassword': newPassword
          })}'); // Print the request body

      final response = await ApiService.makeRequest(
        context: context,
        url: url.toString(),
        method: 'GET',
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authToken!,
        },
        body: jsonEncode({
          'email': email,
          'newPassword': newPassword,
        }),
      );

      // Print the response details
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to reset password: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<List<dynamic>> fetchAnnouncements(
      String userEmail, BuildContext context) async {
    final String endpoint =
        '$_baseUrl/notification/type?recipientType=USER&userEmail=$userEmail';

    try {
      final response = await ApiService.makeRequest(
        context: context,
        url: endpoint,
        method: 'GET',
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authToken!,
        },
      );

      print('Response Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Parse as List
      } else {
        throw Exception('Failed to fetch announcements');
      }
    } catch (error) {
      print('Error fetching announcements: $error');
      rethrow;
    }
  }

  Future<http.Response> submitFeedback(
    BuildContext context, {
    required String email,
    required String description,
  }) async {
    final url = Uri.parse('$_baseUrl/feedback');

    final response = await ApiService.makeRequest(
      context: context,
      url: url.toString(),
      method: 'GET',
      headers: {
        "Content-Type": "application/json",
        "Authorization": _authToken!,
      },
      body: jsonEncode({
        'email': email,
        'description': description,
      }),
    );

    return response;
  }

  static Future<http.Response> editTicket(
    BuildContext context, {
    required String ticketId,
    required String title,
    required String description,
    required String priority,
  }) async {
    final uri = Uri.parse(
        '$_baseUrl/tickets/edit?ticketId=$ticketId&title=${Uri.encodeComponent(title)}&description=${Uri.encodeComponent(description)}&priority=$priority');

    final response = await ApiService.makeRequest(
      context: context,
      url: uri.toString(),
      method: 'PATCH',
      headers: {
        "Content-Type": "application/json",
        "Authorization": _authToken!,
      },
    );
    return response;
  }

  // API for rescheduling a meeting
  static Future<void> rescheduleMeeting(
      BuildContext context, String meetingId, String newTime) async {
    final String url = "$_baseUrl/meetings/reschedule";
    print("CURL Command:");
    print(
        "curl -X PUT $url -H 'Content-Type: application/json' -d '{\"meetingId\": \"$meetingId\", \"newTime\": \"$newTime\"}'");

    try {
      final response = await ApiService.makeRequest(
        context: context,
        url: url,
        method: 'PUT',
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authToken!,
        },
        body: jsonEncode({
          "meetingId": meetingId,
          "newTime": newTime,
        }),
      );

      if (response.statusCode == 200) {
        print("Meeting rescheduled successfully.");
      } else {
        throw Exception("Failed to reschedule meeting: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error occurred while rescheduling meeting: $e");
    }
  }

// API for updating meeting status
  static Future<void> updateMeetingStatus(
      BuildContext context, String meetingId, String status) async {
    final String url = "$_baseUrl/meetings/status";
    print("CURL Command:");
    print(
        "curl -X PATCH $url -H 'Content-Type: application/json' -d '{\"meetingId\": \"$meetingId\", \"status\": \"$status\"}'");
    try {
      final response = await ApiService.makeRequest(
        context: context,
        url: url,
        method: 'PATCH',
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authToken!,
        },
        body: jsonEncode({
          "meetingId": meetingId,
          "status": status,
        }),
      );
      print("Response Status Code: ${response.statusCode}");
      print("Executing CURL Command:");
      print("""
curl -X PATCH $url \\
  -H 'Content-Type: application/json' \\
  -H 'Authorization: $_authToken' \\
  -d '${jsonEncode({"meetingId": meetingId, "status": status})}'
""");
      if (response.statusCode == 200) {
        print("Meeting status updated successfully.");
      } else {
        throw Exception(
            "Failed to update meeting status: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error occurred while updating meeting status: $e");
    }
  }

// API for editing meeting details
  static Future<http.Response> editMeeting(
    BuildContext context, {
    required String meetingId,
    required String meetingTitle,
    required String description,
    required String meetingMode,
    required String duration,
    required String date,
    required String meetingLink,
  }) async {
    final String url =
        "$_baseUrl/meetings/edit?meetingId=$meetingId&meetingTitle=$meetingTitle&description=$description&meetingMode=$meetingMode&duration=$duration&date=$date&meetingLink=$meetingLink";
    print("CURL Command:");
    print("curl -X PATCH $url -H 'Content-Type: application/json'");

    try {
      final response = await ApiService.makeRequest(
        context: context,
        url: url,
        method: 'PATCH',
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authToken!,
        },
      );
      if (response.statusCode == 200) {
        print("Meeting details updated successfully.");
        return response; // return the response here
      } else if (response.statusCode == 401) {
        print("Invalid token: Authorization failed");
        throw Exception("Invalid token: Please log in again.");
      } else if (response.statusCode == 404) {
        print("Meeting Not Found");
        return response;
      } else {
        throw Exception(
            "Failed to update meeting details: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error occurred while editing meeting details: $e");
    }
  }

  static Future<bool> forgotPassword(String email, BuildContext context) async {
    final url = Uri.parse("$_baseUrl/users/forgot-password?email=$email");

    try {
      print("Request URL: $url");
      print("cURL Command: curl -X POST '$url'");

      final response = await ApiService.makeRequest(
        context: context,
        url: url.toString(),
        method: 'POST',
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authToken!,
        },
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return true; // Success
      } else {
        print("Error: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Exception: $e");
      return false;
    }
  }

  static Future<bool> resetForgotPassword(String email, String otp,
      String newPassword, BuildContext context) async {
    final url = Uri.parse("$_baseUrl/users/reset-password");
    final body = {
      "email": email,
      "otp": otp,
      "newPassword": newPassword,
    };

    try {
      final response = await ApiService.makeRequest(
        context: context,
        url: url.toString(),
        method: 'POST',
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authToken!,
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Error: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Exception: $e");
      return false;
    }
  }

  static Future<Map<String, dynamic>?> getAttendanceStatus(
      String email, BuildContext context) async {
    final String url = "$_baseUrl/attendance/status?email=$email";
    try {
      final response = await ApiService.makeRequest(
        context: context,
        url: url,
        method: 'GET',
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authToken!,
        },
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return {"statusCode": 200, "body": json.decode(response.body)};
      } else if (response.statusCode == 404) {
        return {"statusCode": 404, "body": null};
      } else {
        debugPrint('Error: ${response.statusCode}');
        return {"statusCode": response.statusCode, "body": null};
      }
    } catch (e) {
      debugPrint('Error fetching attendance status: $e');
      return null;
    }
  }

  static Future<void> editTask(String taskId, String assignedTo, String title,
      String description, String deadline, BuildContext context) async {
    final url = Uri.parse(
        '$_baseUrl/tasks/edit?taskId=$taskId&assignedTo=$assignedTo&title=$title&description=$description&deadLine=$deadline');

    // Generating curl command for debugging
    String curlCommand =
        '''curl -X PATCH "$url" -H "accept: /" -H "Authorization: $_authToken"''';
    print("Generated curl command:\n$curlCommand");

    final response = await ApiService.makeRequest(
      context: context,
      url: url.toString(),
      method: 'PATCH',
      headers: {
        "Content-Type": "application/json",
        "Authorization": _authToken!,
      },
    );

    // Printing the response code and body
    print('Response code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to edit task: ${response.body}');
    }
  }

  static Future<List<Map<String, String>>> fetchAllUsers(
      String email, BuildContext context) async {
    final url =
        Uri.parse('$_baseUrl/users/get-all-users-name-email?email=$email');
    try {
      final response = await ApiService.makeRequest(
        context: context,
        url: url.toString(),
        method: 'GET',
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authToken!,
        },
      );

      // Print the status code and body to debug
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data
            .map((user) => {
                  'name': user['name']?.toString() ?? '',
                  'email': user['email']?.toString() ?? '',
                })
            .toList();
      } else {
        throw Exception('Failed to fetch users');
      }
    } catch (e) {
      print('Error fetching users: $e');
      rethrow;
    }
  }

  static Future<void> extendDeadline(String taskId, String newDeadline,
      String reason, BuildContext context) async {
    final url = Uri.parse(
        '$_baseUrl/tasks/deadline-extension/request?taskId=$taskId&newDeadline=$newDeadline&reason=$reason');

    // Generating curl command for debugging
    String curlCommand =
        '''curl -X POST "$url" -H "accept: /" -H "Authorization: $_authToken"''';
    print("Generated curl command:\n$curlCommand");

    final response = await ApiService.makeRequest(
      context: context,
      url: url.toString(),
      method: 'POST',
      headers: {
        "Content-Type": "application/json",
        "Authorization": _authToken!,
      },
    );

    // Printing the response code and body
    print('Response code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to extend deadline: ${response.body}');
    }
  }

  static Future<LeaveSummaryModel?> getLeave(
      String email, BuildContext context) async {
    final String url = "$_baseUrl/users/get/user?email=$email";

    try {
      // Generate and print cURL command for debugging
      final curl = 'curl -X GET "$url" -H "Content-Type: application/json" '
          '-H "Authorization: $_authToken"';
      print("\n--- cURL Command for GET ---\n$curl\n");

      final response = await ApiService.makeRequest(
        context: context,
        url: url,
        method: 'GET',
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authToken!,
        },
      );

      // Log full response
      print("\n--- Response for GET ---");
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return LeaveSummaryModel.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        print("404 Not Found: No leave requests found for the given email.");
        Fluttertoast.showToast(
          msg: "No leave requests found for the email: $email",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return null;
      } else {
        print(
            "Failed to fetch user. Status: ${response.statusCode}\nResponse: ${response.body}");
        return null;
      }
    } catch (e) {
      print("\nError during GET: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>> fetchAttendanceStatus(
      String email, BuildContext context) async {
    final url = Uri.parse('$_baseUrl/attendance/status?email=$email');
    try {
      final response = await ApiService.makeRequest(
        context: context,
        url: url.toString(),
        method: 'GET',
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authToken!,
        },
      );
      print("\n--- Response for GET ---");
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'status': 'success', 'message': data['message']};
      } else if (response.statusCode == 404) {
        final data = json.decode(response.body);
        return {'status': 'error', 'message': data['message']};
      } else {
        return {'status': 'error', 'message': 'Unexpected error occurred'};
      }
    } catch (e) {
      return {'status': 'error', 'message': 'Failed to connect to server'};
    }
  }

  static Future<http.Response> makeRequest({
    required BuildContext context,
    required String url,
    required String method,
    Map<String, String>? headers,
    Object? body,
  }) async {
    try {
      final uri = Uri.parse(url);
      late http.Response response;

      // Make the API request based on the method (GET, POST, etc.)
      if (method == 'GET') {
        response = await http.get(uri, headers: headers);
      } else if (method == 'POST') {
        response = await http.post(uri, headers: headers, body: body);
      } else if (method == 'PUT') {
        response = await http.put(uri, headers: headers, body: body);
      } else if (method == 'DELETE') {
        response = await http.delete(uri, headers: headers);
      } else if (method == 'PATCH') {
        response = await http.patch(uri, headers: headers);
      }

      // If the response status is 401, show the logout dialog
      if (response.statusCode == 401) {
        _handleTokenExpired(context);
      }

      return response; // Return the response to the caller
    } catch (e) {
      // Handle connection or server errors
      return http.Response(
          jsonEncode({'error': 'Network error occurred'}), 500);
    }
  }

  // Function to handle token expiration
  static void _handleTokenExpired(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent user from dismissing the dialog
      builder: (context) {
        return AlertDialog(
          title: Text('Session Expired'),
          titleTextStyle: TextStyle(
            color: themeProvider.themeData.brightness == Brightness.light
                ? Colors.black
                : Colors.white,
            fontSize: 24,
          ),
          content: Text(
            'Your session has expired. Please log in again.',
            style: TextStyle(
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.black
                    : Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Navigate to login screen and clear navigation stack
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LogIn()),
                  (route) => false,
                );
              },
              child: Text(
                'Log Out',
                style: TextStyle(
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.indigo.shade900
                      : const Color(0xFF57C9E7),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
  static Future<bool> deleteLeaveRequest(
      BuildContext context, String id, String userEmail, String reason) async {
    final String url =
        'https://work-sync-gbf0h9d5amcxhwcr.canadacentral-01.azurewebsites.net/api/leaves/request';

    try {
      // Make the API call using your ApiService
      final response = await ApiService.makeRequest(
        context: context,
        url: url,
        method: 'POST',
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authToken!,
        },
        body: jsonEncode({
          "id": id,
          "userEmail": userEmail,
          "reasonForCancellation": reason,
        }),
      );

      // Print the cURL equivalent for debugging
      print('''
cURL Command:
curl -X POST $url \
-H "Content-Type: application/json" \
-H "Authorization: $_authToken" \
-d '${jsonEncode({
        "id": id,
        "userEmail": userEmail,
        "reasonForCancellation": reason,
      })}'
''');

      // Print the HTTP response status code and body
      print("Response Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        print("Leave Cancel request Send successfully.");
        return true;
      } else {
        print("Failed to delete leave request. Status: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      // Print the error for debugging
      print("Error deleting leave request: $e");
      return false;
    }
  }

}
