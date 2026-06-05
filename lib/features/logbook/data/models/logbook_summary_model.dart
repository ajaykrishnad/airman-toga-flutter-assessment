import 'package:json_annotation/json_annotation.dart';
import 'package:airman_toga_flutter_assessment/core/utils/type_defs.dart';

part 'logbook_summary_model.g.dart';

enum FlightType {
  @JsonValue('training')
  training,
  @JsonValue('solo')
  solo,
  @JsonValue('supervised')
  supervised,
  @JsonValue('evaluation')
  evaluation,
  @JsonValue('mission')
  mission,
}

enum AircraftType {
  @JsonValue('fixed_wing')
  fixedWing,
  @JsonValue('rotary_wing')
  rotaryWing,
  @JsonValue('glider')
  glider,
  @JsonValue('simulator')
  simulator,
}

@JsonSerializable()
class LogbookSummaryModel {
  final String id;
  final String userId;
  final String cadetNumber;
  @JsonKey(name: 'flightDate')
  final DateTime flightDate;
  final FlightType flightType;
  final AircraftType aircraftType;
  final String aircraftRegistration;
  final String aircraftModel;
  @JsonKey(name: 'departureLocation')
  final String departureLocation;
  @JsonKey(name: 'arrivalLocation')
  final String arrivalLocation;
  @JsonKey(name: 'flightDuration')
  final double flightDuration;
  @JsonKey(name: 'dayHours')
  final double dayHours;
  @JsonKey(name: 'nightHours')
  final double nightHours;
  @JsonKey(name: 'instrumentHours')
  final double instrumentHours;
  @JsonKey(name: 'crossCountryHours')
  final double crossCountryHours;
  @JsonKey(name: 'pilotInCommandHours')
  final double pilotInCommandHours;
  @JsonKey(name: 'dualReceivedHours')
  final double dualReceivedHours;
  @JsonKey(name: 'takeoffs')
  final int takeoffs;
  @JsonKey(name: 'landings')
  final int landings;
  @JsonKey(name: 'instructorId')
  final String? instructorId;
  final String? instructorName;
  final String remarks;
  final bool isSignedOff;
  @JsonKey(name: 'signedOffBy')
  final String? signedOffBy;
  @JsonKey(name: 'signedOffDate')
  final DateTime? signedOffDate;
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  @JsonKey(name: 'updatedAt')
  final DateTime updatedAt;
  final String missionCode;
  final String? weatherConditions;

  const LogbookSummaryModel({
    required this.id,
    required this.userId,
    required this.cadetNumber,
    required this.flightDate,
    required this.flightType,
    required this.aircraftType,
    required this.aircraftRegistration,
    required this.aircraftModel,
    required this.departureLocation,
    required this.arrivalLocation,
    required this.flightDuration,
    required this.dayHours,
    required this.nightHours,
    required this.instrumentHours,
    required this.crossCountryHours,
    required this.pilotInCommandHours,
    required this.dualReceivedHours,
    required this.takeoffs,
    required this.landings,
    this.instructorId,
    this.instructorName,
    required this.remarks,
    required this.isSignedOff,
    this.signedOffBy,
    this.signedOffDate,
    required this.createdAt,
    required this.updatedAt,
    required this.missionCode,
    this.weatherConditions,
  });

