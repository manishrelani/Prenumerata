import 'package:equatable/equatable.dart';

class IdNameEntity extends Equatable {
  final int id;
  final String name;

  const IdNameEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
