// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cadet_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CadetProfileModel _$CadetProfileModelFromJson(Map<String, dynamic> json) =>
    CadetProfileModel(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      cadetNumber: json['cadetNumber'] as String,
      rank: json['rank'] as String,
      squadron: json['squadron'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      enrollmentDate: DateTime.parse(json['enrollmentDate'] as String),
      profileImageUrl: json['profileImageUrl'] as String?,
      isActive: json['isActive'] as bool,
      totalFlightHours: (json['totalFlightHours'] as num).toDouble(),
      completedMissions: (json['completedMissions'] as num).toInt(),
      currentPhase: json['currentPhase'] as String,
      certifications: (json['certifications'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$CadetProfileModelToJson(CadetProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'cadetNumber': instance.cadetNumber,
      'rank': instance.rank,
      'squadron': instance.squadron,
      'dateOfBirth': instance.dateOfBirth.toIso8601String(),
      'enrollmentDate': instance.enrollmentDate.toIso8601String(),
      'profileImageUrl': instance.profileImageUrl,
      'isActive': instance.isActive,
      'totalFlightHours': instance.totalFlightHours,
      'completedMissions': instance.completedMissions,
      'currentPhase': instance.currentPhase,
      'certifications': instance.certifications,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };
