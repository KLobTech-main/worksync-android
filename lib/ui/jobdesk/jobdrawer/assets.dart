import 'package:dass/colortheme/theme_maneger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../modal/assetsmodel.dart';
import '../../../webservices/api.dart';

class AssetsDialog extends StatefulWidget {
  final String email;

  AssetsDialog({required this.email});

  @override
  State<AssetsDialog> createState() => _AssetsDialogState();
}

class _AssetsDialogState extends State<AssetsDialog> {
  late Future<List<AssetsModel>> _assetsFuture;

  @override
  void initState() {
    super.initState();
    _assetsFuture = ApiService().fetchAssets(widget.email, context);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return AlertDialog(
      title: Text(
        "Employee Assets",
        style: TextStyle(
          color: themeProvider.themeData.brightness == Brightness.light
              ? Colors.black
              : Color(0xFF57C9E7),
        ),
      ),
      content: FutureBuilder<List<AssetsModel>>(
        future: _assetsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.indigo.shade900
                    : Color(0xFF57C9E7),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}',
                    style: TextStyle(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                    )));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text("No data available",
                    style: TextStyle(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                    )));
          } else {
            final assets = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: assets.map((asset) => buildAssetCard(asset)).toList(),
              ),
            );
          }
        },
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor:
                themeProvider.themeData.brightness == Brightness.light
                    ? Colors.indigo.shade900
                    : Color(0xFF57C9E7), // Set the text color to red
          ),
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text(
            "Close",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget buildAssetCard(AssetsModel asset) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue.shade700, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Asset Name: ${asset.assetName ?? 'N/A'}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.black
                    : Color(0xFF57C9E7),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Asset Code: ${asset.assetsCode ?? 'N/A'}",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.black
                      : Colors.white),
            ),
            SizedBox(height: 5),
            Text("Serial No: ${asset.serialNo ?? 'N/A'}",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.black
                            : Colors.white)),
            SizedBox(height: 5),
            Text("Is Working: ${asset.isWorking == 'true' ? "Yes" : "No"}",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.black
                            : Colors.white)),
            SizedBox(height: 5),
            Text("Type: ${asset.type ?? 'N/A'}",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.black
                            : Colors.white)),
            SizedBox(height: 5),
            Text("Issued Date: ${asset.issuedDate ?? 'N/A'}",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.black
                            : Colors.white)),
            SizedBox(height: 5),
            if (asset.note != null)
              Text("Note: ${asset.note}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.black
                              : Colors.white)),
          ],
        ),
      ),
    );
  }
}
