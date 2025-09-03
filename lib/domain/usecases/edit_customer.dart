import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/customer_entry.dart';
import '../repositories/customer_repository.dart';

class EditCustomer {
  final CustomerRepository repository;

  EditCustomer(this.repository);

  Future<Either<Failure, void>> call(CustomerEntry customer) async {
    return await repository.editCustomer(customer);
  }
}