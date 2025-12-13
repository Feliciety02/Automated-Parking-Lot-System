import 'package:flutter/material.dart';
import '../../services/ticket_service.dart';
import '../../models/ticket.dart';

class NewTicketScreen extends StatefulWidget {
  const NewTicketScreen({super.key});

  @override
  State<NewTicketScreen> createState() => _NewTicketScreenState();
}

class _NewTicketScreenState extends State<NewTicketScreen> {
  final TextEditingController plateController = TextEditingController();
  final TicketService ticketService = TicketService();

  bool isLoading = false;
  Ticket? createdTicket;

  Future<void> createTicket() async {
    final plate = plateController.text.trim();

    if (plate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a plate number")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      Ticket ticket = await ticketService.createTicket(plate);
      setState(() {
        createdTicket = ticket;
        plateController.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Ticket")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter Vehicle Plate Number",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: plateController,
              decoration: InputDecoration(
                hintText: "ABC123",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: isLoading ? null : createTicket,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Assign Slot", style: TextStyle(fontSize: 16)),
              ),
            ),

            const SizedBox(height: 30),

            if (createdTicket != null) ...[
              const Text(
                "Ticket Created",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              _ticketCard(createdTicket!),

              const SizedBox(height: 20),
            ]
          ],
        ),
      ),
    );
  }

  Widget _ticketCard(Ticket ticket) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Plate: ${ticket.plateNumber}", style: const TextStyle(fontSize: 16)),
          Text("Slot: ${ticket.slotId}", style: const TextStyle(fontSize: 16)),
          Text("Time In: ${ticket.timeIn}", style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
