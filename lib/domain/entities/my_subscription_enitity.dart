import 'package:equatable/equatable.dart';

import 'subscription_enitity.dart';

class MySubscriptionListEnitity extends Equatable {
  final int id;
  final String title;
  final List<SubscriptionEntity> subscriptions;

  const MySubscriptionListEnitity({
    this.id = 0,
    required this.title,
    required this.subscriptions,
  });

  @override
  String toString() {
    return 'MySubscriptionEnitity{id: $id, title: $title, subscriptions: $subscriptions}';
  }

  @override
  List<Object?> get props => [
    id,
    title,
    subscriptions,
  ];
}
