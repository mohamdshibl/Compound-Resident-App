import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.fullName,
    super.fullNameAr,
    required super.phone,
    required super.role,
    super.department,
    required super.compoundId,
    super.compoundName,
    super.authorizedUnitIds,
    super.primaryUnitNumber,
    super.avatarUrl,
    super.isActive,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return UserModel(
      id: id ?? json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      fullNameAr: json['fullNameAr'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      role: UserRole.fromString(json['role'] as String?),
      department: json['department'] as String?,
      compoundId: json['compoundId'] as String? ?? 'compound_al_nakheel',
      compoundName: json['compoundName'] as String? ?? 'Al-Nakheel Prestige Living',
      authorizedUnitIds: (json['authorizedUnitIds'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      primaryUnitNumber: json['primaryUnitNumber'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'fullNameAr': fullNameAr,
      'phone': phone,
      'role': role.toDbString(),
      'department': department,
      'compoundId': compoundId,
      'compoundName': compoundName,
      'authorizedUnitIds': authorizedUnitIds,
      'primaryUnitNumber': primaryUnitNumber,
      'avatarUrl': avatarUrl,
      'isActive': isActive,
    };
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      fullName: entity.fullName,
      fullNameAr: entity.fullNameAr,
      phone: entity.phone,
      role: entity.role,
      department: entity.department,
      compoundId: entity.compoundId,
      compoundName: entity.compoundName,
      authorizedUnitIds: entity.authorizedUnitIds,
      primaryUnitNumber: entity.primaryUnitNumber,
      avatarUrl: entity.avatarUrl,
      isActive: entity.isActive,
    );
  }
}
