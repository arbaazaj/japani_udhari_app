part of 'summary_bloc.dart';

abstract class SummaryState extends Equatable {
  const SummaryState();

  @override
  List<Object> get props => [];
}

class SummaryInitial extends SummaryState {}

class SummaryLoading extends SummaryState {}

class SummaryLoaded extends SummaryState {
  final Map<DateTime, int> savedDates;

  const SummaryLoaded({required this.savedDates});

  @override
  List<Object> get props => [savedDates];
}

class SummaryError extends SummaryState {
  final String message;

  const SummaryError(this.message);

  @override
  List<Object> get props => [message];
}
