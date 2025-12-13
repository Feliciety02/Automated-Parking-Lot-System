import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/contants.dart';
import '../models/ticket.dart';
import '../models/slot.dart';

const String baseUrl = "http://127.0.0.1:8000";   // or your actual server URL

class ApiService {
  final String baseUrl = AppConstants.baseUrl;

  // --------------------------
  // GET ALL SLOTS
  // --------------------------
Future<List<Slot>> getSlots() async {
  final res = await http.get(Uri.parse("$baseUrl/slots"));

  if (res.statusCode != 200) {
    throw Exception("Failed to load slots");
  }

  List data = jsonDecode(res.body);
  return data.map((s) => Slot.fromJson(s)).toList();
}

  // --------------------------
  // CREATE TICKET (FIXED)
  // --------------------------
  Future<Ticket> createTicket(String plate) async {
    final res = await http.post(
      Uri.parse("$baseUrl/tickets"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"plateNumber": plate}), // BACKEND EXPECTS THIS EXACT KEY
    );

    print("DEBUG RESPONSE: ${res.body}");

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception("Failed to create ticket: ${res.body}");
    }

    return Ticket.fromJson(jsonDecode(res.body));
  }

  // --------------------------
  // EXIT TICKET
  // --------------------------
  Future<Ticket> exitTicket(int id) async {
    final res = await http.put(Uri.parse("$baseUrl/tickets/$id/exit"));

    if (res.statusCode != 200) {
      throw Exception("Failed to exit ticket");
    }

    return Ticket.fromJson(jsonDecode(res.body));
  }

  // --------------------------
  // LOST TICKET
  // --------------------------
  Future<Ticket> lostTicket(int id) async {
    final res = await http.put(Uri.parse("$baseUrl/tickets/$id/lost"));

    if (res.statusCode != 200) {
      throw Exception("Failed to process lost ticket");
    }

    return Ticket.fromJson(jsonDecode(res.body));
  }

  // --------------------------
  // GET ACTIVE TICKETS
  // --------------------------
  Future<List<Ticket>> getActiveTickets() async {
    final res = await http.get(Uri.parse("$baseUrl/tickets?active=true"));

    if (res.statusCode != 200) {
      throw Exception("Failed to load active tickets");
    }

    List data = jsonDecode(res.body);
    return data.map((t) => Ticket.fromJson(t)).toList();
  }
}


Future<List<Ticket>> getHistory() async {
  final res = await http.get(Uri.parse("$baseUrl/tickets/history"));

  if (res.statusCode != 200) {
    throw Exception("Failed to load history");
  }

  final List data = jsonDecode(res.body);
  return data.map((e) => Ticket.fromJson(e)).toList();
}

