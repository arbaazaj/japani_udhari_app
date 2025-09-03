import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/customer_bloc.dart';

class CustomerChip extends StatelessWidget {
  final String name;
  final int quantity;

  const CustomerChip({super.key, required this.name, required this.quantity});

  @override
  Widget build(BuildContext context) {
    return RawChip(
      label: Text(name),
      avatar: CircleAvatar(child: Text('$quantity')),
      onPressed: () {
        context.read<CustomerBloc>().add(
          UpdateQuantity(customerName: name, quantity: quantity + 1),
        );
      },
      deleteIcon: const Icon(Icons.remove_circle_outline),
      onDeleted: quantity > 0
          ? () {
              context.read<CustomerBloc>().add(
                UpdateQuantity(customerName: name, quantity: quantity - 1),
              );
            }
          : null,
    );
  }
}
