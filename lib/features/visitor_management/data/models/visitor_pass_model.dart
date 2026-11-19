import '../../domain/entities/visitor_pass_entity.dart';

class VisitorPassModel extends VisitorPassEntity {
  const VisitorPassModel({
    required super.id,
    required super.passCode,
    required super.compoundId,
    required super.unitId,
    required super.unitNumber,
    required super.residentId,
    required super.residentName,
    required super.visitorName,
    required super.visitorPhone,
    required super.visitDate,
    required super.expectedArrivalTime,
    super.vehiclePlate,
    required super.status,
    super.checkInTime,
    super.checkOutTime,
    super.securityNotes,
    required super.createdAt,
  });

  factory VisitorPassModel.fromJson(Map<String, dynamic> json) {
    return VisitorPassModel(
      id: json['id'] as String,
      passCode: json['passCode'] as String,
      compoundId: json['compoundId'] as String,
      unitId: json['unitId'] as String,
      unitNumber: json['unitNumber'] as String,
      residentId: json['residentId'] as String,
      residentName: json['residentName'] as String,
      visitorName: json['visitorName'] as String,
      visitorPhone: json['visitorPhone'] as String,
      visitDate: DateTime.parse(json['visitDate'] as String),
      expectedArrivalTime: json['expectedArrivalTime'] as String,
      vehiclePlate: json['vehiclePlate'] as String?,
      status: VisitorPassStatusX.fromString(json['status'] as String),
      checkInTime: json['checkInTime'] != null
          ? DateTime.parse(json['checkInTime'] as String)
          : null,
      checkOutTime: json['checkOutTime'] != null
          ? DateTime.parse(json['checkOutTime'] as String)
          : null,
      securityNotes: json['securityNotes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'passCode': passCode,
      'compoundId': compoundId,
      'unitId': unitId,
      'unitNumber': unitNumber,
      'residentId': residentId,
      'residentName': residentName,
      'visitorName': visitorName,
      'visitorPhone': visitorPhone,
      'visitDate': visitDate.toIso8601String(),
      'expectedArrivalTime': expectedArrivalTime,
      'vehiclePlate': vehiclePlate,
      'status': _statusToString(status),
      'checkInTime': checkInTime?.toIso8601String(),
      'checkOutTime': checkOutTime?.toIso8601String(),
      'securityNotes': securityNotes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory VisitorPassModel.fromEntity(VisitorPassEntity entity) {
    return VisitorPassModel(
      id: entity.id,
      passCode: entity.passCode,
      compoundId: entity.compoundId,
      unitId: entity.unitId,
      unitNumber: entity.unitNumber,
      residentId: entity.residentId,
      residentName: entity.residentName,
      visitorName: entity.visitorName,
      visitorPhone: entity.visitorPhone,
      visitDate: entity.visitDate,
      expectedArrivalTime: entity.expectedArrivalTime,
      vehiclePlate: entity.vehiclePlate,
      status: entity.status,
      checkInTime: entity.checkInTime,
      checkOutTime: entity.checkOutTime,
      securityNotes: entity.securityNotes,
      createdAt: entity.createdAt,
    );
  }

  static String _statusToString(VisitorPassStatus status) {
    switch (status) {
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
}
