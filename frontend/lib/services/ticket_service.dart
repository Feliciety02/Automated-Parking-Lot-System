import 'dart:convert';
import 'package:frontend/services/api_services.dart' as api;
import 'package:http/http.dart' as http;
import '../models/ticket.dart';

class TicketService {
  final String baseUrl = "http://127.0.0.1:8000/tickets";

  // --------------------------
  // CREATE TICKET
  // --------------------------
  Future<Ticket> createTicket(String plateNumber) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"plateNumber": plateNumber}),
    );

    final data = jsonDecode(response.body);
    return Ticket.fromJson(data);
  }

  // --------------------------
  // GET ACTIVE TICKETS
  // --------------------------
  Future<List<Ticket>> getActiveTickets() async {
    final response = await http.get(Uri.parse("$baseUrl?active=true"));
    final List list = jsonDecode(response.body);

    return list.map((e) => Ticket.fromJson(e)).toList();
  }

  // --------------------------
  // EXIT PREVIEW (NO DB UPDATE)
  // --------------------------
  Future<Ticket> previewExit(int ticketId) async {
    final response = await http.get(Uri.parse("$baseUrl/$ticketId/exit-preview"));
    final data = jsonDecode(response.body);
    return Ticket.fromJson(data);
  }

  // --------------------------
  // LOST TICKET (IMMEDIATE)
  // --------------------------
  Future<Ticket> lostTicket(int ticketId) async {
    final response = await http.put(Uri.parse("$baseUrl/$ticketId/lost"));
    return Ticket.fromJson(jsonDecode(response.body));
  }

  // --------------------------
  // CONFIRM PAYMENT (DB UPDATE)
  // --------------------------
  Future<bool> confirmPayment(int ticketId, int i) async {
    final response = await http.put(Uri.parse("$baseUrl/$ticketId/confirm"));
    final data = jsonDecode(response.body);
    return data["success"] == true;
  }

    Future<List<Ticket>> getHistory() => api.getHistory();

}
