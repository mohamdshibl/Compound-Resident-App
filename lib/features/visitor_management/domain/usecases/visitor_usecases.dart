import '../entities/visitor_pass_entity.dart';
import '../repositories/visitor_repository.dart';

class GetMyPassesUseCase {
  final VisitorRepository _repository;
  GetMyPassesUseCase(this._repository);

  Stream<List<VisitorPassEntity>> call(String residentId) =>
      _repository.getMyPasses(residentId);
}

class GetExpectedVisitorsUseCase {
  final VisitorRepository _repository;
  GetExpectedVisitorsUseCase(this._repository);

  Stream<List<VisitorPassEntity>> call() => _repository.getExpectedVisitors();
}

class GetCheckedInVisitorsUseCase {
  final VisitorRepository _repository;
  GetCheckedInVisitorsUseCase(this._repository);

  Stream<List<VisitorPassEntity>> call() => _repository.getCheckedInVisitors();
}

class SearchVisitorsUseCase {
  final VisitorRepository _repository;
  SearchVisitorsUseCase(this._repository);

  Future<List<VisitorPassEntity>> call(String query) =>
      _repository.searchVisitors(query);
}

class CreateVisitorPassUseCase {
  final VisitorRepository _repository;
  CreateVisitorPassUseCase(this._repository);

  Future<VisitorPassEntity> call(VisitorPassEntity pass) =>
      _repository.createVisitorPass(pass);
}

class CheckInUseCase {
  final VisitorRepository _repository;
  CheckInUseCase(this._repository);

  Future<VisitorPassEntity> call(String passId, {String? notes}) =>
      _repository.checkIn(passId, securityNotes: notes);
}

class CheckOutUseCase {
  final VisitorRepository _repository;
  CheckOutUseCase(this._repository);

  Future<VisitorPassEntity> call(String passId, {String? notes}) =>
      _repository.checkOut(passId, securityNotes: notes);
}

class DenyEntryUseCase {
  final VisitorRepository _repository;
  DenyEntryUseCase(this._repository);

  Future<VisitorPassEntity> call(String passId, {required String notes}) =>
      _repository.denyEntry(passId, notes: notes);
}
