import 'dart:async';
import 'dart:math';
import '../../domain/entities/visitor_pass_entity.dart';
import '../models/visitor_pass_model.dart';

abstract class VisitorRemoteDataSource {
  Stream<List<VisitorPassEntity>> getMyPasses(String residentId);
  Stream<List<VisitorPassEntity>> getExpectedVisitors();
  Stream<List<VisitorPassEntity>> getCheckedInVisitors();
  Future<List<VisitorPassEntity>> searchVisitors(String query);
  Future<VisitorPassEntity> createVisitorPass(VisitorPassEntity pass);
  Future<VisitorPassEntity> checkIn(String passId, {String? securityNotes});
  Future<VisitorPassEntity> checkOut(String passId, {String? securityNotes});
  Future<VisitorPassEntity> denyEntry(String passId, {required String notes});
}

/// In-memory implementation with realistic seed data.
/// Emits via StreamControllers so the UI stays reactive.
/// A Firestore implementation can be dropped in without touching any other layer.
class VisitorRemoteDataSourceImpl implements VisitorRemoteDataSource {
  final List<VisitorPassModel> _store = _seedData();

  // Stream controllers per listener type
  final _expectedController =
      StreamController<List<VisitorPassEntity>>.broadcast();
  final _checkedInController =
      StreamController<List<VisitorPassEntity>>.broadcast();
  final Map<String, StreamController<List<VisitorPassEntity>>>
      _residentControllers = {};

  VisitorRemoteDataSourceImpl() {
    _pushAll();
  }

  // ── Internal helpers ────────────────────────────────────────────────────────

  void _pushAll() {
    final now = DateTime.now();
    _expectedController.add(
      _store
          .where((p) =>
              p.status == VisitorPassStatus.expected &&
              p.visitDate.isAfter(now.subtract(const Duration(hours: 12))))
          .toList(),
    );
    _checkedInController.add(
      _store.where((p) => p.status == VisitorPassStatus.checkedIn).toList(),
    );
    for (final entry in _residentControllers.entries) {
      entry.value
          .add(_store.where((p) => p.residentId == entry.key).toList());
    }
  }

  int _indexOf(String passId) =>
      _store.indexWhere((p) => p.id == passId);

  // ── Public interface ────────────────────────────────────────────────────────

  @override
  Stream<List<VisitorPassEntity>> getMyPasses(String residentId) {
    _residentControllers.putIfAbsent(
      residentId,
      () => StreamController<List<VisitorPassEntity>>.broadcast(),
    );
    // Emit current snapshot immediately
    Future.microtask(() {
      _residentControllers[residentId]?.add(
        _store.where((p) => p.residentId == residentId).toList(),
      );
    });
    return _residentControllers[residentId]!.stream;
  }

  @override
  Stream<List<VisitorPassEntity>> getExpectedVisitors() {
    Future.microtask(() {
      final now = DateTime.now();
      _expectedController.add(
        _store
            .where((p) =>
                p.status == VisitorPassStatus.expected &&
                p.visitDate.isAfter(now.subtract(const Duration(hours: 12))))
            .toList(),
      );
    });
    return _expectedController.stream;
  }

  @override
  Stream<List<VisitorPassEntity>> getCheckedInVisitors() {
    Future.microtask(() {
      _checkedInController.add(
        _store.where((p) => p.status == VisitorPassStatus.checkedIn).toList(),
      );
    });
    return _checkedInController.stream;
  }

