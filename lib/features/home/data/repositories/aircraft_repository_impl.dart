import 'package:airman_toga_flutter_assessment/core/errors/exceptions.dart';
import 'package:airman_toga_flutter_assessment/core/errors/failures.dart';
import 'package:airman_toga_flutter_assessment/core/utils/either.dart';
import '../../domain/entities/aircraft.dart';
import '../../domain/repositories/aircraft_repository.dart';
import '../services/aircraft_service.dart';

class AircraftRepositoryImpl implements AircraftRepository {
  final AircraftService service;

  AircraftRepositoryImpl({required this.service});

  @override
  Future<Either<Failure, List<Aircraft>>> getAircraftList() async {
    try {
      final aircraftList = await service.getAircraftList();
      return Either.right(aircraftList);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Either.left(NetworkFailure(message: e.message));
    } catch (e) {
      return Either.left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Aircraft>> getAircraftById(String id) async {
    try {
      final aircraft = await service.getAircraftById(id);
      return Either.right(aircraft);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Either.left(NetworkFailure(message: e.message));
    } catch (e) {
      return Either.left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addAircraft(Aircraft aircraft) async {
    try {
      await service.addAircraft(aircraft);
      return Either.right(null);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Either.left(NetworkFailure(message: e.message));
    } catch (e) {
      return Either.left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateAircraft(Aircraft aircraft) async {
    try {
      await service.updateAircraft(aircraft);
      return Either.right(null);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Either.left(NetworkFailure(message: e.message));
    } catch (e) {
      return Either.left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAircraft(String id) async {
    try {
      await service.deleteAircraft(id);
      return Either.right(null);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Either.left(NetworkFailure(message: e.message));
    } catch (e) {
      return Either.left(UnknownFailure(message: e.toString()));
    }
  }
}
