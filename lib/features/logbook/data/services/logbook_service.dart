import 'package:airman_toga_flutter_assessment/core/network/api_client.dart';
import '../models/logbook_summary_model.dart';

abstract class LogbookService {
  Future<List<LogbookSummaryModel>> getLogbookEntries(String userId);
  Future<LogbookSummaryModel> getLogbookEntry(String entryId);
  Future<LogbookSummaryModel> addLogbookEntry(Map<String, dynamic> entryData);
  Future<LogbookSummaryModel> updateLogbookEntry(String entryId, Map<String, dynamic> updates);
  Future<void> deleteLogbookEntry(String entryId);
  Future<Map<String, double>> getTotalHours(String userId);
  Future<List<LogbookSummaryModel>> getEntriesByDateRange(String userId, DateTime start, DateTime end);
  Future<List<LogbookSummaryModel>> getEntriesByType(String userId, FlightType type);
}

class MockLogbookService implements LogbookService {
  final List<LogbookSummaryModel> _mockEntries = [];

  @override
  Future<List<LogbookSummaryModel>> getLogbookEntries(String userId) async {
    return ApiClient.simulateNetworkCall(() async {
      if (_mockEntries.isEmpty) {
        _initializeMockEntries(userId);
      }
      return _mockEntries.where((entry) => entry.userId == userId).toList();
    });
  }

  @override
  Future<LogbookSummaryModel> getLogbookEntry(String entryId) async {
    return ApiClient.simulateNetworkCall(() async {
      return _mockEntries.firstWhere((entry) => entry.id == entryId);
    });
  }

  @override
  Future<LogbookSummaryModel> addLogbookEntry(Map<String, dynamic> entryData) async {
    return ApiClient.simulateNetworkCall(() async {
      final newEntry = LogbookSummaryModel.validate(
        id: 'log_${DateTime.now().millisecondsSinceEpoch}',
        userId: entryData['userId'] as String,
        cadetNumber: entryData['cadetNumber'] as String,
        flightDate: DateTime.parse(entryData['flightDate'] as String),
        flightType: FlightType.values.firstWhere(
          (t) => t.name == entryData['flightType'] as String,
          orElse: () => FlightType.training,
        ),
        aircraftType: AircraftType.values.firstWhere(
          (t) => t.name == entryData['aircraftType'] as String,
          orElse: () => AircraftType.fixedWing,
        ),
        aircraftRegistration: entryData['aircraftRegistration'] as String,
        aircraftModel: entryData['aircraftModel'] as String,
        departureLocation: entryData['departureLocation'] as String,
        arrivalLocation: entryData['arrivalLocation'] as String,
        flightDuration: entryData['flightDuration'] as double,
        dayHours: entryData['dayHours'] as double,
        nightHours: entryData['nightHours'] as double,
        instrumentHours: entryData['instrumentHours'] as double,
        crossCountryHours: entryData['crossCountryHours'] as double,
        pilotInCommandHours: entryData['pilotInCommandHours'] as double,
        dualReceivedHours: entryData['dualReceivedHours'] as double,
        takeoffs: entryData['takeoffs'] as int,
        landings: entryData['landings'] as int,
        instructorId: entryData['instructorId'] as String?,
        instructorName: entryData['instructorName'] as String?,
        remarks: entryData['remarks'] as String,
        isSignedOff: false,
        signedOffBy: null,
        signedOffDate: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        missionCode: entryData['missionCode'] as String,
        weatherConditions: entryData['weatherConditions'] as String?,
      );
      _mockEntries.add(newEntry);
      return newEntry;
    });
  }

  @override
  Future<LogbookSummaryModel> updateLogbookEntry(String entryId, Map<String, dynamic> updates) async {
    return ApiClient.simulateNetworkCall(() async {
      final entry = await getLogbookEntry(entryId);
      final updatedEntry = LogbookSummaryModel.validate(
        id: entry.id,
        userId: entry.userId,
        cadetNumber: entry.cadetNumber,
        flightDate: updates['flightDate'] != null 
            ? DateTime.parse(updates['flightDate'] as String)
            : entry.flightDate,
        flightType: updates['flightType'] != null
            ? FlightType.values.firstWhere((t) => t.name == updates['flightType'] as String)
            : entry.flightType,
        aircraftType: updates['aircraftType'] != null
            ? AircraftType.values.firstWhere((t) => t.name == updates['aircraftType'] as String)
            : entry.aircraftType,
        aircraftRegistration: updates['aircraftRegistration'] as String? ?? entry.aircraftRegistration,
        aircraftModel: updates['aircraftModel'] as String? ?? entry.aircraftModel,
        departureLocation: updates['departureLocation'] as String? ?? entry.departureLocation,
        arrivalLocation: updates['arrivalLocation'] as String? ?? entry.arrivalLocation,
        flightDuration: updates['flightDuration'] as double? ?? entry.flightDuration,
        dayHours: updates['dayHours'] as double? ?? entry.dayHours,
        nightHours: updates['nightHours'] as double? ?? entry.nightHours,
        instrumentHours: updates['instrumentHours'] as double? ?? entry.instrumentHours,
        crossCountryHours: updates['crossCountryHours'] as double? ?? entry.crossCountryHours,
        pilotInCommandHours: updates['pilotInCommandHours'] as double? ?? entry.pilotInCommandHours,
        dualReceivedHours: updates['dualReceivedHours'] as double? ?? entry.dualReceivedHours,
        takeoffs: updates['takeoffs'] as int? ?? entry.takeoffs,
        landings: updates['landings'] as int? ?? entry.landings,
        instructorId: updates['instructorId'] as String? ?? entry.instructorId,
        instructorName: updates['instructorName'] as String? ?? entry.instructorName,
        remarks: updates['remarks'] as String? ?? entry.remarks,
        isSignedOff: updates['isSignedOff'] as bool? ?? entry.isSignedOff,
        signedOffBy: updates['isSignedOff'] == true ? (updates['signedOffBy'] as String?) : entry.signedOffBy,
        signedOffDate: updates['isSignedOff'] == true ? (updates['signedOffDate'] as DateTime?) : entry.signedOffDate,
        createdAt: entry.createdAt,
        updatedAt: DateTime.now(),
        missionCode: updates['missionCode'] as String? ?? entry.missionCode,
        weatherConditions: updates['weatherConditions'] as String? ?? entry.weatherConditions,
      );
      
      final index = _mockEntries.indexWhere((e) => e.id == entryId);
      _mockEntries[index] = updatedEntry;
      return updatedEntry;
    });
  }

