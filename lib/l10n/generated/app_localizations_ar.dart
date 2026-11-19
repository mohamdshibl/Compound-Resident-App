// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'مجمع المحمدية';

  @override
  String get compoundName => 'مجمع المحمدية';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get switchLanguage => 'تغيير اللغة';

  @override
  String get languageToggleLabel => 'EN';

  @override
  String get cancel => 'إلغاء';

  @override
  String get emailAddress => 'البريد الإلكتروني';

  @override
  String get emailHint => 'name@compound.demo';

  @override
  String get emailRequired => 'يرجى إدخال البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get passwordRequired => 'يرجى إدخال كلمة المرور';

  @override
  String get signInToResidence => 'تسجيل الدخول للمجمع';

  @override
  String get quickDemoIdentities => 'حسابات التجربة السريعة (٩ أدوار)';

  @override
  String get instantDemoAccess => 'دخول تجريبي فوري';

  @override
  String get instantDemoSubtitle =>
      'اختر أي دور أدناه لتجربة لوحة التحكم الخاصة به فوراً.';

  @override
  String get residentIdentities => 'حسابات السكان والملاك';

  @override
  String get departmentEmployeeIdentities => 'حسابات الأقسام والموظفين';

  @override
  String get residentFallbackName => 'ساكن';

  @override
  String get ownerBadge => 'مالك';

  @override
  String get tenantBadge => 'مستأجر';

  @override
  String unitAuthorizedResidence(String unit) {
    return 'وحدة $unit • سكن معتمد';
  }

  @override
  String get residentServices => 'خدمات السكان';

  @override
  String get visitorPass => 'تصريح زائر';

  @override
  String get visitorPassSubtitle => 'الضيوف المتوقعون ورمز QR';

  @override
  String get maintenance => 'الصيانة';

  @override
  String get maintenanceSubtitle => 'تكييف، سباكة وإصلاحات';

  @override
  String get recreation => 'المرافق والترفيه';

  @override
  String get recreationSubtitle => 'بادل، نادي رياضي ومسبح';

  @override
  String get housekeeping => 'النظافة المنزلية';

  @override
  String get housekeepingSubtitle => 'حجز خدمة تنظيف معتمدة';

  @override
  String get activeRequests => 'الطلبات النشطة';

  @override
  String get newRequest => 'طلب جديد';

  @override
  String get noActiveRequests => 'لا توجد طلبات خدمة نشطة حالياً.';

  @override
  String get maintenanceWorkOrders => 'أوامر عمل الصيانة';

  @override
  String get maintenanceLeadFallback => 'مسؤول الصيانة';

  @override
  String get maintenanceOperationsSubtitle =>
      'العمليات الفنية • ٤ فنيين على رأس العمل';

  @override
  String get metricNew => 'جديد';

  @override
  String get metricAssigned => 'مسند';

  @override
  String get metricInProgress => 'قيد التنفيذ';

  @override
  String get metricCompleted => 'مكتمل';

  @override
  String filterAll(int count) {
    return 'الكل ($count)';
  }

  @override
  String get filterAc => 'تكييف ❄️';

  @override
  String get filterPlumbing => 'سباكة 🚿';

  @override
  String get filterElectrical => 'كهرباء ⚡';

  @override
  String workOrdersCount(int count) {
    return 'أوامر العمل ($count)';
  }

  @override
  String get noWorkOrdersFilter => 'لا توجد أوامر عمل تطابق هذا التصنيف.';

  @override
  String get unitLabel => 'الوحدة';

  @override
  String unitWithNumber(String unit) {
    return 'وحدة $unit';
  }

  @override
  String get unassigned => 'غير مسند';

  @override
  String get manageAndChat => 'إدارة ومحادثة';

  @override
  String get newMaintenanceRequest => 'طلب صيانة جديد';

  @override
  String get selectCategory => 'اختر التصنيف';

  @override
  String get problemTitle => 'عنوان المشكلة';

  @override
  String get problemTitleHint => 'مثال: مكيف غرفة النوم الرئيسية لا يبرد';

  @override
  String get problemTitleRequired => 'يرجى إدخال عنوان المشكلة';

  @override
  String get detailedDescription => 'وصف تفصيلي';

  @override
  String get detailedDescriptionHint =>
      'اشرح المشكلة، موقعها داخل الوحدة، وأي أصوات أو تسريبات...';

  @override
  String get detailedDescriptionRequired => 'يرجى وصف المشكلة';

  @override
  String get urgencyPriority => 'درجة الأهمية / الأولوية';

  @override
  String get preferredAppointmentSlot => 'الموعد المفضل للزيارة';

  @override
  String tomorrowDate(String date) {
    return 'غداً ($date)';
  }

  @override
  String get submitRequestToMaintenance => 'إرسال الطلب لقسم الصيانة';

  @override
  String get assignTechnician => 'إسناد فني';

  @override
  String get techMahmoud => 'الفني محمود (تكييف وتبريد)';

  @override
  String get techSalem => 'الفني سالم (سباكة)';

  @override
  String get techHassan => 'م. حسن النجار (مسؤول الصيانة)';

  @override
  String get rateCompletedService => 'تقييم الخدمة المكتملة';

  @override
  String get rateQuestion => 'ما مدى رضاك عن خدمة الصيانة المقدمة؟';

  @override
  String get feedbackHint => 'أضف ملاحظاتك أو تعليقك (اختياري)...';

  @override
  String get submitRating => 'إرسال التقييم';

  @override
  String get updateStatus => 'تحديث الحالة';

  @override
  String get setUnderReview => 'تعيين: قيد المراجعة';

  @override
  String get setInProgress => 'تعيين: جاري العمل';

  @override
  String get setCompleted => 'تعيين: مكتمل';

  @override
  String get appointmentLabel => 'الموعد';

  @override
  String get priorityLabel => 'الأولوية';

  @override
  String assignedPrefix(String name) {
    return 'الفني المسند: $name';
  }

  @override
  String get markComplete => 'إنهاء الطلب';

  @override
  String get residentFeedback => 'تقييم الساكن';

  @override
  String get serviceCompletedTitle => 'تم إكمال الخدمة!';

  @override
  String get rateYourExperience => 'قيّم تجربتك مع فريق الصيانة';

  @override
  String get rateButton => 'تقييم (١-٥ ⭐)';

  @override
  String requestUpdatesAndChat(int count) {
    return 'التحديثات والمحادثة ($count)';
  }

  @override
  String get noCommentsYet =>
      'لا توجد تعليقات بعد. أرسل رسالة أدناه للتواصل المباشر.';

  @override
  String get typeUpdateOrQuestion => 'اكتب تحديثاً أو استفساراً...';

  @override
  String get stepPending => 'انتظار';

  @override
  String get stepReview => 'مراجعة';

  @override
  String get stepAssigned => 'مسند';

  @override
  String get stepInProgress => 'تنفيذ';

  @override
  String get stepDone => 'مكتمل';

  @override
  String get securityGateOperations => 'الأمن وعمليات البوابات';

  @override
  String get officerOnDuty => 'ضابط الأمن المناوب';

  @override
  String get gateShiftActive => 'البوابة ١ (المدخل الرئيسي) • المناوبة نشطة';

  @override
  String get expectedToday => 'متوقعون اليوم';

  @override
  String get checkedIn => 'تم الدخول';

  @override
  String get onCompound => 'داخل المجمع';

  @override
  String get searchPlateOrVisitor => 'ابحث برقم اللوحة أو اسم الزائر...';

  @override
  String get expectedVisitors => 'الزوار المتوقعون';

  @override
  String hostPrefix(String unit) {
    return 'المستضيف: $unit';
  }

  @override
  String get statusExpected => 'متوقع';

  @override
  String get checkIn => 'تسجيل دخول';

  @override
  String get todaySuffix => '(اليوم)';

  @override
  String get checkOut => 'تسجيل خروج';

  @override
  String get denyEntry => 'رفض';

  @override
  String get denyVisitorTitle => 'رفض دخول الزائر';

  @override
  String get denyReasonHint =>
      'أدخل سبب رفض الدخول (مثال: عدم وجود إثبات هوية)...';

  @override
  String get confirmDeny => 'تأكيد الرفض';

  @override
  String get currentlyOnCompound => 'متواجدون داخل المجمع حالياً';

  @override
  String get recentGateActivity => 'سجل البوابة';

  @override
  String get noExpectedVisitors => 'لا يوجد زوار متوقعون يطابقون البحث.';

  @override
  String get noVisitorsOnCompound => 'لا يوجد زوار مسجلون داخل المجمع حالياً.';

  @override
  String get walkInPedestrian => 'بدون مركبة';

  @override
  String get passCodeLabel => 'رمز التصريح';

  @override
  String get verifyQrCodeTitle => 'التحقق من رمز تصريح الزائر';

  @override
  String get verifyQrCodeHint =>
      'أدخل رمز التصريح (مثال VP-4823) أو رقم اللوحة...';

  @override
  String get verifyButton => 'بحث / تحقق';

  @override
  String get myVisitorPasses => 'تصاريح الزوار الخاصة بي';

  @override
  String get createVisitorPassTitle => 'إصدار تصريح زائر';

  @override
  String get newVisitorPass => 'تصريح زائر جديد';

  @override
  String get noVisitorPassesYet =>
      'لم يتم إصدار تصاريح زوار بعد. اضغط + لدعوة ضيف.';

  @override
  String get visitorFullName => 'اسم الزائر الكامل';

  @override
  String get visitorFullNameHint => 'مثال: خالد الغامدي';

  @override
  String get visitorFullNameRequired => 'يرجى إدخال اسم الزائر';

  @override
  String get visitorPhone => 'رقم جوال الزائر';

  @override
  String get visitorPhoneHint => '+966 5X XXX XXXX';

  @override
  String get visitorPhoneRequired => 'يرجى إدخال رقم جوال الزائر';

  @override
  String get visitDateLabel => 'تاريخ الزيارة';

  @override
  String get expectedArrivalTimeLabel => 'وقت الوصول المتوقع';

  @override
  String get vehiclePlateOptional => 'رقم لوحة المركبة (اختياري)';

  @override
  String get vehiclePlateHint => 'مثال: ABC 4567';

  @override
  String get securityNotesOptional => 'ملاحظات لأمن البوابة (اختياري)';

  @override
  String get securityNotesHint => 'مثال: ضيف عائلي، مندوب توصيل...';

  @override
  String get generateQrPass => 'إصدار تصريح الدخول ورمز QR';

  @override
  String get digitalGatePass => 'تصريح دخول إلكتروني';

  @override
  String get showQrAtGate =>
      'أبرز رمز QR هذا عند البوابة الرئيسية لمجمع المحمدية';

  @override
  String get close => 'إغلاق';

  @override
  String checkedInAt(String time) {
    return 'وقت الدخول: $time';
  }

  @override
  String checkedOutAt(String time) {
    return 'وقت الخروج: $time';
  }

  @override
  String get housekeepingAndCleaning => 'النظافة المنزلية';

  @override
  String get housekeepingSupervisorFallback => 'مشرفة النظافة';

  @override
  String get housekeepingRateSubtitle =>
      'السعر القياسي: ١٠٠ ر.س/ساعة • ٦ عاملات نشطات';

  @override
  String get todaysCleaningAppointments => 'مواعيد التنظيف اليوم';

  @override
  String get deepVillaCleaning => 'تنظيف عميق للفيلا';

  @override
  String get standardApartmentCleaning => 'تنظيف قياسي للشقة';

  @override
  String hoursAndSar(int hours, int amount) {
    return '$hours ساعات • $amount ر.س';
  }

  @override
  String get staffUnassigned => 'لم يتم تعيين طاقم';

  @override
  String get statusConfirmed => 'مؤكد';

  @override
  String get statusScheduled => 'مجدول';

  @override
  String get dispatch => 'توجيه الطاقم';

  @override
  String get recreationAndFacilities => 'المرافق والترفيه';

  @override
  String get recreationManagerFallback => 'مدير المرافق';

  @override
  String get clubhouseSubtitle =>
      'النادي الاجتماعي، الصالة الرياضية وملعبا بادل';

  @override
  String get facilityBookingsToday => 'حجوزات المرافق اليوم';

  @override
  String get padelCourt1 => 'ملعب البادل ١ (ملعب زجاجي)';

  @override
  String get olympicSwimmingPool => 'المسبح الأولمبي';

  @override
  String get complimentary => 'مجاني للمقيمين';

  @override
  String slotPrefix(String time) {
    return 'الفترة: $time';
  }

  @override
  String sarAmount(int amount) {
    return '$amount ر.س';
  }

  @override
  String get itSmartSupport => 'الدعم الفني والأنظمة الذكية';

  @override
  String get itSupportFallback => 'أخصائي الدعم الفني';

  @override
  String get fiberNetworkSubtitle => 'شبكة الألياف الضوئية وأنظمة الدخول الذكي';

  @override
  String get activeTechnicalTickets => 'التذاكر التقنية النشطة';

  @override
  String get smartIntercomOffline => 'انقطاع اتصال الإنتركوم الذكي';

  @override
  String get fiberSpeedDegradation => 'بطء في سرعة إنترنت الألياف';

  @override
  String get statusInvestigating => 'قيد الفحص';

  @override
  String get statusQueued => 'في الانتظار';

  @override
  String get compoundAdministration => 'إدارة المجمع';

  @override
  String get administratorFallback => 'مدير المجمع';

  @override
  String get executiveOpsSubtitle => 'العمليات التنفيذية وشكاوى السكان';

  @override
  String get totalUnits => 'إجمالي الوحدات';

  @override
  String get occupancy => 'نسبة الإشغال';

  @override
  String get openRequests => 'طلبات مفتوحة';

  @override
  String get escalatedComplaints => 'الشكاوى المصعّدة والطلبات المباشرة';

  @override
  String get visitorGateDelayComplaint => 'شكوى تأخر دخول الزوار عند البوابة';

  @override
  String hoursAgo(int count) {
    return 'منذ $count ساعات';
  }

  @override
  String get highPriorityBadge => 'أولوية عالية';

  @override
  String get underReviewBadge => 'قيد المراجعة';

  @override
  String get systemAdministration => 'إدارة النظام';

  @override
  String get globalSystemOperations => 'العمليات الشاملة للنظام';

  @override
  String get globalSystemSubtitle =>
      'المجمعات، قواعد الحماية وإدارة البيانات التجريبية';

  @override
  String get administrativeFunctions => 'الوظائف الإدارية';

  @override
  String get compoundManagement => 'إدارة المجمعات';

  @override
  String get compoundManagementSubtitle =>
      'إدارة مجمع المحمدية وإضافة مجمعات جديدة';

  @override
  String get userRolesPermissions => 'الأدوار والصلاحيات';

  @override
  String get userRolesPermissionsSubtitle => 'إدارة صلاحيات السكان والموظفين';

  @override
  String get seedDemoDatabase => 'إعادة تهيئة البيانات التجريبية';

  @override
  String get seedDemoDatabaseSubtitle =>
      'إعادة تعيين أو إنشاء الطلبات والحجوزات التجريبية';
}
