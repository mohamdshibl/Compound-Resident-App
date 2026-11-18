import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserEntity?> getCurrentUser() {
    return remoteDataSource.getCurrentUser();
  }

  @override
  Future<UserEntity> loginWithEmailPassword({
    required String email,
    required String password,
  }) {
    return remoteDataSource.loginWithEmailPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<UserEntity> loginWithDemoAccount(UserRole role) {
    return remoteDataSource.loginWithDemoAccount(role);
  }

  @override
  Future<void> logout() {
    return remoteDataSource.logout();
  }

  @override
  Stream<UserEntity?> get authStateChanges => remoteDataSource.authStateChanges;
}
