import 'package:flutter/material.dart';

class ExitScreen extends StatelessWidget {
  final int ticketId;

  const ExitScreen({super.key, required this.ticketId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Exit Processing")),
      body: Center(
        child: Text(
          "Processing exit for Ticket ID: $ticketId",
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
