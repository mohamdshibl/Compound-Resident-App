import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;
  const LoginUseCase(this.repository);

  Future<UserEntity> call({required String email, required String password}) {
    return repository.loginWithEmailPassword(email: email, password: password);
  }
}

class LoginDemoUseCase {
  final AuthRepository repository;
  const LoginDemoUseCase(this.repository);

  Future<UserEntity> call(UserRole role) {
    return repository.loginWithDemoAccount(role);
  }
}

class LogoutUseCase {
  final AuthRepository repository;
  const LogoutUseCase(this.repository);

  Future<void> call() {
    return repository.logout();
  }
}

class GetCurrentUserUseCase {
  final AuthRepository repository;
  const GetCurrentUserUseCase(this.repository);

  Future<UserEntity?> call() {
    return repository.getCurrentUser();
  }
}
