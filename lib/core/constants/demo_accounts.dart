import '../../features/auth/domain/entities/user_entity.dart';

class DemoAccount {
  final String email;
  final String password;
  final UserEntity user;
  final String subtitle;
  final String subtitleAr;
  final String icon;

  const DemoAccount({
    required this.email,
    required this.password,
    required this.user,
    required this.subtitle,
    required this.subtitleAr,
    required this.icon,
  });

  String localizedSubtitle(bool isAr) => isAr ? subtitleAr : subtitle;
}

class DemoAccounts {
  static const String defaultPassword = 'Password123!';

  static final List<DemoAccount> list = [
    // 1. Owner
    const DemoAccount(
      email: 'owner@compound.demo',
      password: defaultPassword,
      subtitle: 'Villa V-104 • Full Owner Privileges',
      subtitleAr: 'فيلا V-104 • صلاحيات المالك الكاملة',
      icon: '🏛️',
      user: UserEntity(
        id: 'usr_owner_tarek',
        email: 'owner@compound.demo',
        fullName: 'Dr. Tarek Mansour',
        fullNameAr: 'د. طارق منصور',
        phone: '+966 50 123 4567',
        role: UserRole.owner,
        compoundId: 'compound_al_mohamedia',
        compoundName: 'Al-Mohamedia Compound',
        authorizedUnitIds: ['unit_v104'],
        primaryUnitNumber: 'V-104',
        avatarUrl:
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80',
      ),
    ),

    // 2. Tenant
    const DemoAccount(
      email: 'tenant@compound.demo',
      password: defaultPassword,
      subtitle: 'Apartment B2-301 • Resident Services',
      subtitleAr: 'شقة B2-301 • خدمات السكان',
      icon: '🏠',
      user: UserEntity(
        id: 'usr_tenant_sara',
        email: 'tenant@compound.demo',
        fullName: 'Sara Al-Husseini',
        fullNameAr: 'سارة الحسيني',
        phone: '+966 55 987 6543',
        role: UserRole.tenant,
        compoundId: 'compound_al_mohamedia',
        compoundName: 'Al-Mohamedia Compound',
        authorizedUnitIds: ['unit_b2_301'],
        primaryUnitNumber: 'B2-301',
        avatarUrl:
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=300&q=80',
      ),
    ),

    // 3. Security
    const DemoAccount(
      email: 'security@compound.demo',
      password: defaultPassword,
      subtitle: 'Main Gate 1 • Visitor Entry & Plate Search',
      subtitleAr: 'البوابة الرئيسية ١ • دخول الزوار والبحث باللوحات',
      icon: '🛡️',
      user: UserEntity(
        id: 'usr_sec_ahmed',
        email: 'security@compound.demo',
        fullName: 'Capt. Ahmed Al-Otaibi',
        fullNameAr: 'النقيب أحمد العتيبي',
        phone: '+966 50 333 4455',
        role: UserRole.security,
        department: 'security',
        compoundId: 'compound_al_mohamedia',
        compoundName: 'Al-Mohamedia Compound',
        avatarUrl:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=300&q=80',
      ),
    ),

    // 4. Maintenance
    const DemoAccount(
      email: 'maintenance@compound.demo',
      password: defaultPassword,
      subtitle: 'Facility Maintenance • Work Orders & Dispatch',
      subtitleAr: 'صيانة المرافق • أوامر العمل وتوزيع الفنيين',
      icon: '🔧',
      user: UserEntity(
        id: 'usr_maint_hassan',
        email: 'maintenance@compound.demo',
        fullName: 'Eng. Hassan Al-Najjar',
        fullNameAr: 'م. حسن النجار',
        phone: '+966 54 222 1100',
        role: UserRole.maintenance,
        department: 'maintenance',
        compoundId: 'compound_al_mohamedia',
        compoundName: 'Al-Mohamedia Compound',
        avatarUrl:
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=300&q=80',
      ),
    ),

    // 5. Housekeeping
    const DemoAccount(
      email: 'housekeeping@compound.demo',
      password: defaultPassword,
      subtitle: 'Housekeeping & Cleaning Operations',
      subtitleAr: 'عمليات النظافة المنزلية والخدمات الفندقية',
      icon: '🧹',
      user: UserEntity(
        id: 'usr_hk_maria',
        email: 'housekeeping@compound.demo',
        fullName: 'Maria Santos',
        fullNameAr: 'ماريا سانتوس',
        phone: '+966 56 777 8899',
        role: UserRole.housekeeping,
        department: 'housekeeping',
        compoundId: 'compound_al_mohamedia',
        compoundName: 'Al-Mohamedia Compound',
        avatarUrl:
            'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=300&q=80',
      ),
    ),

    // 6. Recreation
    const DemoAccount(
      email: 'recreation@compound.demo',
      password: defaultPassword,
      subtitle: 'Clubhouse, Gym & Padel Courts Manager',
      subtitleAr: 'إدارة النادي الاجتماعي والصالة الرياضية وملاعب البادل',
      icon: '🎾',
      user: UserEntity(
        id: 'usr_rec_karim',
        email: 'recreation@compound.demo',
        fullName: 'Coach Karim Zaki',
        fullNameAr: 'كريم زكي',
        phone: '+966 59 111 2233',
        role: UserRole.recreation,
        department: 'recreation',
        compoundId: 'compound_al_mohamedia',
        compoundName: 'Al-Mohamedia Compound',
        avatarUrl:
            'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?auto=format&fit=crop&w=300&q=80',
      ),
    ),

    // 7. IT Support
    const DemoAccount(
      email: 'it@compound.demo',
      password: defaultPassword,
      subtitle: 'Network, Smart Home & Technical Tickets',
      subtitleAr: 'الشبكات والمنزل الذكي والتذاكر التقنية',
      icon: '💻',
      user: UserEntity(
        id: 'usr_it_omar',
        email: 'it@compound.demo',
        fullName: 'Omar Al-Ghamdi',
        fullNameAr: 'عمر الغامدي',
        phone: '+966 55 444 3322',
        role: UserRole.itSupport,
        department: 'it_support',
        compoundId: 'compound_al_mohamedia',
        compoundName: 'Al-Mohamedia Compound',
        avatarUrl:
            'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?auto=format&fit=crop&w=300&q=80',
      ),
    ),

    // 8. Administration
    const DemoAccount(
      email: 'admin@compound.demo',
      password: defaultPassword,
      subtitle: 'Compound Director & Executive Complaints',
      subtitleAr: 'إدارة المجمع والشكاوى التنفيذية',
      icon: '👔',
      user: UserEntity(
        id: 'usr_adm_laila',
        email: 'admin@compound.demo',
        fullName: 'Laila Al-Qahtani',
        fullNameAr: 'ليلى القحطاني',
        phone: '+966 50 888 9900',
        role: UserRole.administration,
        department: 'administration',
        compoundId: 'compound_al_mohamedia',
        compoundName: 'Al-Mohamedia Compound',
        avatarUrl:
            'https://images.unsplash.com/photo-1580489944761-15a19d654956?auto=format&fit=crop&w=300&q=80',
      ),
    ),

    // 9. System Administrator
    const DemoAccount(
      email: 'superadmin@compound.demo',
      password: defaultPassword,
      subtitle: 'System Settings, Multi-Compound & Seeds',
      subtitleAr: 'إعدادات النظام وتعدد المجمعات والبيانات التجريبية',
      icon: '⚙️',
      user: UserEntity(
        id: 'usr_sys_super',
        email: 'superadmin@compound.demo',
        fullName: 'System Administrator',
        fullNameAr: 'مدير النظام الرئيسي',
        phone: '+966 50 000 0000',
        role: UserRole.systemAdmin,
        compoundId: 'compound_al_mohamedia',
        compoundName: 'Al-Mohamedia Compound',
        avatarUrl:
            'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=300&q=80',
      ),
    ),
  ];

  static DemoAccount? findByEmail(String email) {
    try {
      return list.firstWhere(
        (a) => a.email.toLowerCase() == email.toLowerCase().trim(),
      );
    } catch (_) {
      return null;
    }
  }
}
