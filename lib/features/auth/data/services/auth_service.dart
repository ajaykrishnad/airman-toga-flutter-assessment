import 'package:airman_toga_flutter_assessment/core/network/api_client.dart';
import '../models/cadet_profile_model.dart';

abstract class AuthService {
  Future<CadetProfileModel> login(String email, String password);
  Future<CadetProfileModel> register(Map<String, dynamic> userData);
  Future<CadetProfileModel> getProfile(String userId);
  Future<CadetProfileModel> updateProfile(String userId, Map<String, dynamic> updates);
  Future<void> logout();
  Future<bool> isAuthenticated();
}

class MockAuthService implements AuthService {
  @override
  Future<CadetProfileModel> login(String email, String password) async {
    return ApiClient.simulateNetworkCall(() async {
      // Mock login logic - return Arjun Menon profile
      return CadetProfileModel.validate(
        id: 'user_arjun_menon',
        firstName: 'Arjun',
        lastName: 'Menon',
        email: email,
        cadetNumber: 'CAF-2024-001',
        rank: 'Cadet',
        squadron: 'Alpha Squadron',
        dateOfBirth: DateTime(2000, 1, 15),
        enrollmentDate: DateTime(2024, 1, 1),
        isActive: true,
        totalFlightHours: 45.5,
        completedMissions: 12,
        currentPhase: 'Phase 2',
        certifications: ['Basic Flight', 'Navigation'],
        lastUpdated: DateTime.now(),
      );
    });
  }

  @override
  Future<CadetProfileModel> register(Map<String, dynamic> userData) async {
    return ApiClient.simulateNetworkCall(() async {
      return CadetProfileModel.validate(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        firstName: userData['firstName'] as String,
        lastName: userData['lastName'] as String,
        email: userData['email'] as String,
        phoneNumber: userData['phoneNumber'] as String?,
        cadetNumber: userData['cadetNumber'] as String,
        rank: userData['rank'] as String,
        squadron: userData['squadron'] as String,
        dateOfBirth: DateTime.parse(userData['dateOfBirth'] as String),
        enrollmentDate: DateTime.now(),
        isActive: true,
        totalFlightHours: 0,
        completedMissions: 0,
        currentPhase: 'Phase 1',
        certifications: [],
        lastUpdated: DateTime.now(),
      );
    });
  }

  @override
  Future<CadetProfileModel> getProfile(String userId) async {
    return ApiClient.simulateNetworkCall(() async {
      return CadetProfileModel.validate(
        id: userId,
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@academy.air',
        cadetNumber: 'CAF-2024-001',
        rank: 'Cadet',
        squadron: 'Alpha Squadron',
        dateOfBirth: DateTime(2000, 1, 15),
        enrollmentDate: DateTime(2024, 1, 1),
        isActive: true,
        totalFlightHours: 45.5,
        completedMissions: 12,
        currentPhase: 'Phase 2',
        certifications: ['Basic Flight', 'Navigation'],
        lastUpdated: DateTime.now(),
      );
    });
  }

  @override
  Future<CadetProfileModel> updateProfile(String userId, Map<String, dynamic> updates) async {
    return ApiClient.simulateNetworkCall(() async {
      final currentProfile = await getProfile(userId);
      return CadetProfileModel.validate(
        id: currentProfile.id,
        firstName: updates['firstName'] as String? ?? currentProfile.firstName,
        lastName: updates['lastName'] as String? ?? currentProfile.lastName,
        email: updates['email'] as String? ?? currentProfile.email,
        phoneNumber: updates['phoneNumber'] as String? ?? currentProfile.phoneNumber,
        cadetNumber: currentProfile.cadetNumber,
        rank: updates['rank'] as String? ?? currentProfile.rank,
        squadron: updates['squadron'] as String? ?? currentProfile.squadron,
        dateOfBirth: currentProfile.dateOfBirth,
        enrollmentDate: currentProfile.enrollmentDate,
        profileImageUrl: updates['profileImageUrl'] as String? ?? currentProfile.profileImageUrl,
        isActive: currentProfile.isActive,
        totalFlightHours: currentProfile.totalFlightHours,
        completedMissions: currentProfile.completedMissions,
        currentPhase: currentProfile.currentPhase,
        certifications: currentProfile.certifications,
        lastUpdated: DateTime.now(),
      );
    });
  }

  @override
  Future<void> logout() async {
    await ApiClient.simulateNetworkCall(() async {});
  }

  @override
  Future<bool> isAuthenticated() async {
    return ApiClient.simulateNetworkCall(() async => true);
  }
}
