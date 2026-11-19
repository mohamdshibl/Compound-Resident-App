import '../../domain/entities/visitor_pass_entity.dart';

class VisitorPassModel extends VisitorPassEntity {
  const VisitorPassModel({
    required super.id,
    required super.passCode,
    required super.compoundId,
    required super.unitId,
    required super.unitNumber,
    required super.residentId,
    super.residentEmail = '',
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

  factory VisitorPassModel.fromJson(
    Map<String, dynamic> json, {
    String? id,
  }) {
    return VisitorPassModel(
      id: id ?? json['id'] as String? ?? '',
      passCode: json['passCode'] as String? ?? 'VP-0000',
      compoundId: json['compoundId'] as String? ?? 'compound_al_mohamedia',
      unitId: json['unitId'] as String? ?? '',
      unitNumber: json['unitNumber'] as String? ?? '',
      residentId: json['residentId'] as String? ?? '',
      residentEmail: json['residentEmail'] as String? ?? '',
      residentName: json['residentName'] as String? ?? '',
      visitorName: json['visitorName'] as String? ?? '',
      visitorPhone: json['visitorPhone'] as String? ?? '',
      visitDate: json['visitDate'] != null
          ? DateTime.tryParse(json['visitDate'].toString()) ?? DateTime.now()
          : DateTime.now(),
      expectedArrivalTime: json['expectedArrivalTime'] as String? ?? '18:00',
      vehiclePlate: json['vehiclePlate'] as String?,
      status: VisitorPassStatusX.fromString(json['status'] as String?),
      checkInTime: json['checkInTime'] != null
          ? DateTime.tryParse(json['checkInTime'].toString())
          : null,
      checkOutTime: json['checkOutTime'] != null
          ? DateTime.tryParse(json['checkOutTime'].toString())
          : null,
      securityNotes: json['securityNotes'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
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
      'residentEmail': residentEmail.toLowerCase(),
      'residentName': residentName,
      'visitorName': visitorName,
      'visitorPhone': visitorPhone,
      'visitDate': visitDate.toIso8601String(),
      'expectedArrivalTime': expectedArrivalTime,
      'vehiclePlate': vehiclePlate,
      'status': status.toDbString(),
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
      residentEmail: entity.residentEmail,
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
}
