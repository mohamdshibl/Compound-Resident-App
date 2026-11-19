import '../../domain/entities/visitor_pass_entity.dart';
import '../../domain/repositories/visitor_repository.dart';
import '../datasources/visitor_remote_data_source.dart';
import '../models/visitor_pass_model.dart';

class VisitorRepositoryImpl implements VisitorRepository {
  final VisitorRemoteDataSource remoteDataSource;

  VisitorRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<VisitorPassEntity>> streamMyPasses({
    required String residentEmail,
    String? residentId,
  }) {
    return remoteDataSource.streamMyPasses(
      residentEmail: residentEmail,
      residentId: residentId,
    );
  }

  @override
  Stream<List<VisitorPassEntity>> streamCompoundPasses({
    String compoundId = 'compound_al_mohamedia',
  }) {
    return remoteDataSource.streamCompoundPasses(compoundId: compoundId);
  }

  @override
  Future<List<VisitorPassEntity>> searchVisitors(
    String query, {
    String compoundId = 'compound_al_mohamedia',
  }) {
    return remoteDataSource.searchVisitors(query, compoundId: compoundId);
  }

  @override
  Future<VisitorPassEntity> createVisitorPass(VisitorPassEntity pass) {
    return remoteDataSource
        .createVisitorPass(VisitorPassModel.fromEntity(pass));
  }

  @override
  Future<void> checkIn(String passId, {String? securityNotes}) {
    return remoteDataSource.checkIn(passId, securityNotes: securityNotes);
  }

  @override
  Future<void> checkOut(String passId, {String? securityNotes}) {
    return remoteDataSource.checkOut(passId, securityNotes: securityNotes);
  }

  @override
  Future<void> denyEntry(String passId, {required String notes}) {
    return remoteDataSource.denyEntry(passId, notes: notes);
  }
}
