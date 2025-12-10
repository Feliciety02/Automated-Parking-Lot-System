import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/contants.dart';
import '../models/ticket.dart';
import '../models/slot.dart';

class ApiService {
  final String baseUrl = AppConstants.baseUrl;

  Future<List<Slot>> getSlots() async {
    final res = await http.get(Uri.parse("$baseUrl/slots"));
    List data = jsonDecode(res.body);
    return data.map((s) => Slot.fromJson(s)).toList();
  }

Future<Ticket> createTicket(String plate) async {
  final res = await http.post(
    Uri.parse("$baseUrl/tickets"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"plateNumber": plate}),
  );

  print("DEBUG RESPONSE: ${res.body}");

  return Ticket.fromJson(jsonDecode(res.body));
}


  Future<Ticket> exitTicket(int id) async {
    final res = await http.put(Uri.parse("$baseUrl/tickets/$id/exit"));
    return Ticket.fromJson(jsonDecode(res.body));
  }

  Future<List<Ticket>> getActiveTickets() async {
    final res = await http.get(Uri.parse("$baseUrl/tickets?active=true"));
    List data = jsonDecode(res.body);
    return data.map((t) => Ticket.fromJson(t)).toList();
  }

  Future<Ticket> lostTicket(int id) async {
  final res = await http.put(Uri.parse("$baseUrl/tickets/$id/lost"));
  return Ticket.fromJson(jsonDecode(res.body));
}

}
