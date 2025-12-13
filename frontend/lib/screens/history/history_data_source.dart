import 'package:flutter/material.dart';
import '../../models/ticket.dart';

class HistoryDataSource extends DataTableSource {
  final List<Ticket> tickets;
  final void Function(Ticket ticket) onView;

  HistoryDataSource({
    required this.tickets,
    required this.onView,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= tickets.length) return null;
    final t = tickets[index];

    return DataRow(
      cells: [
        DataCell(Text(t.id.toString())),
        DataCell(
          Text(
            t.plateNumber,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataCell(Text(t.slotId)),
        DataCell(Text(t.timeIn)),
        DataCell(Text(t.timeOut ?? "")),
        DataCell(Text("₱${(t.totalAmount ?? 0).toStringAsFixed(2)}")),
        DataCell(
          IconButton(
            icon: const Icon(Icons.visibility, color: Colors.blue),
            tooltip: "View details",
            onPressed: () => onView(t),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => tickets.length;

  @override
  int get selectedRowCount => 0;
}
