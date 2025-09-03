import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/customer_entry.dart';

abstract class CustomerRepository {
  Future<Either<Failure, void>> saveEntries(List<CustomerEntry> entries);

  Future<Either<Failure, Map<DateTime, int>>> getSavedDates();

  Future<Either<Failure, List<CustomerEntry>>> getEntriesForDate(DateTime date);

  Future<Either<Failure, List<CustomerEntry>>> getAllCustomers();

  Future<Either<Failure, void>> addCustomer(CustomerEntry customer);

  Future<Either<Failure, void>> editCustomer(CustomerEntry customer);

  Future<Either<Failure, void>> deleteCustomer(int id);
}
