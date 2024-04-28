import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_tracing/screens/log_in.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: Color.fromARGB(255, 60, 155, 219),
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);
void main() {
  runApp(const QuranTracingApp());
}

class QuranTracingApp extends StatelessWidget {
  const QuranTracingApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const LogInScreen(),
    );
  }
}
