import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/customer_bloc.dart';
import '../widgets/customer_chip.dart';
import 'manage_customers_screen.dart';

class CustomerScreen extends StatelessWidget {
  const CustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Udhari App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ManageCustomersScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              context.read<CustomerBloc>().add(SaveCustomersEvent());
            },
          ),
        ],
      ),
      body: BlocConsumer<CustomerBloc, CustomerState>(
        listener: (context, state) {
          if (state is CustomerSaved) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Entries saved successfully!')),
            );
          } else if (state is CustomerError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is CustomerLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CustomerLoaded) {
            return Column(
              children: [
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.allCustomers.length,
                    itemBuilder: (context, index) {
                      final customer = state.allCustomers[index];
                      return CustomerChip(
                        name: customer.name,
                        quantity: customer.quantity,
                      );
                    },
                  ),
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.activeCustomers.length,
                    itemBuilder: (context, index) {
                      final activeCustomer = state.activeCustomers[index];
                      return ListTile(
                        title: Text(activeCustomer.name),
                        trailing: Text('${activeCustomer.quantity} jars'),
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (state is CustomerSaved) {
            return Column(
              children: [
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.allCustomers.length,
                    itemBuilder: (context, index) {
                      final customer = state.allCustomers[index];
                      return CustomerChip(
                        name: customer.name,
                        quantity: customer.quantity,
                      );
                    },
                  ),
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.activeCustomers.length,
                    itemBuilder: (context, index) {
                      final activeCustomer = state.activeCustomers[index];
                      return ListTile(
                        title: Text(activeCustomer.name),
                        trailing: Text('${activeCustomer.quantity} jars'),
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
