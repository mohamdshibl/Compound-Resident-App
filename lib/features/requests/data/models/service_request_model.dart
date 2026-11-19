import '../../domain/entities/request_enums.dart';
import '../../domain/entities/service_request_entity.dart';

class ServiceRequestModel extends ServiceRequestEntity {
  const ServiceRequestModel({
    required super.id,
    required super.requestNumber,
    required super.compoundId,
    required super.unitId,
    required super.unitNumber,
    required super.createdByUserId,
    required super.createdByName,
    required super.createdByRole,
    super.department = 'maintenance',
    required super.category,
    required super.title,
    required super.description,
    required super.priority,
    required super.preferredDate,
    required super.preferredTimeSlot,
    required super.currentStatus,
    super.assignedEmployeeId,
    super.assignedEmployeeName,
    super.attachmentUrls,
    super.commentsCount,
    super.hasRating,
    super.ratingValue,
    super.ratingFeedback,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ServiceRequestModel.fromJson(
    Map<String, dynamic> json, {
    String? id,
  }) {
    return ServiceRequestModel(
      id: id ?? json['id'] as String? ?? '',
      requestNumber: json['requestNumber'] as String? ?? '',
      compoundId: json['compoundId'] as String? ?? 'compound_al_mohamedia',
      unitId: json['unitId'] as String? ?? '',
      unitNumber: json['unitNumber'] as String? ?? '',
      createdByUserId: json['createdByUserId'] as String? ?? '',
      createdByName: json['createdByName'] as String? ?? '',
      createdByRole: json['createdByRole'] as String? ?? 'owner',
      department: json['department'] as String? ?? 'maintenance',
      category: RequestCategory.fromString(json['category'] as String?),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      priority: RequestPriority.fromString(json['priority'] as String?),
      preferredDate: json['preferredDate'] != null
          ? DateTime.tryParse(json['preferredDate'].toString()) ??
                DateTime.now()
          : DateTime.now(),
      preferredTimeSlot:
          json['preferredTimeSlot'] as String? ?? '09:00 - 12:00',
      currentStatus: RequestStatus.fromString(json['currentStatus'] as String?),
      assignedEmployeeId: json['assignedEmployeeId'] as String?,
      assignedEmployeeName: json['assignedEmployeeName'] as String?,
      attachmentUrls:
          (json['attachmentUrls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      commentsCount: json['commentsCount'] as int? ?? 0,
      hasRating: json['hasRating'] as bool? ?? false,
      ratingValue: json['ratingValue'] as int?,
      ratingFeedback: json['ratingFeedback'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'requestNumber': requestNumber,
      'compoundId': compoundId,
      'unitId': unitId,
      'unitNumber': unitNumber,
      'createdByUserId': createdByUserId,
      'createdByName': createdByName,
      'createdByRole': createdByRole,
      'department': department,
      'category': category.toDbString(),
      'title': title,
      'description': description,
      'priority': priority.toDbString(),
      'preferredDate': preferredDate.toIso8601String(),
      'preferredTimeSlot': preferredTimeSlot,
      'currentStatus': currentStatus.toDbString(),
      'assignedEmployeeId': assignedEmployeeId,
      'assignedEmployeeName': assignedEmployeeName,
      'attachmentUrls': attachmentUrls,
      'commentsCount': commentsCount,
      'hasRating': hasRating,
      'ratingValue': ratingValue,
      'ratingFeedback': ratingFeedback,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory ServiceRequestModel.fromEntity(ServiceRequestEntity entity) {
    return ServiceRequestModel(
      id: entity.id,
      requestNumber: entity.requestNumber,
      compoundId: entity.compoundId,
      unitId: entity.unitId,
      unitNumber: entity.unitNumber,
      createdByUserId: entity.createdByUserId,
      createdByName: entity.createdByName,
      createdByRole: entity.createdByRole,
      department: entity.department,
      category: entity.category,
      title: entity.title,
      description: entity.description,
      priority: entity.priority,
      preferredDate: entity.preferredDate,
      preferredTimeSlot: entity.preferredTimeSlot,
      currentStatus: entity.currentStatus,
      assignedEmployeeId: entity.assignedEmployeeId,
      assignedEmployeeName: entity.assignedEmployeeName,
      attachmentUrls: entity.attachmentUrls,
      commentsCount: entity.commentsCount,
      hasRating: entity.hasRating,
      ratingValue: entity.ratingValue,
      ratingFeedback: entity.ratingFeedback,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
