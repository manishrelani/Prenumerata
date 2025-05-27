import '../entities/my_subscription_enitity.dart';
import '../entities/subscription_enitity.dart';

abstract class SubscriptionRepository {
  List<SubscriptionEntity> getAllSubscriptions();

  List<MySubscriptionListEnitity> getMySubscriptions();

  MySubscriptionListEnitity addUpdateMySubscription(MySubscriptionListEnitity mySubscription);

  bool deleteallMySubscriptions();
}
