// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aircraft_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AircraftModel _$AircraftModelFromJson(Map<String, dynamic> json) =>
    AircraftModel(
      id: json['id'] as String,
      registration: json['registration'] as String,
      model: json['model'] as String,
      manufacturer: json['manufacturer'] as String,
      capacity: (json['capacity'] as num).toInt(),
      rangeKm: (json['rangeKm'] as num).toDouble(),
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$AircraftModelToJson(AircraftModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'registration': instance.registration,
      'model': instance.model,
      'manufacturer': instance.manufacturer,
      'capacity': instance.capacity,
      'rangeKm': instance.rangeKm,
      'isActive': instance.isActive,
    };
