import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/customer_entry.dart';
import '../../domain/usecases/add_customer.dart';
import '../../domain/usecases/delete_customer.dart';
import '../../domain/usecases/edit_customer.dart';
import '../../domain/usecases/get_customers.dart';
import '../../domain/usecases/save_customers.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final GetCustomers getCustomers;
  final SaveCustomers saveCustomers;
  final AddCustomer addCustomer;
  final EditCustomer editCustomer;
  final DeleteCustomer deleteCustomer;
  List<CustomerEntry> _allCustomers = [];

  CustomerBloc({
    required this.getCustomers,
    required this.saveCustomers,
    required this.addCustomer,
    required this.editCustomer,
    required this.deleteCustomer,
  }) : super(CustomerInitial()) {
    on<LoadCustomers>(_onLoadCustomers);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<SaveCustomersEvent>(_onSaveCustomers);
    on<AddNewCustomer>(onAddNewCustomer);
    on<EditExistingCustomer>(onEditExistingCustomer);
    on<DeleteCustomerEvent>(onDeleteCustomer);
  }

  Future<void> _onLoadCustomers(
    LoadCustomers event,
    Emitter<CustomerState> emit,
  ) async {
    emit(CustomerLoading());

    // Use the new get all customers use case
    final result = await getCustomers(date: null);

    result.fold(
      (failure) => emit(const CustomerError('Failed to load customers.')),
      (allCustomers) {
        _allCustomers = allCustomers;
        final activeCustomers = allCustomers
            .where((c) => c.quantity > 0)
            .toList();
        emit(
          CustomerLoaded(
            allCustomers: _allCustomers,
            activeCustomers: activeCustomers,
          ),
        );
      },
    );
  }

  void _onUpdateQuantity(UpdateQuantity event, Emitter<CustomerState> emit) {
    if (state is CustomerLoaded) {
      final updatedCustomers = _allCustomers.map((customer) {
        if (customer.name == event.customerName) {
          return CustomerEntry(
            name: customer.name,
            quantity: event.quantity,
            date: customer.date,
          );
        }
        return customer;
      }).toList();
      _allCustomers = updatedCustomers;
      final activeCustomers = updatedCustomers
          .where((c) => c.quantity > 0)
          .toList();
      emit(
        CustomerLoaded(
          allCustomers: updatedCustomers,
          activeCustomers: activeCustomers,
        ),
      );
    }
  }

  Future<void> _onSaveCustomers(
    SaveCustomersEvent event,
    Emitter<CustomerState> emit,
  ) async {
    if (state is CustomerLoaded) {
      final loadedState = state as CustomerLoaded;
      final customersToSave = loadedState.activeCustomers;
      final result = await saveCustomers(customersToSave);
      result.fold(
        (failure) => emit(const CustomerError('Failed to save entries')),
        (_) => emit(
          CustomerSaved(
            allCustomers: loadedState.allCustomers,
            activeCustomers: loadedState.activeCustomers,
          ),
        ),
      );
    }
  }

  Future<void> onAddNewCustomer(
    AddNewCustomer event,
    Emitter<CustomerState> emit,
  ) async {
    final result = await addCustomer(
      CustomerEntry(name: event.name, quantity: 0, date: DateTime.now()),
    );
    result.fold(
      (failure) => emit(const CustomerError('Failed to add customer.')),
      (_) {
        add(LoadCustomers());
      },
    );
  }

  Future<void> onEditExistingCustomer(
    EditExistingCustomer event,
    Emitter<CustomerState> emit,
  ) async {
    final customerToEdit = _allCustomers.firstWhere((c) => c.id == event.id);
    await editCustomer(
      CustomerEntry(
        id: event.id,
        name: event.newName,
        quantity: customerToEdit.quantity,
        date: customerToEdit.date,
      ),
    );
    add(LoadCustomers()); // Reload the list after editing
  }

  Future<void> onDeleteCustomer(
    DeleteCustomerEvent event,
    Emitter<CustomerState> emit,
  ) async {
    await deleteCustomer(event.id);
    add(LoadCustomers()); // Reload the list after deleting
  }
}
