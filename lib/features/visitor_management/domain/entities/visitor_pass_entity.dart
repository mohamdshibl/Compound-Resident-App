enum VisitorPassStatus {
  expected,
  checkedIn,
  checkedOut,
  expired,
  denied,
}

extension VisitorPassStatusX on VisitorPassStatus {
  String get label {
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

  static VisitorPassStatus fromString(String value) {
    switch (value) {
      case 'checkedIn':
        return VisitorPassStatus.checkedIn;
      case 'checkedOut':
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
    VisitorPassStatus? status,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    String? securityNotes,
  }) {
    return VisitorPassEntity(
      id: id,
      passCode: passCode,
      compoundId: compoundId,
      unitId: unitId,
      unitNumber: unitNumber,
      residentId: residentId,
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