  @override
  Future<void> deleteLogbookEntry(String entryId) async {
    await ApiClient.simulateNetworkCall(() async {
      _mockEntries.removeWhere((entry) => entry.id == entryId);
    });
  }

  @override
  Future<Map<String, double>> getTotalHours(String userId) async {
    return ApiClient.simulateNetworkCall(() async {
      final entries = await getLogbookEntries(userId);
      return {
        'totalFlightHours': entries.fold(0.0, (sum, e) => sum + e.flightDuration),
        'totalDayHours': entries.fold(0.0, (sum, e) => sum + e.dayHours),
        'totalNightHours': entries.fold(0.0, (sum, e) => sum + e.nightHours),
        'totalInstrumentHours': entries.fold(0.0, (sum, e) => sum + e.instrumentHours),
        'totalCrossCountryHours': entries.fold(0.0, (sum, e) => sum + e.crossCountryHours),
        'totalPilotInCommandHours': entries.fold(0.0, (sum, e) => sum + e.pilotInCommandHours),
        'totalDualReceivedHours': entries.fold(0.0, (sum, e) => sum + e.dualReceivedHours),
      };
    });
  }

  @override
  Future<List<LogbookSummaryModel>> getEntriesByDateRange(String userId, DateTime start, DateTime end) async {
    return ApiClient.simulateNetworkCall(() async {
      final allEntries = await getLogbookEntries(userId);
      return allEntries.where((entry) =>
          entry.flightDate.isAfter(start) && entry.flightDate.isBefore(end)
      ).toList();
    });
  }

  @override
  Future<List<LogbookSummaryModel>> getEntriesByType(String userId, FlightType type) async {
    return ApiClient.simulateNetworkCall(() async {
      final allEntries = await getLogbookEntries(userId);
      return allEntries.where((entry) => entry.flightType == type).toList();
    });
  }

  void _initializeMockEntries(String userId) {
    _mockEntries.addAll([
      LogbookSummaryModel.validate(
        id: 'log_001',
        userId: userId,
        cadetNumber: 'CAF-2024-001',
        flightDate: DateTime(2024, 3, 15),
        flightType: FlightType.training,
        aircraftType: AircraftType.fixedWing,
        aircraftRegistration: 'N12345',
        aircraftModel: 'Cessna 172',
        departureLocation: 'KABC',
        arrivalLocation: 'KXYZ',
        flightDuration: 2.5,
        dayHours: 2.5,
        nightHours: 0.0,
        instrumentHours: 0.5,
        crossCountryHours: 2.5,
        pilotInCommandHours: 0.0,
        dualReceivedHours: 2.5,
        takeoffs: 2,
        landings: 2,
        instructorId: 'inst_001',
        instructorName: 'Capt. Smith',
        remarks: 'Basic maneuvers practice',
        isSignedOff: true,
        signedOffBy: 'Capt. Smith',
        signedOffDate: DateTime(2024, 3, 16),
        createdAt: DateTime(2024, 3, 15),
        updatedAt: DateTime(2024, 3, 16),
        missionCode: 'TRN-001',
        weatherConditions: 'VFR',
      ),
      LogbookSummaryModel.validate(
        id: 'log_002',
        userId: userId,
        cadetNumber: 'CAF-2024-001',
        flightDate: DateTime(2024, 4, 10),
        flightType: FlightType.solo,
        aircraftType: AircraftType.fixedWing,
        aircraftRegistration: 'N12345',
        aircraftModel: 'Cessna 172',
        departureLocation: 'KABC',
        arrivalLocation: 'KABC',
        flightDuration: 1.5,
        dayHours: 1.5,
        nightHours: 0.0,
        instrumentHours: 0.0,
        crossCountryHours: 0.0,
        pilotInCommandHours: 1.5,
        dualReceivedHours: 0.0,
        takeoffs: 3,
        landings: 3,
        instructorId: null,
        instructorName: null,
        remarks: 'First solo flight - pattern work',
        isSignedOff: true,
        signedOffBy: 'Capt. Smith',
        signedOffDate: DateTime(2024, 4, 11),
        createdAt: DateTime(2024, 4, 10),
        updatedAt: DateTime(2024, 4, 11),
        missionCode: 'SOL-001',
        weatherConditions: 'VFR',
      ),
    ]);
  }
}
