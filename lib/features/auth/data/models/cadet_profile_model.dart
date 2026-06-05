import 'package:json_annotation/json_annotation.dart';
import 'package:airman_toga_flutter_assessment/core/utils/type_defs.dart';

part 'cadet_profile_model.g.dart';

@JsonSerializable()
class CadetProfileModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phoneNumber;
  final String cadetNumber;
  final String rank;
  final String squadron;
  @JsonKey(name: 'dateOfBirth')
  final DateTime dateOfBirth;
  @JsonKey(name: 'enrollmentDate')
  final DateTime enrollmentDate;
  final String? profileImageUrl;
  final bool isActive;
  @JsonKey(name: 'totalFlightHours')
  final double totalFlightHours;
  @JsonKey(name: 'completedMissions')
  final int completedMissions;
  @JsonKey(name: 'currentPhase')
  final String currentPhase;
  final List<String> certifications;
  @JsonKey(name: 'lastUpdated')
  final DateTime lastUpdated;

  const CadetProfileModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phoneNumber,
    required this.cadetNumber,
    required this.rank,
    required this.squadron,
    required this.dateOfBirth,
    required this.enrollmentDate,
    this.profileImageUrl,
    required this.isActive,
    required this.totalFlightHours,
    required this.completedMissions,
    required this.currentPhase,
    required this.certifications,
    required this.lastUpdated,
  });

  // Assertions for data integrity
  factory CadetProfileModel.validate({
    required String id,
    required String firstName,
    required String lastName,
    required String email,
    String? phoneNumber,
    required String cadetNumber,
    required String rank,
    required String squadron,
    required DateTime dateOfBirth,
    required DateTime enrollmentDate,
    String? profileImageUrl,
    required bool isActive,
    required double totalFlightHours,
    required int completedMissions,
    required String currentPhase,
    required List<String> certifications,
    required DateTime lastUpdated,
  }) {
    assert(firstName.isNotEmpty, 'First name cannot be empty');
    assert(lastName.isNotEmpty, 'Last name cannot be empty');
    assert(email.contains('@'), 'Invalid email format');
    assert(cadetNumber.isNotEmpty, 'Cadet number cannot be empty');
    assert(rank.isNotEmpty, 'Rank cannot be empty');
    assert(squadron.isNotEmpty, 'Squadron cannot be empty');
    assert(totalFlightHours >= 0, 'Total flight hours cannot be negative');
    assert(completedMissions >= 0, 'Completed missions cannot be negative');
    assert(currentPhase.isNotEmpty, 'Current phase cannot be empty');
    assert(certifications.every((c) => c.isNotEmpty), 'Certifications cannot be empty strings');
    assert(dateOfBirth.isBefore(DateTime.now()), 'Date of birth must be in the past');
    assert(enrollmentDate.isBefore(DateTime.now()) || enrollmentDate.isAtSameMomentAs(DateTime.now()), 
           'Enrollment date must be today or in the past');

    return CadetProfileModel(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
      cadetNumber: cadetNumber,
      rank: rank,
      squadron: squadron,
      dateOfBirth: dateOfBirth,
      enrollmentDate: enrollmentDate,
      profileImageUrl: profileImageUrl,
      isActive: isActive,
      totalFlightHours: totalFlightHours,
      completedMissions: completedMissions,
      currentPhase: currentPhase,
      certifications: certifications,
      lastUpdated: lastUpdated,
    );
  }

  factory CadetProfileModel.fromJson(JsonMap json) => _$CadetProfileModelFromJson(json);

  JsonMap toJson() => _$CadetProfileModelToJson(this);

  // Computed properties
  String get fullName => '$firstName $lastName';
  
  String get initials => '${firstName[0]}${lastName[0]}'.toUpperCase();
  
  int get age {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month || 
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  bool get isSeniorCadet => completedMissions >= 50;
  
  bool get isJuniorCadet => completedMissions < 50;
}
