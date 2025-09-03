import '../../domain/entities/customer_entry.dart';

class CustomerModel extends CustomerEntry {
  const CustomerModel({
    super.id,
    required super.name,
    required super.quantity,
    required super.date,
  });

  factory CustomerModel.fromEntity(CustomerEntry entity) {
    return CustomerModel(
      id: entity.id,
      name: entity.name,
      quantity: entity.quantity,
      date: entity.date,
    );
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      id: map['id'],
      name: map['name'],
      quantity: map['quantity'],
      date: DateTime.parse(map['date']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'date': date.toIso8601String(),
    };
  }
}
