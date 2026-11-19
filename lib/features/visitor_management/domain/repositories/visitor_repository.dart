import '../entities/visitor_pass_entity.dart';

abstract class VisitorRepository {

  /// Live Firestore stream of visitor passes for a specific resident.
  Stream<List<VisitorPassEntity>> streamMyPasses({
    required String residentEmail,
    String? residentId,
  });


  /// Live Firestore stream of all compound visitor passes (for Security & staff).
  Stream<List<VisitorPassEntity>> streamCompoundPasses({
    String compoundId = 'compound_al_mohamedia',
  });


  /// Search visitor passes by vehicle plate, visitor name, passCode, or unit.
  Future<List<VisitorPassEntity>> searchVisitors(
    String query, {
    String compoundId = 'compound_al_mohamedia',
  });

  /// Create a new visitor pass in Cloud Firestore.
  Future<VisitorPassEntity> createVisitorPass(VisitorPassEntity pass);


  /// Check in an expected visitor at the gate.
  Future<void> checkIn(String passId, {String? securityNotes});


  /// Check out a visitor leaving the compound.
  Future<void> checkOut(String passId, {String? securityNotes});


  /// Deny entry to a visitor at the gate.
  Future<void> denyEntry(String passId, {required String notes});
}
