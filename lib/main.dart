import 'package:flutter/material.dart';
import 'package:shopping_list_app/screens/groceries.dart';

void main() {
  runApp(const MyApp());
}

var kColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 147, 229, 250),
  surface: const Color.fromARGB(255, 42, 51, 59),
);

final theme = ThemeData(
  colorScheme: kColorScheme,
  scaffoldBackgroundColor: const Color.fromARGB(255, 50, 58, 60),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Groceries",
      theme: theme,
      home: const Groceries(),
    );
  }
}
