import 'package:equatable/equatable.dart';

class SubscriptionEntity extends Equatable {
  final int subscriptionId;
  final String name;
  final String logo;
  final String backgroundColor;
  final String contentColor;
  final double price;

  const SubscriptionEntity({
    required this.subscriptionId,
    required this.name,
    required this.logo,
    required this.backgroundColor,
    required this.contentColor,
    required this.price,
  });

  @override
  String toString() {
    return 'SubscriptionEntity{name: $name, logo: $logo, backgroundColor: $backgroundColor, contentColor: $contentColor, price: $price}';
  }

  @override
  List<Object?> get props => [subscriptionId];
}
