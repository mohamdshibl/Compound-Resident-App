enum RequestCategory {
  airConditioning,
  plumbing,
  electrical,
  refrigerators,
  generalMaintenance;

  static RequestCategory fromString(String? val) {
    switch (val?.toLowerCase().trim()) {
      case 'air_conditioning':
      case 'ac':
        return RequestCategory.airConditioning;
      case 'plumbing':
        return RequestCategory.plumbing;
      case 'electrical':
        return RequestCategory.electrical;
      case 'refrigerators':
      case 'appliances':
        return RequestCategory.refrigerators;
      default:
        return RequestCategory.generalMaintenance;
    }
  }

  String toDbString() {
    switch (this) {
      case RequestCategory.airConditioning:
        return 'air_conditioning';
      case RequestCategory.plumbing:
        return 'plumbing';
      case RequestCategory.electrical:
        return 'electrical';
      case RequestCategory.refrigerators:
        return 'refrigerators';
      case RequestCategory.generalMaintenance:
        return 'general_maintenance';
    }
  }

  String get displayNameEn {
    switch (this) {
      case RequestCategory.airConditioning:
        return 'Air Conditioning';
      case RequestCategory.plumbing:
        return 'Plumbing & Water';
      case RequestCategory.electrical:
        return 'Electrical & Power';
      case RequestCategory.refrigerators:
        return 'Home Appliances';
      case RequestCategory.generalMaintenance:
        return 'General Maintenance';
    }
  }

  String get displayNameAr {
    switch (this) {
      case RequestCategory.airConditioning:
        return 'تكييف وتبريد';
      case RequestCategory.plumbing:
        return 'سباكة ومياه';
      case RequestCategory.electrical:
        return 'كهرباء وإنارة';
      case RequestCategory.refrigerators:
        return 'أجهزة منزلية';
      case RequestCategory.generalMaintenance:
        return 'صيانة عامة';
    }
  }

  String get iconEmoji {
    switch (this) {
      case RequestCategory.airConditioning:
        return '❄️';
      case RequestCategory.plumbing:
        return '🚿';
      case RequestCategory.electrical:
        return '⚡';
      case RequestCategory.refrigerators:
        return '🧊';
      case RequestCategory.generalMaintenance:
        return '🔨';
    }
  }
}

enum RequestPriority {
  low,
  medium,
  high,
  emergency;

  static RequestPriority fromString(String? val) {
    switch (val?.toLowerCase().trim()) {
      case 'low':
        return RequestPriority.low;
      case 'high':
        return RequestPriority.high;
      case 'emergency':
        return RequestPriority.emergency;
      default:
        return RequestPriority.medium;
    }
  }

  String toDbString() => name;

  String get displayNameEn {
    switch (this) {
      case RequestPriority.low:
        return 'Low';
      case RequestPriority.medium:
        return 'Medium';
      case RequestPriority.high:
        return 'High';
      case RequestPriority.emergency:
        return 'Emergency ⚠️';
    }
  }

  String get displayNameAr {
    switch (this) {
      case RequestPriority.low:
        return 'منخفضة';
      case RequestPriority.medium:
        return 'متوسطة';
      case RequestPriority.high:
        return 'عالية';
      case RequestPriority.emergency:
        return 'طارئة ⚠️';
    }
  }
}

enum RequestStatus {
  pending,
  underReview,
  assigned,
  inProgress,
  waitingResident,
  completed,
  rejected,
  cancelled;

  static RequestStatus fromString(String? val) {
    switch (val?.toLowerCase().trim()) {
      case 'under_review':
        return RequestStatus.underReview;
      case 'assigned':
        return RequestStatus.assigned;
      case 'in_progress':
        return RequestStatus.inProgress;
      case 'waiting_resident':
        return RequestStatus.waitingResident;
      case 'completed':
        return RequestStatus.completed;
      case 'rejected':
        return RequestStatus.rejected;
      case 'cancelled':
        return RequestStatus.cancelled;
      default:
        return RequestStatus.pending;
    }
  }

  String toDbString() {
    switch (this) {
      case RequestStatus.underReview:
        return 'under_review';
      case RequestStatus.inProgress:
        return 'in_progress';
      case RequestStatus.waitingResident:
        return 'waiting_resident';
      default:
        return name;
    }
  }

  String get displayNameEn {
    switch (this) {
      case RequestStatus.pending:
        return 'Pending';
      case RequestStatus.underReview:
        return 'Under Review';
      case RequestStatus.assigned:
        return 'Assigned';
      case RequestStatus.inProgress:
        return 'In Progress';
      case RequestStatus.waitingResident:
        return 'Waiting for Resident';
      case RequestStatus.completed:
        return 'Completed';
      case RequestStatus.rejected:
        return 'Rejected';
      case RequestStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get displayNameAr {
    switch (this) {
      case RequestStatus.pending:
        return 'قيد الانتظار';
      case RequestStatus.underReview:
        return 'قيد المراجعة';
      case RequestStatus.assigned:
        return 'تم إسناد فني';
      case RequestStatus.inProgress:
        return 'جاري العمل';
      case RequestStatus.waitingResident:
        return 'بانتظار الساكن';
      case RequestStatus.completed:
        return 'مكتمل';
      case RequestStatus.rejected:
        return 'مرفوض';
      case RequestStatus.cancelled:
        return 'ملغي';
    }
  }

  int get stepIndex {
    switch (this) {
      case RequestStatus.pending:
        return 0;
      case RequestStatus.underReview:
        return 1;
      case RequestStatus.assigned:
        return 2;
      case RequestStatus.inProgress:
        return 3;
      case RequestStatus.completed:
        return 4;
      default:
        return 0;
    }
  }
}
