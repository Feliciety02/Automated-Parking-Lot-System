class Slot {
  final String id;
  final bool isOccupied;

  Slot({
    required this.id,
    required this.isOccupied,
  });

  factory Slot.fromJson(Map<String, dynamic> json) {
    return Slot(
      id: json['id'],
      isOccupied: json['isOccupied'],
    );
  }
}
