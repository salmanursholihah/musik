import 'package:flutter/material.dart';
import 'features/presentation/pages/main_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music UI Demo',
      theme: ThemeData.dark(),
      home: const MainPage(),
    );
  }
}
