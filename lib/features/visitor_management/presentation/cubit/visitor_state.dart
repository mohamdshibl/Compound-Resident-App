import '../../domain/entities/visitor_pass_entity.dart';

abstract class VisitorState {
  const VisitorState();
}

class VisitorInitial extends VisitorState {
  const VisitorInitial();
}

class VisitorLoading extends VisitorState {
  const VisitorLoading();
}

class VisitorLoaded extends VisitorState {
  final List<VisitorPassEntity> passes;
  final String searchQuery;
  final bool isSubmitting;
  final VisitorPassEntity? lastCreatedPass;
  final String? successMessage;
  final String? errorMessage;

  const VisitorLoaded({
    required this.passes,
    this.searchQuery = '',
    this.isSubmitting = false,
    this.lastCreatedPass,
    this.successMessage,
    this.errorMessage,
  });

  List<VisitorPassEntity> get filteredPasses {
    final q = searchQuery.trim().toLowerCase();
    if (q.isEmpty) return passes;
    return passes.where((p) {
      return p.visitorName.toLowerCase().contains(q) ||
          (p.vehiclePlate?.toLowerCase().contains(q) ?? false) ||
          p.passCode.toLowerCase().contains(q) ||
          p.unitNumber.toLowerCase().contains(q) ||
          p.residentName.toLowerCase().contains(q);
    }).toList();
  }

  List<VisitorPassEntity> get expectedPasses => filteredPasses
      .where((p) => p.status == VisitorPassStatus.expected)
      .toList();

  List<VisitorPassEntity> get checkedInPasses => filteredPasses
      .where((p) => p.status == VisitorPassStatus.checkedIn)
      .toList();

  List<VisitorPassEntity> get historyPasses => filteredPasses
      .where(
        (p) =>
            p.status == VisitorPassStatus.checkedOut ||
            p.status == VisitorPassStatus.denied ||
            p.status == VisitorPassStatus.expired,
      )
      .toList();

  int get totalExpectedCount =>
      passes.where((p) => p.status == VisitorPassStatus.expected).length;

  int get totalCheckedInCount =>
      passes.where((p) => p.status == VisitorPassStatus.checkedIn).length;

  int get totalHistoryCount => passes
      .where(
        (p) =>
            p.status == VisitorPassStatus.checkedOut ||
            p.status == VisitorPassStatus.denied,
      )
      .length;

  VisitorLoaded copyWith({
    List<VisitorPassEntity>? passes,
    String? searchQuery,
    bool? isSubmitting,
    VisitorPassEntity? lastCreatedPass,
    bool clearLastCreated = false,
    String? successMessage,
    String? errorMessage,
  }) {
    return VisitorLoaded(
      passes: passes ?? this.passes,
      searchQuery: searchQuery ?? this.searchQuery,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      lastCreatedPass:
          clearLastCreated ? null : (lastCreatedPass ?? this.lastCreatedPass),
      successMessage: successMessage,
      errorMessage: errorMessage,
    );
  }
}

class VisitorError extends VisitorState {
  final String message;
  const VisitorError(this.message);
}
