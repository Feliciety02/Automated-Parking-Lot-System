import 'package:flutter/material.dart';
import '../models/slot.dart';

class SlotCard extends StatelessWidget {
  final Slot slot;

  const SlotCard({super.key, required this.slot});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: slot.isOccupied ? Colors.red : Colors.green,
      child: Center(
        child: Text(
          slot.id,
          style: const TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}
