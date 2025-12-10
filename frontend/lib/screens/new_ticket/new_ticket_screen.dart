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
        const SnackBar(content: Text("Please enter plate number")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      Ticket ticket = await ticketService.createTicket(plate);
      setState(() => createdTicket = ticket);
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            const Text(
              "Enter Vehicle Plate Number",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: plateController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "ABC123",
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: isLoading ? null : createTicket,
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Assign Slot"),
            ),

            const SizedBox(height: 30),

            if (createdTicket != null) ...[
              const Divider(),
              Text("Ticket Created", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text("Plate Number: ${createdTicket!.plateNumber}"),
              Text("Assigned Slot: ${createdTicket!.slotId}"),
              Text("Time In: ${createdTicket!.timeIn}"),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Return to Dashboard"),
              )
            ]
          ],
        ),
      ),
    );
  }
}
