part of 'my_subscription_cubit.dart';

sealed class MySubscriptionState extends Equatable {
  const MySubscriptionState();

  @override
  List<Object> get props => [];
}

final class MySubscriptionLoading extends MySubscriptionState {}

final class MySubsciptionTabChanged extends MySubscriptionState {}

final class MySubscriptionsLoaded extends MySubscriptionState {
  final List<IdNameEntity> mySubscriptions;

  final List<SubscriptionEntity?> selectedSubscriptions;

  const MySubscriptionsLoaded({
    required this.mySubscriptions,
    required this.selectedSubscriptions,
  });

  @override
  List<Object> get props => [mySubscriptions, selectedSubscriptions];
}

final class MySubscriptionLoadError extends MySubscriptionState {
  final String message;

  const MySubscriptionLoadError({required this.message});

  @override
  List<Object> get props => [message];
}
