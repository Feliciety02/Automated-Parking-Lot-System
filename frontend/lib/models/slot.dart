class Slot {
  final String slotId;
  final bool isAvailable;

  Slot({
    required this.slotId,
    required this.isAvailable,
  });

  factory Slot.fromJson(Map<String, dynamic> json) {
    return Slot(
      slotId: json["slot_id"] ?? "",              // backend uses slot_id
      isAvailable: (json["is_available"] == 1),    // SQLite returns 0 or 1
    );
  }
}
