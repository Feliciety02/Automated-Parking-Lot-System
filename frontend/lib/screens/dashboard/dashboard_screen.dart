import 'package:flutter/material.dart';
import '../new_ticket/new_ticket_screen.dart';
import '../active_tickets/active_tickets_screen.dart';
import '../parking_slots/slots_screen.dart';
import '../history/history_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isCollapsed = false; // Sidebar open or collapsed
  Widget activeScreen = const NewTicketScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // ---------------------------
          // SIDEBAR
          // ---------------------------
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isCollapsed ? 70 : 220,
            color: Colors.blue[900],
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Collapse Button
                IconButton(
                  icon: Icon(
                    isCollapsed ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() => isCollapsed = !isCollapsed);
                  },
                ),

                const SizedBox(height: 20),

                // MENU BUTTONS
                _menuItem(
                  icon: Icons.add_circle_outline,
                  label: "New Ticket",
                  collapsed: isCollapsed,
                  onTap: () {
                    setState(() => activeScreen = const NewTicketScreen());
                  },
                ),

                _menuItem(
                  icon: Icons.local_parking_outlined,
                  label: "Active Tickets",
                  collapsed: isCollapsed,
                  onTap: () {
                    setState(() => activeScreen = const ActiveTicketsScreen());
                  },
                ),

                _menuItem(
                  icon: Icons.grid_view,
                  label: "Parking Slots",
                  collapsed: isCollapsed,
                  onTap: () {
                    setState(() => activeScreen = const SlotsScreen());
                  },
                ),

                _menuItem(
                  icon: Icons.history,
                  label: "History",
                  collapsed: isCollapsed,
                  onTap: () {
                    setState(() => activeScreen = const HistoryScreen());
                  },
                ),

                const Spacer(),

                // Logout or Settings
                _menuItem(
                  icon: Icons.settings,
                  label: "Settings",
                  collapsed: isCollapsed,
                  onTap: () {},
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),

          // ---------------------------
          // MAIN CONTENT AREA
          // ---------------------------
          Expanded(
            child: Container(
              color: Colors.grey[100],
              child: activeScreen,
            ),
          ),
        ],
      ),
    );
  }

  // -----------------------------
  // SIDEBAR MENU ITEM WIDGET
  // -----------------------------
  Widget _menuItem({
    required IconData icon,
    required String label,
    required bool collapsed,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Icon(icon, color: Colors.white, size: 26),
            if (!collapsed) ...[
              const SizedBox(width: 16),
              Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
