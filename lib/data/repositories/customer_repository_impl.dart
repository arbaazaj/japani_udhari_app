import 'package:dartz/dartz.dart';

import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/customer_entry.dart';
import '../../domain/repositories/customer_repository.dart';
import '../datasources/customer_local_data_source.dart';
import '../models/customer_model.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerLocalDataSource localDataSource;

  CustomerRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<CustomerEntry>>> getEntriesForDate(
    DateTime date,
  ) async {
    try {
      final result = await localDataSource.getEntriesForDate(date);
      return Right(result);
    } on DatabaseException {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, List<CustomerEntry>>> getAllCustomers() async {
    try {
      final result = await localDataSource.getAllCustomers();
      return Right(result);
    } on DatabaseException {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, void>> saveEntries(List<CustomerEntry> entries) async {
    try {
      final models = entries.map((e) => CustomerModel.fromEntity(e)).toList();
      await localDataSource.saveEntries(models);
      return const Right(null);
    } on DatabaseException {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addCustomer(CustomerEntry customer) async {
    try {
      final model = CustomerModel.fromEntity(customer);
      await localDataSource.addCustomer(model);
      return const Right(null);
    } on DatabaseException {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, void>> editCustomer(CustomerEntry customer) async {
    try {
      final model = CustomerModel.fromEntity(customer);
      await localDataSource.editCustomer(model);
      return const Right(null);
    } on DatabaseException {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteCustomer(int id) async {
    try {
      await localDataSource.deleteCustomer(id);
      return const Right(null);
    } on DatabaseException {
      return Left(DatabaseFailure());
    }
  }
}
