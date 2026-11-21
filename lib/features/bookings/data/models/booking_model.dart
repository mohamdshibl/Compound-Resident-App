import '../../domain/entities/booking_entity.dart';

class BookingModel extends BookingEntity {
  const BookingModel({
    required super.id,
    required super.bookingNumber,
    required super.compoundId,
    required super.facilityOrServiceId,
    required super.title,
    super.titleAr = '',
    required super.bookingType,
    required super.userId,
    super.userEmail = '',
    required super.userName,
    required super.unitNumber,
    required super.bookingDate,
    required super.startTime,
    required super.endTime,
    required super.durationHours,
    required super.totalPrice,
    super.currency = 'SAR',
    required super.status,
    super.assignedStaffName,
    super.notes,
    super.hasRating = false,
    super.ratingValue,
    super.ratingFeedback,
    required super.createdAt,
  });

  factory BookingModel.fromJson(
    Map<String, dynamic> json, {
    String? id,
  }) {
    return BookingModel(
      id: id ?? json['id'] as String? ?? '',
      bookingNumber: json['bookingNumber'] as String? ?? 'BK-2026-0000',
      compoundId: json['compoundId'] as String? ?? 'compound_al_mohamedia',
      facilityOrServiceId: json['facilityOrServiceId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      titleAr: json['titleAr'] as String? ?? '',
      bookingType: BookingType.fromString(json['bookingType'] as String?),
      userId: json['userId'] as String? ?? '',
      userEmail: json['userEmail'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      unitNumber: json['unitNumber'] as String? ?? '',
      bookingDate: json['bookingDate'] != null
          ? DateTime.tryParse(json['bookingDate'].toString()) ?? DateTime.now()
          : DateTime.now(),
      startTime: json['startTime'] as String? ?? '10:00',
      endTime: json['endTime'] as String? ?? '11:00',
      durationHours: (json['durationHours'] as num?)?.toInt() ?? 1,
      totalPrice: (json['totalPrice'] as num?)?.toInt() ?? 0,
      currency: json['currency'] as String? ?? 'SAR',
      status: BookingStatus.fromString(json['status'] as String?),
      assignedStaffName: json['assignedStaffName'] as String?,
      notes: json['notes'] as String?,
      hasRating: json['hasRating'] as bool? ?? false,
      ratingValue: (json['ratingValue'] as num?)?.toInt(),
      ratingFeedback: json['ratingFeedback'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookingNumber': bookingNumber,
      'compoundId': compoundId,
      'facilityOrServiceId': facilityOrServiceId,
      'title': title,
      'titleAr': titleAr,
      'bookingType': bookingType.toDbString(),
      'userId': userId,
      'userEmail': userEmail.trim().toLowerCase(),
      'userName': userName,
      'unitNumber': unitNumber,
      'bookingDate': bookingDate.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'durationHours': durationHours,
      'totalPrice': totalPrice,
      'currency': currency,
      'status': status.toDbString(),
      'assignedStaffName': assignedStaffName,
      'notes': notes,
      'hasRating': hasRating,
      'ratingValue': ratingValue,
      'ratingFeedback': ratingFeedback,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory BookingModel.fromEntity(BookingEntity entity) {
    return BookingModel(
      id: entity.id,
      bookingNumber: entity.bookingNumber,
      compoundId: entity.compoundId,
      facilityOrServiceId: entity.facilityOrServiceId,
      title: entity.title,
      titleAr: entity.titleAr,
      bookingType: entity.bookingType,
      userId: entity.userId,
      userEmail: entity.userEmail,
      userName: entity.userName,
      unitNumber: entity.unitNumber,
      bookingDate: entity.bookingDate,
      startTime: entity.startTime,
      endTime: entity.endTime,
      durationHours: entity.durationHours,
      totalPrice: entity.totalPrice,
      currency: entity.currency,
      status: entity.status,
      assignedStaffName: entity.assignedStaffName,
      notes: entity.notes,
      hasRating: entity.hasRating,
      ratingValue: entity.ratingValue,
      ratingFeedback: entity.ratingFeedback,
      createdAt: entity.createdAt,
    );
  }
}
