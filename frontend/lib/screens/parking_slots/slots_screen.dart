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

  String selectedFloor = "A";   // A, B, or C

  @override
  void initState() {
    super.initState();
    loadSlots();
  }

  Future<void> loadSlots() async {
    try {
      final data = await api.getSlots();
      setState(() => slots = data);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading slots: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Slot> filtered = slots.where(
      (s) => s.slotId.startsWith(selectedFloor),
    ).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Parking Slots")),

      body: Column(
        children: [
          // ---------------------
          // FLOOR BUTTONS
          // ---------------------
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _floorButton("A"),
                _floorButton("B"),
                _floorButton("C"),
              ],
            ),
          ),

          // ---------------------
          // GRID VIEW OF SLOTS
          // ---------------------
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.3,
              ),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                return SlotCard(slot: filtered[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _floorButton(String floor) {
    bool active = selectedFloor == floor;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: active ? Colors.blue : Colors.grey[400],
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      ),
      onPressed: () {
        setState(() => selectedFloor = floor);
      },
      child: Text(
        "Floor $floor",
        style: TextStyle(
          color: active ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
