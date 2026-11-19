enum VisitorPassStatus {
  expected,
  checkedIn,
  checkedOut,
  expired,
  denied,
}

extension VisitorPassStatusX on VisitorPassStatus {
  String get displayNameEn {
    switch (this) {
      case VisitorPassStatus.expected:
        return 'Expected';
      case VisitorPassStatus.checkedIn:
        return 'Checked In';
      case VisitorPassStatus.checkedOut:
        return 'Checked Out';
      case VisitorPassStatus.expired:
        return 'Expired';
      case VisitorPassStatus.denied:
        return 'Denied';
    }
  }

  String get displayNameAr {
    switch (this) {
      case VisitorPassStatus.expected:
        return 'متوقع';
      case VisitorPassStatus.checkedIn:
        return 'داخل المجمع';
      case VisitorPassStatus.checkedOut:
        return 'غادر المجمع';
      case VisitorPassStatus.expired:
        return 'منتهي';
      case VisitorPassStatus.denied:
        return 'مرفوض';
    }
  }

  String toDbString() {
    switch (this) {
      case VisitorPassStatus.expected:
        return 'expected';
      case VisitorPassStatus.checkedIn:
        return 'checkedIn';
      case VisitorPassStatus.checkedOut:
        return 'checkedOut';
      case VisitorPassStatus.expired:
        return 'expired';
      case VisitorPassStatus.denied:
        return 'denied';
    }
  }

  static VisitorPassStatus fromString(String? value) {
    switch (value?.trim()) {
      case 'checkedIn':
      case 'checked_in':
        return VisitorPassStatus.checkedIn;
      case 'checkedOut':
      case 'checked_out':
        return VisitorPassStatus.checkedOut;
      case 'expired':
        return VisitorPassStatus.expired;
      case 'denied':
        return VisitorPassStatus.denied;
      default:
        return VisitorPassStatus.expected;
    }
  }
}

class VisitorPassEntity {
  final String id;
  final String passCode;
  final String compoundId;
  final String unitId;
  final String unitNumber;
  final String residentId;
  final String residentEmail;
  final String residentName;
  final String visitorName;
  final String visitorPhone;
  final DateTime visitDate;
  final String expectedArrivalTime;
  final String? vehiclePlate;
  final VisitorPassStatus status;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final String? securityNotes;
  final DateTime createdAt;

  const VisitorPassEntity({
    required this.id,
    required this.passCode,
    required this.compoundId,
    required this.unitId,
    required this.unitNumber,
    required this.residentId,
    this.residentEmail = '',
    required this.residentName,
    required this.visitorName,
    required this.visitorPhone,
    required this.visitDate,
    required this.expectedArrivalTime,
    this.vehiclePlate,
    required this.status,
    this.checkInTime,
    this.checkOutTime,
    this.securityNotes,
    required this.createdAt,
  });

  VisitorPassEntity copyWith({
    String? id,
    String? passCode,
    String? residentEmail,
    VisitorPassStatus? status,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    String? securityNotes,
  }) {
    return VisitorPassEntity(
      id: id ?? this.id,
      passCode: passCode ?? this.passCode,
      compoundId: compoundId,
      unitId: unitId,
      unitNumber: unitNumber,
      residentId: residentId,
      residentEmail: residentEmail ?? this.residentEmail,
      residentName: residentName,
      visitorName: visitorName,
      visitorPhone: visitorPhone,
      visitDate: visitDate,
      expectedArrivalTime: expectedArrivalTime,
      vehiclePlate: vehiclePlate,
      status: status ?? this.status,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      securityNotes: securityNotes ?? this.securityNotes,
      createdAt: createdAt,
    );
  }
}
