import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/visitor_pass_entity.dart';
import '../../domain/usecases/visitor_usecases.dart';
import 'visitor_state.dart';

class VisitorCubit extends Cubit<VisitorState> {
  final GetMyPassesUseCase _getMyPassesUseCase;
  final GetCompoundPassesUseCase _getCompoundPassesUseCase;
  final CreateVisitorPassUseCase _createVisitorPassUseCase;
  final CheckInVisitorUseCase _checkInVisitorUseCase;
  final CheckOutVisitorUseCase _checkOutVisitorUseCase;
  final DenyVisitorEntryUseCase _denyVisitorEntryUseCase;

  StreamSubscription<List<VisitorPassEntity>>? _passesSub;

  VisitorCubit({
    required GetMyPassesUseCase getMyPassesUseCase,
    required GetCompoundPassesUseCase getCompoundPassesUseCase,
    required CreateVisitorPassUseCase createVisitorPassUseCase,
    required CheckInVisitorUseCase checkInVisitorUseCase,
    required CheckOutVisitorUseCase checkOutVisitorUseCase,
    required DenyVisitorEntryUseCase denyVisitorEntryUseCase,
  })  : _getMyPassesUseCase = getMyPassesUseCase,
        _getCompoundPassesUseCase = getCompoundPassesUseCase,
        _createVisitorPassUseCase = createVisitorPassUseCase,
        _checkInVisitorUseCase = checkInVisitorUseCase,
        _checkOutVisitorUseCase = checkOutVisitorUseCase,
        _denyVisitorEntryUseCase = denyVisitorEntryUseCase,
        super(const VisitorInitial());

  void listenToMyPasses({
    required String residentEmail,
    String? residentId,
  }) {
    emit(const VisitorLoading());
    _passesSub?.cancel();

    _passesSub = _getMyPassesUseCase(
      residentEmail: residentEmail,
      residentId: residentId,
    ).listen(
      (passes) {
        if (state is VisitorLoaded) {
          emit((state as VisitorLoaded).copyWith(passes: passes));
        } else {
          emit(VisitorLoaded(passes: passes));
        }
      },
      onError: (err) {
        emit(VisitorError(err.toString()));
      },
    );
  }

  void listenToCompoundPasses({
    String compoundId = 'compound_al_mohamedia',
  }) {
    emit(const VisitorLoading());
    _passesSub?.cancel();

    _passesSub = _getCompoundPassesUseCase(compoundId: compoundId).listen(
      (passes) {
        if (state is VisitorLoaded) {
          emit((state as VisitorLoaded).copyWith(passes: passes));
        } else {
          emit(VisitorLoaded(passes: passes));
        }
      },
      onError: (err) {
        emit(VisitorError(err.toString()));
      },
    );
  }

  void setSearchQuery(String query) {
    if (state is VisitorLoaded) {
      emit((state as VisitorLoaded).copyWith(searchQuery: query));
    }
  }

  void clear() {
    _passesSub?.cancel();
    emit(const VisitorInitial());
  }

  Future<void> createPass(VisitorPassEntity pass) async {
    final cur = state is VisitorLoaded
        ? state as VisitorLoaded
        : const VisitorLoaded(passes: []);
    emit(cur.copyWith(isSubmitting: true, clearLastCreated: true));

    try {
      final created = await _createVisitorPassUseCase(pass);
      final latest = state is VisitorLoaded ? state as VisitorLoaded : cur;
      emit(latest.copyWith(
        isSubmitting: false,
        lastCreatedPass: created,
        successMessage: 'Visitor pass ${created.passCode} created!',
      ));
    } catch (e) {
      final latest = state is VisitorLoaded ? state as VisitorLoaded : cur;
      emit(latest.copyWith(
        isSubmitting: false,
        errorMessage: 'Failed to create visitor pass: $e',
      ));
    }
  }

  Future<void> checkIn(String passId, {String? notes}) async {
    try {
      await _checkInVisitorUseCase(passId, notes: notes);
      if (state is VisitorLoaded) {
        emit((state as VisitorLoaded).copyWith(
          successMessage: 'Visitor checked in at gate.',
        ));
      }
    } catch (e) {
      if (state is VisitorLoaded) {
        emit((state as VisitorLoaded).copyWith(
          errorMessage: 'Check-in failed: $e',
        ));
      }
    }
  }

  Future<void> checkOut(String passId, {String? notes}) async {
    try {
      await _checkOutVisitorUseCase(passId, notes: notes);
      if (state is VisitorLoaded) {
        emit((state as VisitorLoaded).copyWith(
          successMessage: 'Visitor checked out.',
        ));
      }
    } catch (e) {
      if (state is VisitorLoaded) {
        emit((state as VisitorLoaded).copyWith(
          errorMessage: 'Check-out failed: $e',
        ));
      }
    }
  }

  Future<void> denyEntry(String passId, {required String notes}) async {
    try {
      await _denyVisitorEntryUseCase(passId, notes: notes);
      if (state is VisitorLoaded) {
        emit((state as VisitorLoaded).copyWith(
          successMessage: 'Visitor entry denied.',
        ));
      }
    } catch (e) {
      if (state is VisitorLoaded) {
        emit((state as VisitorLoaded).copyWith(
          errorMessage: 'Failed to deny entry: $e',
        ));
      }
    }
  }

  @override
  Future<void> close() {
    _passesSub?.cancel();
    return super.close();
  }
}
