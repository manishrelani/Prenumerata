abstract class SubscriptionException implements Exception {
  final String message;
  const SubscriptionException(this.message);
}

class SubscriptionModificationFailed extends SubscriptionException {
  const SubscriptionModificationFailed(super.message);
}

class SubscriptionNotFound extends SubscriptionException {
  const SubscriptionNotFound(super.message);
}
