import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:japani_udhari_app/presentation/bloc/customer/customer_bloc.dart';
import 'package:japani_udhari_app/presentation/pages/summary_screen.dart';

import 'presentation/bloc/summary/summary_bloc.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<CustomerBloc>()..add(LoadCustomers()),
        ),
        BlocProvider(
          create: (context) => di.sl<SummaryBloc>()..add(LoadSummary()),
        ),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Japani Udhari',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: SummaryScreen(),
      ),
    );
  }
}
