import 'package:equatable/equatable.dart';

class CustomerEntry extends Equatable {
  final int? id;
  final String name;
  final int quantity;
  final DateTime date;

  const CustomerEntry({
    this.id,
    required this.name,
    required this.quantity,
    required this.date,
  });

  @override
  List<Object?> get props => [id, name, quantity, date];
}
