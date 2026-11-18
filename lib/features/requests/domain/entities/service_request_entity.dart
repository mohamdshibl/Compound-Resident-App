import 'request_enums.dart';

class ServiceRequestEntity {
  final String id;
  final String requestNumber;
  final String compoundId;
  final String unitId;
  final String unitNumber;
  final String createdByUserId;
  final String createdByName;
  final String createdByRole;
  final String department;
  final RequestCategory category;
  final String title;
  final String description;
  final RequestPriority priority;
  final DateTime preferredDate;
  final String preferredTimeSlot;
  final RequestStatus currentStatus;
  final String? assignedEmployeeId;
  final String? assignedEmployeeName;
  final List<String> attachmentUrls;
  final int commentsCount;
  final bool hasRating;
  final int? ratingValue;
  final String? ratingFeedback;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ServiceRequestEntity({
    required this.id,
    required this.requestNumber,
    required this.compoundId,
    required this.unitId,
    required this.unitNumber,
    required this.createdByUserId,
    required this.createdByName,
    required this.createdByRole,
    this.department = 'maintenance',
    required this.category,
    required this.title,
    required this.description,
    required this.priority,
    required this.preferredDate,
    required this.preferredTimeSlot,
    required this.currentStatus,
    this.assignedEmployeeId,
    this.assignedEmployeeName,
    this.attachmentUrls = const [],
    this.commentsCount = 0,
    this.hasRating = false,
    this.ratingValue,
    this.ratingFeedback,
    required this.createdAt,
    required this.updatedAt,
  });

  ServiceRequestEntity copyWith({
    String? id,
    String? requestNumber,
    String? compoundId,
    String? unitId,
    String? unitNumber,
    String? createdByUserId,
    String? createdByName,
    String? createdByRole,
    String? department,
    RequestCategory? category,
    String? title,
    String? description,
    RequestPriority? priority,
    DateTime? preferredDate,
    String? preferredTimeSlot,
    RequestStatus? currentStatus,
    String? assignedEmployeeId,
    String? assignedEmployeeName,
    List<String>? attachmentUrls,
    int? commentsCount,
    bool? hasRating,
    int? ratingValue,
    String? ratingFeedback,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ServiceRequestEntity(
      id: id ?? this.id,
      requestNumber: requestNumber ?? this.requestNumber,
      compoundId: compoundId ?? this.compoundId,
      unitId: unitId ?? this.unitId,
      unitNumber: unitNumber ?? this.unitNumber,
      createdByUserId: createdByUserId ?? this.createdByUserId,
      createdByName: createdByName ?? this.createdByName,
      createdByRole: createdByRole ?? this.createdByRole,
      department: department ?? this.department,
      category: category ?? this.category,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      preferredDate: preferredDate ?? this.preferredDate,
      preferredTimeSlot: preferredTimeSlot ?? this.preferredTimeSlot,
      currentStatus: currentStatus ?? this.currentStatus,
      assignedEmployeeId: assignedEmployeeId ?? this.assignedEmployeeId,
      assignedEmployeeName: assignedEmployeeName ?? this.assignedEmployeeName,
      attachmentUrls: attachmentUrls ?? this.attachmentUrls,
      commentsCount: commentsCount ?? this.commentsCount,
      hasRating: hasRating ?? this.hasRating,
      ratingValue: ratingValue ?? this.ratingValue,
      ratingFeedback: ratingFeedback ?? this.ratingFeedback,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
