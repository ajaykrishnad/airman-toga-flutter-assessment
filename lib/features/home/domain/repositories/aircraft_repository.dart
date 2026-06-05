import 'package:airman_toga_flutter_assessment/core/errors/failures.dart';
import 'package:airman_toga_flutter_assessment/core/utils/either.dart';
import '../entities/aircraft.dart';

abstract class AircraftRepository {
  Future<Either<Failure, List<Aircraft>>> getAircraftList();
  Future<Either<Failure, Aircraft>> getAircraftById(String id);
  Future<Either<Failure, void>> addAircraft(Aircraft aircraft);
  Future<Either<Failure, void>> updateAircraft(Aircraft aircraft);
  Future<Either<Failure, void>> deleteAircraft(String id);
}
