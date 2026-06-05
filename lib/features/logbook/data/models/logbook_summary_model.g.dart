// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logbook_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogbookSummaryModel _$LogbookSummaryModelFromJson(Map<String, dynamic> json) =>
    LogbookSummaryModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      cadetNumber: json['cadetNumber'] as String,
      flightDate: DateTime.parse(json['flightDate'] as String),
      flightType: $enumDecode(_$FlightTypeEnumMap, json['flightType']),
      aircraftType: $enumDecode(_$AircraftTypeEnumMap, json['aircraftType']),
      aircraftRegistration: json['aircraftRegistration'] as String,
      aircraftModel: json['aircraftModel'] as String,
      departureLocation: json['departureLocation'] as String,
      arrivalLocation: json['arrivalLocation'] as String,
      flightDuration: (json['flightDuration'] as num).toDouble(),
      dayHours: (json['dayHours'] as num).toDouble(),
      nightHours: (json['nightHours'] as num).toDouble(),
      instrumentHours: (json['instrumentHours'] as num).toDouble(),
      crossCountryHours: (json['crossCountryHours'] as num).toDouble(),
      pilotInCommandHours: (json['pilotInCommandHours'] as num).toDouble(),
      dualReceivedHours: (json['dualReceivedHours'] as num).toDouble(),
      takeoffs: (json['takeoffs'] as num).toInt(),
      landings: (json['landings'] as num).toInt(),
      instructorId: json['instructorId'] as String?,
      instructorName: json['instructorName'] as String?,
      remarks: json['remarks'] as String,
      isSignedOff: json['isSignedOff'] as bool,
      signedOffBy: json['signedOffBy'] as String?,
      signedOffDate: json['signedOffDate'] == null
          ? null
          : DateTime.parse(json['signedOffDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      missionCode: json['missionCode'] as String,
      weatherConditions: json['weatherConditions'] as String?,
    );

Map<String, dynamic> _$LogbookSummaryModelToJson(
  LogbookSummaryModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'cadetNumber': instance.cadetNumber,
  'flightDate': instance.flightDate.toIso8601String(),
  'flightType': _$FlightTypeEnumMap[instance.flightType]!,
  'aircraftType': _$AircraftTypeEnumMap[instance.aircraftType]!,
  'aircraftRegistration': instance.aircraftRegistration,
  'aircraftModel': instance.aircraftModel,
  'departureLocation': instance.departureLocation,
  'arrivalLocation': instance.arrivalLocation,
  'flightDuration': instance.flightDuration,
  'dayHours': instance.dayHours,
  'nightHours': instance.nightHours,
  'instrumentHours': instance.instrumentHours,
  'crossCountryHours': instance.crossCountryHours,
  'pilotInCommandHours': instance.pilotInCommandHours,
  'dualReceivedHours': instance.dualReceivedHours,
  'takeoffs': instance.takeoffs,
  'landings': instance.landings,
  'instructorId': instance.instructorId,
  'instructorName': instance.instructorName,
  'remarks': instance.remarks,
  'isSignedOff': instance.isSignedOff,
  'signedOffBy': instance.signedOffBy,
  'signedOffDate': instance.signedOffDate?.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'missionCode': instance.missionCode,
  'weatherConditions': instance.weatherConditions,
};

const _$FlightTypeEnumMap = {
  FlightType.training: 'training',
  FlightType.solo: 'solo',
  FlightType.supervised: 'supervised',
  FlightType.evaluation: 'evaluation',
  FlightType.mission: 'mission',
};

const _$AircraftTypeEnumMap = {
  AircraftType.fixedWing: 'fixed_wing',
  AircraftType.rotaryWing: 'rotary_wing',
  AircraftType.glider: 'glider',
  AircraftType.simulator: 'simulator',
};
