enum UserRole {
  owner,
  tenant,
  security,
  maintenance,
  housekeeping,
  recreation,
  itSupport,
  finance,
  reception,
  administration,
  systemAdmin;

  static UserRole fromString(String? roleStr) {
    switch (roleStr?.toLowerCase().trim()) {
      case 'owner':
        return UserRole.owner;
      case 'tenant':
        return UserRole.tenant;
      case 'security':
        return UserRole.security;
      case 'maintenance':
        return UserRole.maintenance;
      case 'housekeeping':
        return UserRole.housekeeping;
      case 'recreation':
        return UserRole.recreation;
      case 'it_support':
      case 'itsupport':
      case 'it':
        return UserRole.itSupport;
      case 'finance':
        return UserRole.finance;
      case 'reception':
        return UserRole.reception;
      case 'administration':
      case 'admin':
        return UserRole.administration;
      case 'system_admin':
      case 'superadmin':
        return UserRole.systemAdmin;
      default:
        return UserRole.tenant;
    }
  }

  String toDbString() {
    switch (this) {
      case UserRole.owner:
        return 'owner';
      case UserRole.tenant:
        return 'tenant';
      case UserRole.security:
        return 'security';
      case UserRole.maintenance:
        return 'maintenance';
      case UserRole.housekeeping:
        return 'housekeeping';
      case UserRole.recreation:
        return 'recreation';
      case UserRole.itSupport:
        return 'it_support';
      case UserRole.finance:
        return 'finance';
      case UserRole.reception:
        return 'reception';
      case UserRole.administration:
        return 'administration';
      case UserRole.systemAdmin:
        return 'system_admin';
    }
  }

  bool get isResident => this == UserRole.owner || this == UserRole.tenant;
  bool get isEmployee => !isResident;

  String get displayNameEn {
    switch (this) {
      case UserRole.owner:
        return 'Property Owner';
      case UserRole.tenant:
        return 'Resident Tenant';
      case UserRole.security:
        return 'Security Officer';
      case UserRole.maintenance:
        return 'Maintenance Engineer';
      case UserRole.housekeeping:
        return 'Housekeeping Supervisor';
      case UserRole.recreation:
        return 'Recreation Manager';
      case UserRole.itSupport:
        return 'IT Helpdesk Specialist';
      case UserRole.finance:
        return 'Finance Officer';
      case UserRole.reception:
        return 'Front Desk Concierge';
      case UserRole.administration:
        return 'Compound Administrator';
      case UserRole.systemAdmin:
        return 'System Administrator';
    }
  }

  String get displayNameAr {
    switch (this) {
      case UserRole.owner:
        return 'مالك عقار';
      case UserRole.tenant:
        return 'ساكن مستأجر';
      case UserRole.security:
        return 'أمن وبوابات';
      case UserRole.maintenance:
        return 'مهندس الصيانة';
      case UserRole.housekeeping:
        return 'مشرفة النظافة';
      case UserRole.recreation:
        return 'إدارة المرافق والترفيه';
      case UserRole.itSupport:
        return 'الدعم الفني والتقني';
      case UserRole.finance:
        return 'القسم المالي';
      case UserRole.reception:
        return 'الاستقبال والضيافة';
      case UserRole.administration:
        return 'إدارة المجمع';
      case UserRole.systemAdmin:
        return 'مدير النظام';
    }
  }
}

class UserEntity {
  final String id;
  final String email;
  final String fullName;
  final String fullNameAr;
  final String phone;
  final UserRole role;
  final String? department;
  final String compoundId;
  final String compoundName;
  final List<String> authorizedUnitIds;
  final String? primaryUnitNumber;
  final String? avatarUrl;
  final bool isActive;

  const UserEntity({
    required this.id,
    required this.email,
    required this.fullName,
    this.fullNameAr = '',
    required this.phone,
    required this.role,
    this.department,
    required this.compoundId,
    this.compoundName = 'Al-Nakheel Prestige Living',
    this.authorizedUnitIds = const [],
    this.primaryUnitNumber,
    this.avatarUrl,
    this.isActive = true,
  });

  bool get isResident => role.isResident;
  bool get isEmployee => role.isEmployee;
}
