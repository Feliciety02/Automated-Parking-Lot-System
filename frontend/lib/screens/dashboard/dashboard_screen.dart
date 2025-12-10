import 'package:flutter/material.dart';
import '../parking_slots/slots_screen.dart';
import '../new_ticket/new_ticket_screen.dart';
import '../active_tickets/active_tickets_screen.dart';
import '../history/history_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Parking Dashboard")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text("New Ticket"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (c) => const NewTicketScreen()),
                );
              },
            ),
            ElevatedButton(
              child: const Text("Active Tickets"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (c) => const ActiveTicketsScreen()),
                );
              },
            ),
            ElevatedButton(
              child: const Text("Parking Slots"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (c) => const SlotsScreen()),
                );
              },
            ),
            ElevatedButton(
              child: const Text("History"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (c) => const HistoryScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
