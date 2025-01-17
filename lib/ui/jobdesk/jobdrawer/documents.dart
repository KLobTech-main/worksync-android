import 'package:dass/colortheme/theme_maneger.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart'; // For checking platform (web vs mobile)
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Import fluttertoast package
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';

import '../../../modal/docs.dart';
import '../../../webservices/api.dart';

class DocumentPage extends StatefulWidget {
  final String? email;
  DocumentPage({required this.email});

  @override
  State<DocumentPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  late String email;
  List<DocumentsModel> documents = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    email = widget.email!;
    fetchDocuments();
  }

  Future<void> fetchDocuments() async {
    setState(() => isLoading = true);
    try {
      documents = await ApiService.fetchDocuments(email, context);
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to fetch documents.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
    setState(() => isLoading = false);
  }

  Future<void> uploadDocument() async {
    final themeProvider = Provider.of<ThemeProvider>(context);
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      String fileName = result.files.single.name;

      if (kIsWeb) {
        Uint8List? fileBytes = result.files.single.bytes;
        if (fileBytes != null) {
          bool success =
              await ApiService.uploadDocument(email, '', fileName, fileBytes);
          success
              ? Fluttertoast.showToast(
                  msg: "Document uploaded successfully.",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor:
                      themeProvider.themeData.brightness == Brightness.light
                          ? Colors.indigo.shade900
                          : Color(0xFF57C9E7),
                  textColor: Colors.white,
                  fontSize: 16.0,
                )
              : Fluttertoast.showToast(
                  msg: "Failed to upload document.",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
          fetchDocuments();
        }
      } else {
        String filePath = result.files.single.path!;
        bool success =
            await ApiService.uploadDocument(email, filePath, fileName, null);
        success
            ? Fluttertoast.showToast(
                msg: "Document uploaded successfully.",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                backgroundColor:
                    themeProvider.themeData.brightness == Brightness.light
                        ? Colors.indigo.shade900
                        : Color(0xFF57C9E7),
                textColor: Colors.white,
                fontSize: 16.0,
              )
            : Fluttertoast.showToast(
                msg: "Failed to upload document.",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0,
              );
        fetchDocuments();
      }
    } else {
      print("No file selected.");
    }
  }

  Widget buildDocumentItem(DocumentsModel doc) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: Icon(
          Icons.insert_drive_file,
          color: themeProvider.themeData.brightness == Brightness.light
              ? Colors.blue
              : Color(0xFF57C9E7),
          size: 40,
        ),
        title: Text(
          doc.fileName ?? "Unknown Document",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "${doc.fileType} | ${(doc.fileSize! / 1024).toStringAsFixed(2)} KB",
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.download, color: Colors.green),
              onPressed: () => downloadFile(doc.blobUrl!, doc.fileName!),
            ),
            IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.blue
                    : Color(0xFF57C9E7),
              ),
              onPressed: () => OpenFile.open(doc.blobUrl),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> downloadFile(String url, String fileName) async {
    final themeProvider = Provider.of<ThemeProvider>(context);
    try {
      Fluttertoast.showToast(
        msg: "$fileName downloaded successfully.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: themeProvider.themeData.brightness == Brightness.light
            ? Colors.indigo.shade900
            : Color(0xFF57C9E7),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      print("Error downloading file: $e");

      Fluttertoast.showToast(
        msg: "Failed to download the file.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
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
        title: Text(
          "Documents",
          style: TextStyle(
            color: themeProvider.themeData.brightness == Brightness.light
                ? Colors.white
                : Color(0xFF57C9E7),
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: themeProvider.themeData.brightness == Brightness.light
                ? LinearGradient(
                    colors: [Colors.indigo.shade900, Colors.indigo.shade900],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: themeProvider.themeData.brightness == Brightness.dark
                ? Color.fromARGB(255, 24, 28, 37)
                : null,
          ),
        ),
        iconTheme: IconThemeData(
          color: themeProvider.themeData.brightness == Brightness.light
              ? Colors.white
              : Color(0xFF57C9E7),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: themeProvider.themeData.brightness == Brightness.light
                  ? Colors.white
                  : Color(0xFF57C9E7),
            ),
            onPressed: fetchDocuments,
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.indigo.shade900
                    : Color(0xFF57C9E7),
              ),
            )
          : documents.isEmpty
              ? Center(
                  child: Text(
                  "No documents available.",
                  style: TextStyle(
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                  ),
                ))
              : ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) =>
                      buildDocumentItem(documents[index]),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: uploadDocument,
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        label: const Text(
          "Upload Document",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: themeProvider.themeData.brightness == Brightness.light
            ? Colors.indigo.shade900
            : Color(0xFF57C9E7),
      ),
    );
  }
}
