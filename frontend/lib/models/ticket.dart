class Ticket {
  final int id;
  final String plateNumber;
  final String slotId;
  final String timeIn;
  final String? timeOut;
  final int? durationHours;
  final double? totalAmount;

  Ticket({
    required this.id,
    required this.plateNumber,
    required this.slotId,
    required this.timeIn,
    this.timeOut,
    this.durationHours,
    this.totalAmount,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      plateNumber: json['plateNumber'],
      slotId: json['slotId'],
      timeIn: json['timeIn'],
      timeOut: json['timeOut'],
      durationHours: json['durationHours'],
      totalAmount: json['totalAmount']?.toDouble(),
    );
  }
}
