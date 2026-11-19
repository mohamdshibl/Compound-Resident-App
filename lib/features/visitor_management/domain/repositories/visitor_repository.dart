import '../entities/visitor_pass_entity.dart';

abstract class VisitorRepository {
  /// Stream of all visitor passes for a specific resident.
  Stream<List<VisitorPassEntity>> getMyPasses(String residentId);

  /// Stream of all expected/active visitors for security (today + future).
  Stream<List<VisitorPassEntity>> getExpectedVisitors();

  /// Stream of all currently checked-in visitors.
  Stream<List<VisitorPassEntity>> getCheckedInVisitors();

  /// Search by vehicle plate or visitor name (for security gate).
  Future<List<VisitorPassEntity>> searchVisitors(String query);

  /// Create a new visitor pass.
  Future<VisitorPassEntity> createVisitorPass(VisitorPassEntity pass);

  /// Check in a visitor.
  Future<VisitorPassEntity> checkIn(String passId, {String? securityNotes});

  /// Check out a visitor.
  Future<VisitorPassEntity> checkOut(String passId, {String? securityNotes});

  /// Deny a visitor entry.
  Future<VisitorPassEntity> denyEntry(String passId, {required String notes});
}
