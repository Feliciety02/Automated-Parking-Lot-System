import 'package:flutter/material.dart';
import 'screens/dashboard/dashboard_screen.dart';

void main() {
  runApp(const ParkingApp());
}

class ParkingApp extends StatelessWidget {
  const ParkingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parking Lot System',
      theme: ThemeData(
        primarySwatch: Colors.blue,

        // ------------------------------
        // GLOBAL UI THEME
        // ------------------------------
        fontFamily: "Poppins",

        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.blue,
          elevation: 2,

          // GLOBAL APPBAR TEXT STYLE
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),

          iconTheme: IconThemeData(
            color: Colors.white,    // Back button color
          ),
        ),

        // GLOBAL BUTTON STYLE
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            textStyle: WidgetStatePropertyAll(
              TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
            padding: WidgetStatePropertyAll(
              EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            ),
          ),
        ),
      ),

      home: const DashboardScreen(),
    );
  }
}
