import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../repositories/customer_repository.dart';

class GetSavedDates {
  final CustomerRepository repository;

  GetSavedDates(this.repository);

  Future<Either<Failure, Map<DateTime, int>>> call() async {
    return await repository.getSavedDates();
  }
}
