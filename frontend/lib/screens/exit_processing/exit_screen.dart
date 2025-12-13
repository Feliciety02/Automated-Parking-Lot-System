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
  Ticket? ticket;

  bool isLoading = true;
  bool lostTicketApplied = false;
  double originalAmount = 0;

  @override
  void initState() {
    super.initState();
    loadPreview();
  }

  // ----------------------------
  // PREVIEW EXIT COST
  // ----------------------------
  Future<void> loadPreview() async {
    try {
      final preview = await ticketService.previewExit(widget.ticketId);
      setState(() {
        ticket = preview;
        isLoading = false;
        originalAmount = preview.totalAmount ?? 0;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error loading exit: $e")));
    }
  }

  // ----------------------------
  // LOST TICKET TOGGLE
  // ----------------------------
  void toggleLostTicket() {
   setState(() {
  lostTicketApplied = !lostTicketApplied;

  ticket = ticket!.copyWith(
    totalAmount: lostTicketApplied
        ? (originalAmount + 150)
        : originalAmount,
  );
});

  }

  // ----------------------------
  // CONFIRM PAYMENT
  // ----------------------------
  Future<void> confirmPayment() async {
    setState(() => isLoading = true);

    final success = await ticketService.confirmPayment(
      widget.ticketId,
      lostTicketApplied ? 150 : 0,
    );

    if (success) {
      Navigator.pop(context); // close modal
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Payment failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(26),
        topRight: Radius.circular(26),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ticket == null
                ? const Center(child: Text("Ticket not found"))
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 5,
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),

                        _ticketCard(ticket!),

                        const SizedBox(height: 25),

                        // LOST TICKET BUTTON TOGGLE
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  lostTicketApplied ? Colors.grey : Colors.red,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            onPressed: toggleLostTicket,
                            child: Text(
                              lostTicketApplied
                                  ? "Lost Ticket Applied (Tap to Undo)"
                                  : "Lost Ticket (₱150)",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // CONFIRM PAYMENT
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            onPressed: confirmPayment,
                            child: const Text(
                              "Confirm Payment",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _ticketCard(Ticket t) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Ticket ID: ${t.id}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text("Plate Number: ${t.plateNumber}",
              style: const TextStyle(fontSize: 16)),
          Text("Slot: ${t.slotId}", style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 20),
          const Divider(),
          Text("Time In: ${t.timeIn}", style: const TextStyle(fontSize: 16)),
          Text("Preview Time Out: ${t.timeOut}",
              style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 10),
          Center(
            child: Column(
              children: [
                const Text("TOTAL AMOUNT",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(
                  "₱${t.totalAmount}",
                  style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
