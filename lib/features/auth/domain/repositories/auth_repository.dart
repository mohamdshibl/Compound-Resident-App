import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> getCurrentUser();
  Future<UserEntity> loginWithEmailPassword({
    required String email,
    required String password,
  });
  Future<UserEntity> loginWithDemoAccount(UserRole role);
  Future<void> logout();
  Stream<UserEntity?> get authStateChanges;
}
