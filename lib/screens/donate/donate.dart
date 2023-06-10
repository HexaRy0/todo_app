import 'package:flutter/material.dart';

class DonateScreen extends StatefulWidget {
  const DonateScreen({super.key});

  @override
  State<DonateScreen> createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Donate"),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.favorite),
            Text("Donate"),
          ],
        ),
      ),
    );
  }
}
