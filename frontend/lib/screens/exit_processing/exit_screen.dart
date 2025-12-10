import 'package:flutter/material.dart';
import '../../services/ticket_service.dart';
import '../../models/ticket.dart';

class ExitScreen extends StatefulWidget {
  final int ticketId;

  const ExitScreen({super.key, required this.ticketId});

  @override
  State<ExitScreen> createState() => _ExitScreenState();
}

class _ExitScreenState extends State<ExitScreen> {
  final TicketService ticketService = TicketService();
  Ticket? exitTicket;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    processExit();
  }

  Future<void> processExit() async {
    try {
      final ticket = await ticketService.exitTicket(widget.ticketId);
      setState(() {
        exitTicket = ticket;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Exit Processing")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : exitTicket == null
              ? const Center(child: Text("Ticket not found"))
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Ticket ID: ${exitTicket!.id}", style: const TextStyle(fontSize: 18)),
                      Text("Plate Number: ${exitTicket!.plateNumber}", style: const TextStyle(fontSize: 18)),
                      Text("Slot: ${exitTicket!.slotId}", style: const TextStyle(fontSize: 18)),

                      const SizedBox(height: 20),

                      Text("Time In: ${exitTicket!.timeIn}", style: const TextStyle(fontSize: 16)),
                      Text("Time Out: ${exitTicket!.timeOut}", style: const TextStyle(fontSize: 16)),

                      const SizedBox(height: 20),

                      Text("Total Hours: ${exitTicket!.durationHours}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("Amount to Pay: ₱${exitTicket!.totalAmount}", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

                      const Spacer(),

                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Payment Confirmed"),
                        ),

                        
                      )
                    ],
                  ),
                ),
    );
  }
}
