import '../entities/visitor_pass_entity.dart';
import '../repositories/visitor_repository.dart';

class GetMyPassesUseCase {
  final VisitorRepository _repository;
  const GetMyPassesUseCase(this._repository);

  Stream<List<VisitorPassEntity>> call({
    required String residentEmail,
    String? residentId,
  }) =>
      _repository.streamMyPasses(
        residentEmail: residentEmail,
        residentId: residentId,
      );
}

class GetCompoundPassesUseCase {
  final VisitorRepository _repository;
  const GetCompoundPassesUseCase(this._repository);

  Stream<List<VisitorPassEntity>> call({
    String compoundId = 'compound_al_mohamedia',
  }) =>
      _repository.streamCompoundPasses(compoundId: compoundId);
}

class SearchVisitorsUseCase {
  final VisitorRepository _repository;
  const SearchVisitorsUseCase(this._repository);

  Future<List<VisitorPassEntity>> call(
    String query, {
    String compoundId = 'compound_al_mohamedia',
  }) =>
      _repository.searchVisitors(query, compoundId: compoundId);
}

class CreateVisitorPassUseCase {
  final VisitorRepository _repository;
  const CreateVisitorPassUseCase(this._repository);

  Future<VisitorPassEntity> call(VisitorPassEntity pass) =>
      _repository.createVisitorPass(pass);
}

class CheckInVisitorUseCase {
  final VisitorRepository _repository;
  const CheckInVisitorUseCase(this._repository);

  Future<void> call(String passId, {String? notes}) =>
      _repository.checkIn(passId, securityNotes: notes);
}

class CheckOutVisitorUseCase {
  final VisitorRepository _repository;
  const CheckOutVisitorUseCase(this._repository);

  Future<void> call(String passId, {String? notes}) =>
      _repository.checkOut(passId, securityNotes: notes);
}

class DenyVisitorEntryUseCase {
  final VisitorRepository _repository;
  const DenyVisitorEntryUseCase(this._repository);

  Future<void> call(String passId, {required String notes}) =>
      _repository.denyEntry(passId, notes: notes);
}
