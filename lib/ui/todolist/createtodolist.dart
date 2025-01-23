import 'package:dass/colortheme/theme_maneger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateTodoList extends StatefulWidget {
  const CreateTodoList({super.key});

  @override
  State<CreateTodoList> createState() => _CreateTodoListState();
}

class _CreateTodoListState extends State<CreateTodoList> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController addDiscriptionController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController importentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.themeData.brightness == Brightness.light
          ? const Color.fromARGB(255, 246, 244, 244)
          : Color(0xFF1C1F26),
      appBar: AppBar(
        title: Text('Create TodoList',
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
        iconTheme: IconThemeData(
          color: themeProvider.themeData.brightness == Brightness.light
              ? Colors.white
              : Color(0xFF57C9E7),
        ), // Adjust icon color for dark theme

        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              TextField(
                style: TextStyle(
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                ),
                controller: addDiscriptionController,
                decoration: InputDecoration(
                  labelText: 'Add a discreptions...',
                  labelStyle: TextStyle(
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.black.withOpacity(0.3)
                              : Colors.white.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.black
                              : Colors.grey,
                      width: 2,
                    ),
                  ), // Added
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                style: TextStyle(
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                ),
                controller: categoryController,
                decoration: InputDecoration(
                  labelText: 'Category',
                  suffixIcon: Icon(Icons.arrow_drop_down),
                  labelStyle: TextStyle(
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.black.withOpacity(0.3)
                              : Colors.white.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.black
                              : Colors.grey,
                      width: 2,
                    ),
                  ), // Added
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                style: TextStyle(
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                ),
                controller: dateController,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.calendar_month),
                  labelText: 'Date',
                  labelStyle: TextStyle(
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.black.withOpacity(0.3)
                              : Colors.white.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.black
                              : Colors.grey,
                      width: 2,
                    ),
                  ), // Added
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                style: TextStyle(
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                ),
                controller: timeController,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.timer_off),
                  labelText: 'Time',
                  labelStyle: TextStyle(
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.black.withOpacity(0.3)
                              : Colors.white.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.black
                              : Colors.grey,
                      width: 2,
                    ),
                  ), // Added
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                style: TextStyle(
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                ),
                controller: importentController,
                decoration: InputDecoration(
                  labelText: 'Importent',
                  suffixIcon: Icon(Icons.add_box),
                  labelStyle: TextStyle(
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.black.withOpacity(0.3)
                              : Colors.white.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.black
                              : Colors.grey,
                      width: 2,
                    ),
                  ), // Added
                ),
              ),
              SizedBox(height: 50),
              SizedBox(
                height: 50,
                width: 120,
                child: GestureDetector(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.indigo.shade900
                              : Color(0xFF57C9E7),
                    ),
                    child: Text(
                      "Done",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
