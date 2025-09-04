import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../bloc/customer/customer_bloc.dart';
import '../widgets/customer_chip.dart';
import 'manage_customers_screen.dart';

class CustomerScreen extends StatelessWidget {
  final DateTime date;

  const CustomerScreen({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('EEE, dd MMM').format(date);

    // Load customers for the specific date when screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CustomerBloc>().add(LoadCustomers(date: date));
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          formattedDate,
          style: TextStyle(
            color: Colors.blue,
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              context.read<CustomerBloc>().add(SaveCustomersEvent(date: date));
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              Get.to(() => ManageCustomersScreen());
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<CustomerBloc>().add(
            SaveCustomersEvent(date: date),
          );
        },
        child: const Icon(Icons.save),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    spacing: 16.0, // horizontal space between chips
                    runSpacing: 8.0, // vertical space between lines of chips
                    children: state.allCustomers.map((customer) {
                      return CustomerChip(
                        name: customer.name,
                        quantity: customer.quantity,
                      );
                    }).toList(),
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
