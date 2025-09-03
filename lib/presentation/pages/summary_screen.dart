import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../bloc/summary/summary_bloc.dart';
import 'customer_screen.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Japani Udhari')),
      body: BlocBuilder<SummaryBloc, SummaryState>(
        builder: (context, state) {
          if (state is SummaryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SummaryLoaded) {
            final sortedDates = state.savedDates.keys.toList()
              ..sort((a, b) => b.compareTo(a));
            return ListView.builder(
              itemCount: sortedDates.length,
              itemBuilder: (context, index) {
                final date = sortedDates[index];
                final totalQuantity = state.savedDates[date];
                return ListTile(
                  title: Text(DateFormat('EEE, dd MMM').format(date)),
                  subtitle: Text('Total Udhari: $totalQuantity'),
                  onTap: () {
                    Get.to(() => CustomerScreen(date: date));
                  },
                );
              },
            );
          } else if (state is SummaryError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => CustomerScreen(date: DateTime.now()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
