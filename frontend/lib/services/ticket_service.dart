import 'api_services.dart';
import '../models/ticket.dart';

class TicketService {
  final ApiService api = ApiService();

  Future<Ticket> createTicket(String plate) => api.createTicket(plate);
  Future<Ticket> exitTicket(int id) => api.exitTicket(id);
  Future<List<Ticket>> getActiveTickets() => api.getActiveTickets();
  Future<Ticket> lostTicket(int id) => api.lostTicket(id);

}
