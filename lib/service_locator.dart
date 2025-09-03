import 'package:get_it/get_it.dart';

import 'data/datasources/customer_local_data_source.dart';
import 'data/repositories/customer_repository_impl.dart';
import 'domain/repositories/customer_repository.dart';
import 'domain/usecases/add_customer.dart';
import 'domain/usecases/delete_customer.dart';
import 'domain/usecases/edit_customer.dart';
import 'domain/usecases/get_customers.dart';
import 'domain/usecases/save_customers.dart';
import 'presentation/bloc/customer_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Customer
  // BLoC
  sl.registerFactory(
    () => CustomerBloc(
      getCustomers: sl(),
      saveCustomers: sl(),
      addCustomer: sl(),
      deleteCustomer: sl(),
      editCustomer: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => AddCustomer(sl()));
  sl.registerLazySingleton(() => EditCustomer(sl()));
  sl.registerLazySingleton(() => DeleteCustomer(sl()));
  sl.registerLazySingleton(() => GetCustomers(sl()));
  sl.registerLazySingleton(() => SaveCustomers(sl()));

  // Repositories
  sl.registerLazySingleton<CustomerRepository>(
    () => CustomerRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton<CustomerLocalDataSource>(
    () => CustomerLocalDataSourceImpl(),
  );
}
