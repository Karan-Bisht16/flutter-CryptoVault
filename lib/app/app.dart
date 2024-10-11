import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cryptovault/pages/home.page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "My Journey",
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(),
        fontFamily: GoogleFonts.roboto().fontFamily,
      ),
      routes: {
        "/home": (context) => Home(),
      },
      initialRoute: "/home",
    );
  }
}
