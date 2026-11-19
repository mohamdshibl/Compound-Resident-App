import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/visitor_pass_entity.dart';
import '../models/visitor_pass_model.dart';

abstract class VisitorRemoteDataSource {
  Stream<List<VisitorPassModel>> streamMyPasses({
    required String residentEmail,
    String? residentId,
  });

  Stream<List<VisitorPassModel>> streamCompoundPasses({
    String compoundId = 'compound_al_mohamedia',
  });

  Future<List<VisitorPassModel>> searchVisitors(
    String query, {
    String compoundId = 'compound_al_mohamedia',
  });

  Future<VisitorPassModel> createVisitorPass(VisitorPassModel pass);

  Future<void> checkIn(String passId, {String? securityNotes});

  Future<void> checkOut(String passId, {String? securityNotes});

  Future<void> denyEntry(String passId, {required String notes});
}

class VisitorRemoteDataSourceImpl implements VisitorRemoteDataSource {
  final FirebaseFirestore _firestore;

  VisitorRemoteDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _passesCol =>
      _firestore.collection('visitor_passes');

  List<VisitorPassModel> _mapAndSort(
    QuerySnapshot<Map<String, dynamic>> snapshot,
  ) {
    final list = snapshot.docs
        .map((d) => VisitorPassModel.fromJson(d.data(), id: d.id))
        .toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  @override
  Stream<List<VisitorPassModel>> streamMyPasses({
    required String residentEmail,
    String? residentId,
  }) {
    Query<Map<String, dynamic>> query = _passesCol;
    if (residentEmail.isNotEmpty) {
      query = query.where(
        'residentEmail',
        isEqualTo: residentEmail.trim().toLowerCase(),
      );
    } else if (residentId != null && residentId.isNotEmpty) {
      query = query.where('residentId', isEqualTo: residentId);
    }

    return query.limit(20).snapshots().map(_mapAndSort);
  }

  @override
  Stream<List<VisitorPassModel>> streamCompoundPasses({
    String compoundId = 'compound_al_mohamedia',
  }) {
    return _passesCol
        .where('compoundId', isEqualTo: compoundId)
        .limit(20)
        .snapshots()
        .map(_mapAndSort);
  }

  @override
  Future<List<VisitorPassModel>> searchVisitors(
    String query, {
    String compoundId = 'compound_al_mohamedia',
  }) async {
    final snapshot = await _passesCol
        .where('compoundId', isEqualTo: compoundId)
        .limit(20)
        .get();
    final all = _mapAndSort(snapshot);
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return all;

    return all.where((p) {
      return p.visitorName.toLowerCase().contains(q) ||
          (p.vehiclePlate?.toLowerCase().contains(q) ?? false) ||
          p.passCode.toLowerCase().contains(q) ||
          p.unitNumber.toLowerCase().contains(q) ||
          p.residentName.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Future<VisitorPassModel> createVisitorPass(VisitorPassModel pass) async {
    final generatedCode = pass.passCode.isNotEmpty
        ? pass.passCode
        : 'VP-${1000 + Random().nextInt(8999)}';

    final model = VisitorPassModel.fromEntity(
      pass.copyWith(
        passCode: generatedCode,
        residentEmail: pass.residentEmail.trim().toLowerCase(),
        status: VisitorPassStatus.expected,
      ),
    );

    await _passesCol.doc(model.id).set(model.toJson());
    return model;
  }

  @override
  Future<void> checkIn(String passId, {String? securityNotes}) async {
    final updateData = <String, dynamic>{
      'status': VisitorPassStatus.checkedIn.toDbString(),
      'checkInTime': DateTime.now().toIso8601String(),
    };
    if (securityNotes != null && securityNotes.trim().isNotEmpty) {
      updateData['securityNotes'] = securityNotes.trim();
    }
    await _passesCol.doc(passId).update(updateData);
  }

  @override
  Future<void> checkOut(String passId, {String? securityNotes}) async {
    final updateData = <String, dynamic>{
      'status': VisitorPassStatus.checkedOut.toDbString(),
      'checkOutTime': DateTime.now().toIso8601String(),
    };
    if (securityNotes != null && securityNotes.trim().isNotEmpty) {
      updateData['securityNotes'] = securityNotes.trim();
    }
    await _passesCol.doc(passId).update(updateData);
  }

  @override
  Future<void> denyEntry(String passId, {required String notes}) async {
    await _passesCol.doc(passId).update({
      'status': VisitorPassStatus.denied.toDbString(),
      'securityNotes': notes.trim(),
    });
  }
}