  @override
  Future<List<VisitorPassEntity>> searchVisitors(String query) async {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) return List.unmodifiable(_store);
    return _store.where((p) {
      return p.visitorName.toLowerCase().contains(q) ||
          (p.vehiclePlate?.toLowerCase().contains(q) ?? false) ||
          p.passCode.toLowerCase().contains(q) ||
          p.unitNumber.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Future<VisitorPassEntity> createVisitorPass(VisitorPassEntity pass) async {
    final code = 'VP-${1000 + Random().nextInt(8999)}';
    final model = VisitorPassModel(
      id: pass.id,
      passCode: code,
      compoundId: pass.compoundId,
      unitId: pass.unitId,
      unitNumber: pass.unitNumber,
      residentId: pass.residentId,
      residentName: pass.residentName,
      visitorName: pass.visitorName,
      visitorPhone: pass.visitorPhone,
      visitDate: pass.visitDate,
      expectedArrivalTime: pass.expectedArrivalTime,
      vehiclePlate: pass.vehiclePlate,
      status: VisitorPassStatus.expected,
      createdAt: DateTime.now(),
    );
    _store.insert(0, model);
    _pushAll();
    return model;
  }

  @override
  Future<VisitorPassEntity> checkIn(
    String passId, {
    String? securityNotes,
  }) async {
    final idx = _indexOf(passId);
    if (idx == -1) throw Exception('Pass not found: $passId');
    final updated = VisitorPassModel.fromEntity(
      _store[idx].copyWith(
        status: VisitorPassStatus.checkedIn,
        checkInTime: DateTime.now(),
        securityNotes: securityNotes,
      ),
    );
    _store[idx] = updated;
    _pushAll();
    return updated;
  }

  @override
  Future<VisitorPassEntity> checkOut(
    String passId, {
    String? securityNotes,
  }) async {
    final idx = _indexOf(passId);
    if (idx == -1) throw Exception('Pass not found: $passId');
    final updated = VisitorPassModel.fromEntity(
      _store[idx].copyWith(
        status: VisitorPassStatus.checkedOut,
        checkOutTime: DateTime.now(),
        securityNotes: securityNotes,
      ),
    );
    _store[idx] = updated;
    _pushAll();
    return updated;
  }

  @override
  Future<VisitorPassEntity> denyEntry(
    String passId, {
    required String notes,
  }) async {
    final idx = _indexOf(passId);
    if (idx == -1) throw Exception('Pass not found: $passId');
    final updated = VisitorPassModel.fromEntity(
      _store[idx].copyWith(
        status: VisitorPassStatus.denied,
        securityNotes: notes,
      ),
    );
    _store[idx] = updated;
    _pushAll();
    return updated;
  }

  // ── Seed data ───────────────────────────────────────────────────────────────

  static List<VisitorPassModel> _seedData() {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    return [
      // Expected visitor for Dr. Tarek
      VisitorPassModel(
        id: 'vp-001',
        passCode: 'VP-4823',
        compoundId: 'compound-001',
        unitId: 'unit-v104',
        unitNumber: 'V-104',
        residentId: 'demo-owner',
        residentName: 'Dr. Tarek Mansour',
        visitorName: 'Khalid Al-Ghamdi',
        visitorPhone: '+966 50 123 4567',
        visitDate: todayDate,
        expectedArrivalTime: '18:30',
        vehiclePlate: 'ABC 4567',
        status: VisitorPassStatus.expected,
        createdAt: today.subtract(const Duration(hours: 2)),
      ),
      // Expected visitor for Sara
      VisitorPassModel(
        id: 'vp-002',
        passCode: 'VP-7291',
        compoundId: 'compound-001',
        unitId: 'unit-b2301',
        unitNumber: 'B2-301',
        residentId: 'demo-tenant',
        residentName: 'Sara Al-Husseini',
        visitorName: 'Fahad Al-Shehri',
        visitorPhone: '+966 55 987 6543',
        visitDate: todayDate,
        expectedArrivalTime: '19:15',
        vehiclePlate: 'XYZ 9921',
        status: VisitorPassStatus.expected,
        createdAt: today.subtract(const Duration(hours: 5)),
      ),
      // Already checked-in visitor
      VisitorPassModel(
        id: 'vp-003',
        passCode: 'VP-3344',
        compoundId: 'compound-001',
        unitId: 'unit-v104',
        unitNumber: 'V-104',
        residentId: 'demo-owner',
        residentName: 'Dr. Tarek Mansour',
        visitorName: 'Noura Al-Salem',
        visitorPhone: '+966 56 444 5555',
        visitDate: todayDate,
        expectedArrivalTime: '14:00',
        vehiclePlate: 'MNO 1122',
        status: VisitorPassStatus.checkedIn,
        checkInTime: today.subtract(const Duration(hours: 3)),
        createdAt: today.subtract(const Duration(hours: 10)),
      ),
      // Yesterday — checked out
      VisitorPassModel(
        id: 'vp-004',
        passCode: 'VP-6612',
        compoundId: 'compound-001',
        unitId: 'unit-b2301',
        unitNumber: 'B2-301',
        residentId: 'demo-tenant',
        residentName: 'Sara Al-Husseini',
        visitorName: 'Mohammed Al-Rashid',
        visitorPhone: '+966 50 777 8888',
        visitDate: todayDate.subtract(const Duration(days: 1)),
        expectedArrivalTime: '20:00',
        vehiclePlate: 'QRS 5566',
        status: VisitorPassStatus.checkedOut,
        checkInTime:
            today.subtract(const Duration(days: 1, hours: 3)),
        checkOutTime:
            today.subtract(const Duration(days: 1, hours: 1)),
        createdAt: today.subtract(const Duration(days: 2)),
      ),
    ];
  }
}
