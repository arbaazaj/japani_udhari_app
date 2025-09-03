part of 'customer_bloc.dart';

abstract class CustomerEvent extends Equatable {
  const CustomerEvent();

  @override
  List<Object> get props => [];
}

class AddNewCustomer extends CustomerEvent {
  final String name;

  const AddNewCustomer(this.name);

  @override
  List<Object> get props => [name];
}

class EditExistingCustomer extends CustomerEvent {
  final int id;
  final String newName;

  const EditExistingCustomer({required this.id, required this.newName});

  @override
  List<Object> get props => [id, newName];
}

class DeleteCustomerEvent extends CustomerEvent {
  final int id;

  const DeleteCustomerEvent(this.id);

  @override
  List<Object> get props => [id];
}

class LoadCustomers extends CustomerEvent {}

class UpdateQuantity extends CustomerEvent {
  final String customerName;
  final int quantity;

  const UpdateQuantity({required this.customerName, required this.quantity});

  @override
  List<Object> get props => [customerName, quantity];
}

class SaveCustomersEvent extends CustomerEvent {
  final DateTime date;

  const SaveCustomersEvent({required this.date});

  @override
  List<Object> get props => [date];
}
