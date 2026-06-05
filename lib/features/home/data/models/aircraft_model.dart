import 'package:json_annotation/json_annotation.dart';
import 'package:airman_toga_flutter_assessment/core/utils/type_defs.dart';
import '../../domain/entities/aircraft.dart';

part 'aircraft_model.g.dart';

@JsonSerializable()
class AircraftModel {
  final String id;
  final String registration;
  final String model;
  final String manufacturer;
  final int capacity;
  final double rangeKm;
  final bool isActive;

  const AircraftModel({
    required this.id,
    required this.registration,
    required this.model,
    required this.manufacturer,
    required this.capacity,
    required this.rangeKm,
    required this.isActive,
  });

  factory AircraftModel.fromJson(JsonMap json) => _$AircraftModelFromJson(json);

  JsonMap toJson() => _$AircraftModelToJson(this);

  Aircraft toEntity() {
    return Aircraft(
      id: id,
      registration: registration,
      model: model,
      manufacturer: manufacturer,
      capacity: capacity,
      rangeKm: rangeKm,
      isActive: isActive,
    );
  }

  factory AircraftModel.fromEntity(Aircraft entity) {
    return AircraftModel(
      id: entity.id,
      registration: entity.registration,
      model: entity.model,
      manufacturer: entity.manufacturer,
      capacity: entity.capacity,
      rangeKm: entity.rangeKm,
      isActive: entity.isActive,
    );
  }
}
