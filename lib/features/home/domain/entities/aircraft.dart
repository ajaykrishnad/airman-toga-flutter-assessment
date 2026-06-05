class Aircraft {
  final String id;
  final String registration;
  final String model;
  final String manufacturer;
  final int capacity;
  final double rangeKm;
  final bool isActive;

  const Aircraft({
    required this.id,
    required this.registration,
    required this.model,
    required this.manufacturer,
    required this.capacity,
    required this.rangeKm,
    required this.isActive,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Aircraft && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Aircraft(id: $id, registration: $registration, model: $model)';
  }
}
