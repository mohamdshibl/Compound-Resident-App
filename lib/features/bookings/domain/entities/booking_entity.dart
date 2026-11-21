enum BookingType {
  recreation,
  housekeeping;

  String toDbString() => name;

  static BookingType fromString(String? value) {
    switch (value?.trim().toLowerCase()) {
      case 'housekeeping':
        return BookingType.housekeeping;
      case 'recreation':
      case 'facility':
      default:
        return BookingType.recreation;
    }
  }
}

enum BookingStatus {
  scheduled,
  confirmed,
  inProgress,
  completed,
  cancelled;

  String get displayNameEn {
    switch (this) {
      case BookingStatus.scheduled:
        return 'Scheduled';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.inProgress:
        return 'In Progress';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get displayNameAr {
    switch (this) {
      case BookingStatus.scheduled:
        return 'مجدول';
      case BookingStatus.confirmed:
        return 'مؤكد';
      case BookingStatus.inProgress:
        return 'جاري التنفيذ';
      case BookingStatus.completed:
        return 'مكتمل';
      case BookingStatus.cancelled:
        return 'ملغي';
    }
  }

  String toDbString() {
    switch (this) {
      case BookingStatus.inProgress:
        return 'in_progress';
      default:
        return name;
    }
  }

  static BookingStatus fromString(String? value) {
    switch (value?.trim().toLowerCase()) {
      case 'confirmed':
        return BookingStatus.confirmed;
      case 'in_progress':
      case 'inprogress':
        return BookingStatus.inProgress;
      case 'completed':
        return BookingStatus.completed;
      case 'cancelled':
        return BookingStatus.cancelled;
      case 'scheduled':
      default:
        return BookingStatus.scheduled;
    }
  }
}

class BookingCatalogItem {
  final String id;
  final String titleEn;
  final String titleAr;
  final String subtitleEn;
  final String subtitleAr;
  final String iconEmoji;
  final BookingType bookingType;
  final int hourlyRate;

  const BookingCatalogItem({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.subtitleEn,
    required this.subtitleAr,
    required this.iconEmoji,
    required this.bookingType,
    required this.hourlyRate,
  });

  static const List<BookingCatalogItem> recreationFacilities = [
    BookingCatalogItem(
      id: 'fac_padel_1',
      titleEn: 'Padel Court 1 (Glass Court)',
      titleAr: 'ملعب البادل ١ (ملعب زجاجي)',
      subtitleEn: 'Tournament panoramic glass court with LED floodlights',
      subtitleAr: 'ملعب زجاجي بانورامي معتمد مع إضاءة LED',
      iconEmoji: '🎾',
      bookingType: BookingType.recreation,
      hourlyRate: 80,
    ),
    BookingCatalogItem(
      id: 'fac_pool',
      titleEn: 'Olympic Swimming Pool',
      titleAr: 'المسبح الأولمبي',
      subtitleEn: 'Temperature-controlled lap & leisure pool',
      subtitleAr: 'مسبح أولمبي بتحكم حراري للمقيمين',
      iconEmoji: '🏊',
      bookingType: BookingType.recreation,
      hourlyRate: 0,
    ),
    BookingCatalogItem(
      id: 'fac_gym',
      titleEn: 'Prestige Fitness Gym',
      titleAr: 'النادي الرياضي المتكامل',
      subtitleEn: 'Technogym cardio, free weights & personal training zone',
      subtitleAr: 'أحدث أجهزة الكارديو والأثقال واللياقة البدنية',
      iconEmoji: '🏋️',
      bookingType: BookingType.recreation,
      hourlyRate: 0,
    ),
    BookingCatalogItem(
      id: 'fac_spa',
      titleEn: 'Private Spa & Sauna Suite',
      titleAr: 'جناح السبا والساونا الخاص',
      subtitleEn: 'Finnish sauna, steam room & relaxation lounge',
      subtitleAr: 'ساونا فنلندية، غرفة بخار وصالة استرخاء خاصة',
      iconEmoji: '🧖',
      bookingType: BookingType.recreation,
      hourlyRate: 120,
    ),
  ];

  static const List<BookingCatalogItem> housekeepingPackages = [
    BookingCatalogItem(
      id: 'hk_standard',
      titleEn: 'Standard Residence Cleaning',
      titleAr: 'تنظيف قياسي للوحدة السكنية',
      subtitleEn: 'Certified hotel-grade daily/weekly cleaning (100 SAR/hr)',
      subtitleAr: 'تنظيف فندقي معتمد للغرف والأرضيات والأسطح (١٠٠ ر.س/ساعة)',
      iconEmoji: '🧹',
      bookingType: BookingType.housekeeping,
      hourlyRate: 100,
    ),
    BookingCatalogItem(
      id: 'hk_deep',
      titleEn: 'Deep Villa & Sanitization Cleaning',
      titleAr: 'تنظيف عميق وتعقيم شامل للفيلا',
      subtitleEn: '2-person specialist team with steam sanitization (150 SAR/hr)',
      subtitleAr: 'فريق متخصص مع تعقيم بالبخار وتنظيف شامل (١٥٠ ر.س/ساعة)',
      iconEmoji: '✨',
      bookingType: BookingType.housekeeping,
      hourlyRate: 150,
    ),
  ];
}

class BookingEntity {
  final String id;
  final String bookingNumber;
  final String compoundId;
  final String facilityOrServiceId;
  final String title;
  final String titleAr;
  final BookingType bookingType;
  final String userId;
  final String userEmail;
  final String userName;
  final String unitNumber;
  final DateTime bookingDate;
  final String startTime;
  final String endTime;
  final int durationHours;
  final int totalPrice;
  final String currency;
  final BookingStatus status;
  final String? assignedStaffName;
  final String? notes;
  final bool hasRating;
  final int? ratingValue;
  final String? ratingFeedback;
  final DateTime createdAt;

  const BookingEntity({
    required this.id,
    required this.bookingNumber,
    required this.compoundId,
    required this.facilityOrServiceId,
    required this.title,
    this.titleAr = '',
    required this.bookingType,
    required this.userId,
    this.userEmail = '',
    required this.userName,
    required this.unitNumber,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.durationHours,
    required this.totalPrice,
    this.currency = 'SAR',
    required this.status,
    this.assignedStaffName,
    this.notes,
    this.hasRating = false,
    this.ratingValue,
    this.ratingFeedback,
    required this.createdAt,
  });

  String localizedTitle(bool isArabic) {
    if (isArabic && titleAr.trim().isNotEmpty) return titleAr;
    return title;
  }

  BookingEntity copyWith({
    String? userEmail,
    BookingStatus? status,
    String? assignedStaffName,
    bool? hasRating,
    int? ratingValue,
    String? ratingFeedback,
  }) {
    return BookingEntity(
      id: id,
      bookingNumber: bookingNumber,
      compoundId: compoundId,
      facilityOrServiceId: facilityOrServiceId,
      title: title,
      titleAr: titleAr,
      bookingType: bookingType,
      userId: userId,
      userEmail: userEmail ?? this.userEmail,
      userName: userName,
      unitNumber: unitNumber,
      bookingDate: bookingDate,
      startTime: startTime,
      endTime: endTime,
      durationHours: durationHours,
      totalPrice: totalPrice,
      currency: currency,
      status: status ?? this.status,
      assignedStaffName: assignedStaffName ?? this.assignedStaffName,
      notes: notes,
      hasRating: hasRating ?? this.hasRating,
      ratingValue: ratingValue ?? this.ratingValue,
      ratingFeedback: ratingFeedback ?? this.ratingFeedback,
      createdAt: createdAt,
    );
  }
}
