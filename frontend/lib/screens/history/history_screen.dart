import 'package:flutter/material.dart';
import '../../services/ticket_service.dart';
import '../../models/ticket.dart';
import 'history_data_source.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TicketService ticketService = TicketService();

  List<Ticket> _allHistory = [];
  List<Ticket> _filteredHistory = [];
  late HistoryDataSource _dataSource;

  bool _loading = true;
  bool _sortAscending = true;
  int _sortColumnIndex = 0;

  DateTime? _selectedDate;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  // ----------------------------------------------------------
  // LOAD HISTORY FROM API
  // ----------------------------------------------------------
  Future<void> _loadHistory() async {
    try {
      final items = await ticketService.getHistory();
      _allHistory = items;
      _applyFilter();
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error loading history: $e")));
    }
  }

  // ----------------------------------------------------------
  // APPLY FILTERS (DATE + SEARCH)
  // ----------------------------------------------------------
  void _applyFilter() {
    List<Ticket> list = List.from(_allHistory);

    // date filter
    if (_selectedDate != null) {
      list = list.where((t) {
        if (t.timeOut == null) return false;
        final dt = DateTime.tryParse(t.timeOut!);
        if (dt == null) return false;

        return dt.year == _selectedDate!.year &&
            dt.month == _selectedDate!.month &&
            dt.day == _selectedDate!.day;
      }).toList();
    }

    // search filter
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((t) {
        return t.plateNumber.toLowerCase().contains(q) ||
            t.slotId.toLowerCase().contains(q) ||
            t.timeIn.toLowerCase().contains(q);
      }).toList();
    }

    _filteredHistory = list;

    _dataSource = HistoryDataSource(
      tickets: _filteredHistory,
      onView: _showTicketDialog,
    );

    setState(() => _loading = false);
  }

  // ----------------------------------------------------------
  // DATE FORMAT
  // ----------------------------------------------------------
  String _formatDate(DateTime d) {
    return "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
  }

  // ----------------------------------------------------------
  // FIXED DATE PICKER WITH ROUNDED DIALOG
  // ----------------------------------------------------------
Future<void> _pickDate() async {
  final picked = await showDatePicker(
    context: context,
    initialDate: _selectedDate ?? DateTime.now(),
    firstDate: DateTime(2020),
    lastDate: DateTime.now().add(const Duration(days: 365)),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          dialogTheme: DialogThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
          ),
        ),
        child: child!,
      );
    },
  );

  if (picked != null) {
    setState(() {
      _selectedDate = picked;
      _loading = true;
    });
    _applyFilter();
  }
}


  void _clearDate() {
    setState(() {
      _selectedDate = null;
      _loading = true;
    });
    _applyFilter();
  }

  // ----------------------------------------------------------
  // SORTING
  // ----------------------------------------------------------
  void _sort<T extends Comparable>(int index, bool asc, T Function(Ticket t) getField) {
    setState(() {
      _sortColumnIndex = index;
      _sortAscending = asc;

      _filteredHistory.sort((a, b) {
        final aV = getField(a);
        final bV = getField(b);
        return asc ? aV.compareTo(bV) : bV.compareTo(aV);
      });

      _dataSource = HistoryDataSource(
        tickets: _filteredHistory,
        onView: _showTicketDialog,
      );
    });
  }

  // ----------------------------------------------------------
  // POPUP TICKET VIEW
  // ----------------------------------------------------------
  void _showTicketDialog(Ticket t) {
    final lost = (t.durationHours == 0 && (t.totalAmount ?? 0) >= 150);

    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Ticket #${t.id}",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text("Plate: ${t.plateNumber}",
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              Text("Slot: ${t.slotId}"),
              const SizedBox(height: 8),
              Text("Time In: ${t.timeIn}"),
              Text("Time Out: ${t.timeOut ?? "—"}"),
              const SizedBox(height: 8),
              Text("Duration: ${t.durationHours ?? 0} hour(s)"),
              const SizedBox(height: 8),
              Text(
                "Total Paid: ₱${(t.totalAmount ?? 0).toStringAsFixed(2)}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              if (lost)
                const Text("Lost Ticket Fee Applied",
                    style: TextStyle(color: Colors.red)),
              const SizedBox(height: 14),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              )
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // UI
  // ----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final carsCount = _filteredHistory.length;
    final totalCount = _allHistory.length;
    final totalRevenue = _filteredHistory.fold<double>(
        0, (sum, t) => sum + (t.totalAmount ?? 0));

    return Scaffold(
      appBar: AppBar(title: const Text("History"), centerTitle: true),

      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 10),

                // ---------------- FILTER BAR ----------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _pickDate,
                        icon: const Icon(Icons.calendar_month),
                        label: const Text("Date"),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _selectedDate == null
                            ? "All Dates"
                            : _formatDate(_selectedDate!),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: _clearDate,
                        icon: const Icon(Icons.refresh),
                        tooltip: "Reset",
                      )
                    ],
                  ),
                ),

                // ---------------- SEARCH BAR ----------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search),
                        hintText: "Search plate, slot, time…",
                      ),
                      onChanged: (v) {
                        _searchQuery = v;
                        _applyFilter();
                      },
                    ),
                  ),
                ),

                // ---------------- INFO CARDS ----------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      _infoCard("In View", "$carsCount"),
                      _infoCard("Total", "$totalCount"),
                      _infoCard("Revenue", "₱${totalRevenue.toStringAsFixed(2)}"),
                    ],
                  ),
                ),

                // ---------------- TABLE ----------------
                Expanded(
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: PaginatedDataTable(
                        header: const Text(
                          "Completed Tickets",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w600),
                        ),
                        rowsPerPage: 7,
                        sortAscending: _sortAscending,
                        sortColumnIndex: _sortColumnIndex,
                        columns: [
                          DataColumn(
                            label: const Text("ID",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            numeric: true,
                            onSort: (i, asc) =>
                                _sort<int>(i, asc, (t) => t.id),
                          ),
                          DataColumn(
                            label: const Text("Plate",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            onSort: (i, asc) =>
                                _sort<String>(i, asc, (t) => t.plateNumber),
                          ),
                          DataColumn(
                            label: const Text("Slot",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            onSort: (i, asc) =>
                                _sort<String>(i, asc, (t) => t.slotId),
                          ),
                          DataColumn(
                            label: const Text("Time In"),
                            onSort: (i, asc) =>
                                _sort<String>(i, asc, (t) => t.timeIn),
                          ),
                          DataColumn(
                            label: const Text("Time Out"),
                            onSort: (i, asc) =>
                                _sort<String>(i, asc, (t) => t.timeOut ?? ""),
                          ),
                          DataColumn(
                            label: const Text("Amount",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            numeric: true,
                            onSort: (i, asc) =>
                                _sort<num>(i, asc, (t) => t.totalAmount ?? 0),
                          ),
                          const DataColumn(
                            label: Icon(Icons.visibility,
                                color: Colors.black87, size: 20),
                          ),
                        ],
                        source: _dataSource,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  // ----------------------------------------------------------
  // INFO CARD
  // ----------------------------------------------------------
  Widget _infoCard(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
