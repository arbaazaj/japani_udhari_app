import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japani_udhari_app/presentation/bloc/customer_bloc.dart';
import 'package:japani_udhari_app/presentation/pages/customer_screen.dart';

import 'service_locator.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<CustomerBloc>()..add(LoadCustomers()),
      child: MaterialApp(
        title: 'Japani Udhari',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: CustomerScreen(),
      ),
    );
  }
}
