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
              ? const Center(
                  child: Text(
                    "No active tickets",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                )

              : RefreshIndicator(
                  onRefresh: loadTickets,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: activeTickets.length,
                    itemBuilder: (context, index) {
                      final ticket = activeTickets[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ticket.plateNumber,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 4),
                            Text("Slot: ${ticket.slotId}",
                                style: const TextStyle(fontSize: 16)),
                            Text("Time In: ${ticket.timeIn}",
                                style: const TextStyle(fontSize: 16)),

                            const SizedBox(height: 12),

                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
onPressed: () async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent, // dim background

    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.6,
        maxChildSize: 0.95,

        builder: (_, controller) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 3,
                )
              ],
            ),

            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),

              child: ExitScreen(
                ticketId: ticket.id,
              ),
            ),
          );
        },
      );
    },
  );

  loadTickets();
},


                                child: const Text(
                                  "Process Exit",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
