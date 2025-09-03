import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/customer_entry.dart';
import '../repositories/customer_repository.dart';

class GetCustomers {
  final CustomerRepository repository;

  GetCustomers(this.repository);

  // This method now accepts an optional date
  Future<Either<Failure, List<CustomerEntry>>> call({DateTime? date}) async {
    if (date != null) {
      return await repository.getEntriesForDate(date);
    }
    return await repository.getAllCustomers();
  }
}
