import 'package:demo_map/view/home/home_view.dart';
import 'package:flutter/material.dart';

class DemoMap extends StatelessWidget {
  const DemoMap({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Demo Map',
      home: HomeView(),
    );
  }
}
