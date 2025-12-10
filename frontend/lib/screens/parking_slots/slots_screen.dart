import 'package:flutter/material.dart';
import '../../models/slot.dart';
import '../../services/api_services.dart';
import '../../widget/slot_card.dart';

class SlotsScreen extends StatefulWidget {
  const SlotsScreen({super.key});

  @override
  State<SlotsScreen> createState() => _SlotsScreenState();
}

class _SlotsScreenState extends State<SlotsScreen> {
  final ApiService api = ApiService();
  List<Slot> slots = [];

  @override
  void initState() {
    super.initState();
    loadSlots();
  }

  Future<void> loadSlots() async {
    final data = await api.getSlots();
    setState(() {
      slots = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Parking Slots")),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.3,
        ),
        itemCount: slots.length,
        itemBuilder: (context, index) {
          return SlotCard(slot: slots[index]);
        },
      ),
    );
  }
}