  // Assertions for data integrity
  factory LogbookSummaryModel.validate({
    required String id,
    required String userId,
    required String cadetNumber,
    required DateTime flightDate,
    required FlightType flightType,
    required AircraftType aircraftType,
    required String aircraftRegistration,
    required String aircraftModel,
    required String departureLocation,
    required String arrivalLocation,
    required double flightDuration,
    required double dayHours,
    required double nightHours,
    required double instrumentHours,
    required double crossCountryHours,
    required double pilotInCommandHours,
    required double dualReceivedHours,
    required int takeoffs,
    required int landings,
    String? instructorId,
    String? instructorName,
    required String remarks,
    required bool isSignedOff,
    String? signedOffBy,
    DateTime? signedOffDate,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String missionCode,
    String? weatherConditions,
  }) {
    assert(userId.isNotEmpty, 'User ID cannot be empty');
    assert(cadetNumber.isNotEmpty, 'Cadet number cannot be empty');
    assert(aircraftRegistration.isNotEmpty, 'Aircraft registration cannot be empty');
    assert(aircraftModel.isNotEmpty, 'Aircraft model cannot be empty');
    assert(departureLocation.isNotEmpty, 'Departure location cannot be empty');
    assert(arrivalLocation.isNotEmpty, 'Arrival location cannot be empty');
    assert(flightDuration > 0, 'Flight duration must be greater than 0');
    assert(dayHours >= 0, 'Day hours cannot be negative');
    assert(nightHours >= 0, 'Night hours cannot be negative');
    assert(instrumentHours >= 0, 'Instrument hours cannot be negative');
    assert(crossCountryHours >= 0, 'Cross country hours cannot be negative');
    assert(pilotInCommandHours >= 0, 'Pilot in command hours cannot be negative');
    assert(dualReceivedHours >= 0, 'Dual received hours cannot be negative');
    assert((dayHours + nightHours) == flightDuration, 
           'Day hours + night hours must equal flight duration');
    assert(takeoffs >= 0, 'Takeoffs cannot be negative');
    assert(landings >= 0, 'Landings cannot be negative');
    assert(takeoffs == landings, 'Takeoffs must equal landings');
    assert(missionCode.isNotEmpty, 'Mission code cannot be empty');
    assert(updatedAt.isAtSameMomentAs(createdAt) || updatedAt.isAfter(createdAt), 
           'Updated date must be after or equal to created date');
    
    // Validate instructor requirements for certain flight types
    if (flightType == FlightType.training || flightType == FlightType.supervised) {
      assert(instructorId != null, 'Instructor ID is required for training/supervised flights');
      assert(instructorName != null, 'Instructor name is required for training/supervised flights');
    }
    
    // Validate sign-off consistency
    if (isSignedOff) {
      assert(signedOffBy != null, 'Signed off by is required when flight is signed off');
      assert(signedOffDate != null, 'Signed off date is required when flight is signed off');
    }

    return LogbookSummaryModel(
      id: id,
      userId: userId,
      cadetNumber: cadetNumber,
      flightDate: flightDate,
      flightType: flightType,
      aircraftType: aircraftType,
      aircraftRegistration: aircraftRegistration,
      aircraftModel: aircraftModel,
      departureLocation: departureLocation,
      arrivalLocation: arrivalLocation,
      flightDuration: flightDuration,
      dayHours: dayHours,
      nightHours: nightHours,
      instrumentHours: instrumentHours,
      crossCountryHours: crossCountryHours,
      pilotInCommandHours: pilotInCommandHours,
      dualReceivedHours: dualReceivedHours,
      takeoffs: takeoffs,
      landings: landings,
      instructorId: instructorId,
      instructorName: instructorName,
      remarks: remarks,
      isSignedOff: isSignedOff,
      signedOffBy: signedOffBy,
      signedOffDate: signedOffDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
      missionCode: missionCode,
      weatherConditions: weatherConditions,
    );
  }

  factory LogbookSummaryModel.fromJson(JsonMap json) => _$LogbookSummaryModelFromJson(json);

  JsonMap toJson() => _$LogbookSummaryModelToJson(this);

  // Computed properties
  String get flightTypeText {
    switch (flightType) {
      case FlightType.training:
        return 'Training';
      case FlightType.solo:
        return 'Solo';
      case FlightType.supervised:
        return 'Supervised';
      case FlightType.evaluation:
        return 'Evaluation';
      case FlightType.mission:
        return 'Mission';
    }
  }

  String get aircraftTypeText {
    switch (aircraftType) {
      case AircraftType.fixedWing:
        return 'Fixed Wing';
      case AircraftType.rotaryWing:
        return 'Rotary Wing';
      case AircraftType.glider:
        return 'Glider';
      case AircraftType.simulator:
        return 'Simulator';
    }
  }

  bool get isNightFlight => nightHours > 0;
  
  bool get isInstrumentFlight => instrumentHours > 0;
  
  bool get isCrossCountry => crossCountryHours > 0;
  
  bool get isSoloFlight => flightType == FlightType.solo;
  
  bool get requiresInstructor => flightType == FlightType.training || 
                                 flightType == FlightType.supervised;
  
  bool get isComplete => isSignedOff;
  
  String get flightCategory {
    if (isNightFlight && isInstrumentFlight) return 'Night Instrument';
    if (isNightFlight) return 'Night';
    if (isInstrumentFlight) return 'Instrument';
    if (isCrossCountry) return 'Cross Country';
    return 'Local';
  }
}
