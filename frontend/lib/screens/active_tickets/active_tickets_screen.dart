import 'package:flutter/material.dart';
import '../../services/ticket_service.dart';
import '../../models/ticket.dart';
import '../exit_processing/exit_screen.dart';

class ActiveTicketsScreen extends StatefulWidget {
  const ActiveTicketsScreen({super.key});

  @override
  State<ActiveTicketsScreen> createState() => _ActiveTicketsScreenState();
}

class _ActiveTicketsScreenState extends State<ActiveTicketsScreen> {
  final TicketService ticketService = TicketService();
  List<Ticket> activeTickets = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTickets();
  }

  Future<void> loadTickets() async {
    try {
      final tickets = await ticketService.getActiveTickets();
      setState(() {
        activeTickets = tickets;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading tickets: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Active Tickets")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : activeTickets.isEmpty
              ? const Center(child: Text("No active tickets"))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: activeTickets.length,
                  itemBuilder: (context, index) {
                    final ticket = activeTickets[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text("Plate: ${ticket.plateNumber}"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Slot: ${ticket.slotId}"),
                            Text("Time In: ${ticket.timeIn}"),
                          ],
                        ),
                        trailing: ElevatedButton(
                          child: const Text("Process Exit"),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ExitScreen(ticketId: ticket.id),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
