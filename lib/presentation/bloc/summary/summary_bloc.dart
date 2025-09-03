import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_saved_dates.dart';

part 'summary_event.dart';
part 'summary_state.dart';

class SummaryBloc extends Bloc<SummaryEvent, SummaryState> {
  final GetSavedDates getSavedDates;

  SummaryBloc({required this.getSavedDates}) : super(SummaryInitial()) {
    on<LoadSummary>(_onLoadSummary);
  }

  Future<void> _onLoadSummary(
    LoadSummary event,
    Emitter<SummaryState> emit,
  ) async {
    emit(SummaryLoading());
    final result = await getSavedDates();
    result.fold(
      (failure) => emit(const SummaryError('Failed to load summary.')),
      (datesWithTotalQuantity) {
        emit(SummaryLoaded(savedDates: datesWithTotalQuantity));
      },
    );
  }
}
