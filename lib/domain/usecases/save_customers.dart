import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/customer_entry.dart';
import '../repositories/customer_repository.dart';

class SaveCustomers {
  final CustomerRepository repository;

  SaveCustomers(this.repository);

  Future<Either<Failure, void>> call(List<CustomerEntry> entries) async {
    return await repository.saveEntries(entries);
  }
}
