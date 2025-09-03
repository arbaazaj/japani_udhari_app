import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/customer_entry.dart';
import '../bloc/customer_bloc.dart';

class ManageCustomersScreen extends StatelessWidget {
  const ManageCustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Customers')),
      body: BlocBuilder<CustomerBloc, CustomerState>(
        builder: (context, state) {
          if (state is CustomerLoaded) {
            return ListView.builder(
              itemCount: state.allCustomers.length,
              itemBuilder: (context, index) {
                final customer = state.allCustomers[index];
                return ListTile(
                  title: Text(customer.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showEditDialog(context, customer),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _showDeleteDialog(context, customer),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Customer'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter customer name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<CustomerBloc>().add(
                  AddNewCustomer(controller.text),
                );
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, CustomerEntry customer) {
    final TextEditingController controller = TextEditingController(
      text: customer.name,
    );
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Customer'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter new name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<CustomerBloc>().add(
                  EditExistingCustomer(
                    id: customer.id!,
                    newName: controller.text,
                  ),
                );
                Navigator.of(context).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, CustomerEntry customer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Customer'),
        content: Text('Are you sure you want to delete ${customer.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<CustomerBloc>().add(
                DeleteCustomerEvent(customer.id!),
              );
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
