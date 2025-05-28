part of 'my_subscription_cubit.dart';

sealed class MySubscriptionState extends Equatable {
  const MySubscriptionState();

  @override
  List<Object> get props => [];
}

final class MySubscriptionLoading extends MySubscriptionState {}

final class MySubsciptionTabChanged extends MySubscriptionState {
  final int listId;
  const MySubsciptionTabChanged({required this.listId});

  @override
  List<Object> get props => [listId];
}

final class MySubscriptionsLoaded extends MySubscriptionState {}

final class MySubscriptionLoadError extends MySubscriptionState {
  final String message;

  const MySubscriptionLoadError({required this.message});

  @override
  List<Object> get props => [message];
}
