import 'package:airman_toga_flutter_assessment/core/errors/exceptions.dart';
import '../../domain/entities/aircraft.dart';

abstract class AircraftService {
  Future<List<Aircraft>> getAircraftList();
  Future<Aircraft> getAircraftById(String id);
  Future<void> addAircraft(Aircraft aircraft);
  Future<void> updateAircraft(Aircraft aircraft);
  Future<void> deleteAircraft(String id);
}

class AircraftServiceImpl implements AircraftService {
  @override
  Future<List<Aircraft>> getAircraftList() async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Return mock data
    return [
      const Aircraft(
        id: '1',
        registration: 'N12345',
        model: 'Boeing 737-800',
        manufacturer: 'Boeing',
        capacity: 189,
        rangeKm: 5765,
        isActive: true,
      ),
      const Aircraft(
        id: '2',
        registration: 'N67890',
        model: 'Airbus A320',
        manufacturer: 'Airbus',
        capacity: 180,
        rangeKm: 6100,
        isActive: true,
      ),
    ];
  }

  @override
  Future<Aircraft> getAircraftById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final aircraftList = await getAircraftList();
    final aircraft = aircraftList.firstWhere(
      (a) => a.id == id,
      orElse: () => throw ServerException(
        message: 'Aircraft not found',
        statusCode: 404,
      ),
    );
    
    return aircraft;
  }

  @override
  Future<void> addAircraft(Aircraft aircraft) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Simulate API call
  }

  @override
  Future<void> updateAircraft(Aircraft aircraft) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Simulate API call
  }

  @override
  Future<void> deleteAircraft(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Simulate API call
  }
}
