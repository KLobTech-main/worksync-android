import 'package:dass/colortheme/theme_maneger.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../webservices/api.dart';

class ResetPasswordDialog extends StatefulWidget {
  const ResetPasswordDialog({Key? key}) : super(key: key);

  @override
  _ResetPasswordDialogState createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<ResetPasswordDialog> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isLoading = false;
  bool isPasswordVisible = false;

  void submit() async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final email = emailController.text.trim();
    final newPassword = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (email.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      if (context.mounted) {
        Fluttertoast.showToast(
          msg: "Please fill out all fields",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      if (newPassword != confirmPassword) {
        if (context.mounted) {
          Fluttertoast.showToast(
            msg: "Passwords do not match",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
        return;
      }
      return;
    }

    setState(() {
      isLoading = true;
    });

    final apiService = ApiService();
    final success = await apiService.resetPassword(email, newPassword);

    setState(() {
      isLoading = false;
    });

    if (context.mounted) {
      if (success) {
        Navigator.of(context).pop(); // Close the dialog

        Fluttertoast.showToast(
          msg: "Password reset successfully!",
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
          msg: "Failed to reset password",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return AlertDialog(
      title: Text(
        'Reset Password',
        style: TextStyle(
          color: themeProvider.themeData.brightness == Brightness.light
              ? Colors.black
              : const Color(0xFF57C9E7),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
            ),
          ),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: 'New Password',
              labelStyle: TextStyle(
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              ),
            ),
            obscureText: !isPasswordVisible,
          ),
          TextField(
            controller: confirmPasswordController,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              labelStyle: TextStyle(
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              ),
            ),
            obscureText: !isPasswordVisible,
          ),
        ],
      ),
      actions: [
        if (isLoading)
          CircularProgressIndicator(
            color: themeProvider.themeData.brightness == Brightness.light
                ? Colors.indigo.shade900
                : Color(0xFF57C9E7),
          )
        else
          TextButton(
            onPressed: submit,
            child: Text(
              'Submit',
              style: TextStyle(
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.black
                    : Color(0xFF57C9E7),
              ),
            ),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: TextStyle(
              color: themeProvider.themeData.brightness == Brightness.light
                  ? Colors.black
                  : Color(0xFF57C9E7),
            ),
          ),
        ),
      ],
    );
  }
}
