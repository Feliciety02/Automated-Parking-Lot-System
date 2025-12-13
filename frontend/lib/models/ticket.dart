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

  Ticket copyWith({
  int? id,
  String? plateNumber,
  String? slotId,
  String? timeIn,
  String? timeOut,
  double? totalAmount,
  int? durationHours,
}) {
  return Ticket(
    id: id ?? this.id,
    plateNumber: plateNumber ?? this.plateNumber,
    slotId: slotId ?? this.slotId,
    timeIn: timeIn ?? this.timeIn,
    timeOut: timeOut ?? this.timeOut,
    totalAmount: totalAmount ?? this.totalAmount,
    durationHours: durationHours ?? this.durationHours,
  );
}


  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: _parseInt(json["id"]),
      plateNumber: json["plateNumber"]?.toString() ?? "",
      slotId: json["slotId"]?.toString() ?? "",
      timeIn: json["timeIn"]?.toString() ?? "",
      timeOut: json["timeOut"]?.toString(),
      durationHours: _parseIntNullable(json["durationHours"]),
      totalAmount: _parseDoubleNullable(json["totalAmount"]),
    );
  }
}

/// ------------------------------
/// SAFE PARSING HELPERS
/// ------------------------------

int _parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.toInt();
  return int.tryParse(value.toString()) ?? 0;
}

int? _parseIntNullable(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  return int.tryParse(value.toString());
}

double? _parseDoubleNullable(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  return double.tryParse(value.toString());
}



