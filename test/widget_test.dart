import 'package:flutter_test/flutter_test.dart';
import 'package:compound_resident/features/auth/domain/entities/user_entity.dart';

void main() {
  test('UserRole parsing smoke test', () {
    expect(UserRole.fromString('owner'), UserRole.owner);
    expect(UserRole.fromString('security'), UserRole.security);
    expect(UserRole.fromString('maintenance'), UserRole.maintenance);
    expect(UserRole.fromString('unknown'), UserRole.tenant);
  });
}
