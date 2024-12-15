import 'package:flutter/material.dart';

import '../widgets/my_scaffold.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Column(
        children: [],
      ),
    );
  }
}
