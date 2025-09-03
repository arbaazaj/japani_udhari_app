part of 'customer_bloc.dart';

abstract class CustomerState extends Equatable {
  const CustomerState();

  @override
  List<Object> get props => [];
}

class CustomerInitial extends CustomerState {}

class CustomerLoading extends CustomerState {}

class CustomerLoaded extends CustomerState {
  final List<CustomerEntry> allCustomers;
  final List<CustomerEntry> activeCustomers;

  const CustomerLoaded({
    required this.allCustomers,
    required this.activeCustomers,
  });

  @override
  List<Object> get props => [allCustomers, activeCustomers];
}

class CustomerSaved extends CustomerState {
  final List<CustomerEntry> allCustomers;
  final List<CustomerEntry> activeCustomers;

  const CustomerSaved({
    required this.allCustomers,
    required this.activeCustomers,
  });

  @override
  List<Object> get props => [allCustomers, activeCustomers];
}

class CustomerError extends CustomerState {
  final String message;

  const CustomerError(this.message);

  @override
  List<Object> get props => [message];
}
