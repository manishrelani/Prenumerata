import 'package:objectbox/objectbox.dart';

import '../../domain/entities/my_subscription_enitity.dart';
import '../../domain/entities/subscription_enitity.dart';
import '../../domain/exceptions/subscription_exceptions.dart';
import '../../domain/repository/subscription_repository.dart';
import '../../generated/assets.gen.dart';
import '../model/objectbox/my_subscription_db_model.dart';

class SubscriptionRepositoryLocaleImpl implements SubscriptionRepository {
  final Store _store;
  late final Box<MySubscriptionDbModel> _mySubscriptionBox;

  SubscriptionRepositoryLocaleImpl(this._store) {
    _mySubscriptionBox = _store.box<MySubscriptionDbModel>();
  }

  @override
  List<SubscriptionEntity> getAllSubscriptions() {
    return List.from(_allSubscriptions, growable: false);
  }

  @override
  List<MySubscriptionListEnitity> getMySubscriptions() {
    final list = _mySubscriptionBox.getAll();
    if (list.isEmpty) {
      throw const SubscriptionNotFound('No subscriptions found');
    }
    return list
        .map(
          (e) => MySubscriptionListEnitity(
            id: e.id,
            title: e.title,
            subscriptions: _allSubscriptions.where((i) => e.subscriptions.contains(i.subscriptionId)).toList(),
          ),
        )
        .toList();
  }

  @override
  MySubscriptionListEnitity addUpdateMySubscription(MySubscriptionListEnitity mySubscription) {
    try {
      final mySubscriptionDbModel = MySubscriptionDbModel(
        id: mySubscription.id,
        title: mySubscription.title,
        subscriptions: mySubscription.subscriptions.map((e) => e.subscriptionId).toList(),
      );

      final id = _mySubscriptionBox.put(mySubscriptionDbModel, mode: PutMode.put);

      return MySubscriptionListEnitity(
        id: id,
        title: mySubscription.title,
        subscriptions: mySubscription.subscriptions,
      );
    } catch (e) {
      throw SubscriptionModificationFailed(
        'Failed to ${mySubscription.id == 0 ? 'add' : 'update'} subscription: ${mySubscription.title}',
      );
    }
  }

  @override
  bool deleteallMySubscriptions() {
    try {
      _mySubscriptionBox.removeAll();
      return true;
    } catch (e) {
      throw const SubscriptionModificationFailed('Failed to delete all subscriptions');
    }
  }
}

const List<SubscriptionEntity> _allSubscriptions = [
  SubscriptionEntity(
    subscriptionId: 1,
    name: 'Netflix',
    logo: Assets.svgsLogosNetflix,
    backgroundColor: 'FFE50914',
    contentColor: 'FFFFFFFF',
    price: 15.99,
  ),
  SubscriptionEntity(
    subscriptionId: 2,
    name: 'Spotify',
    logo: Assets.svgsLogosSpotify,
    backgroundColor: 'FF1DB954',
    contentColor: 'FFFFFFFF',
    price: 9.99,
  ),
  SubscriptionEntity(
    subscriptionId: 3,
    name: 'Notion',
    logo: Assets.svgsLogosNotion,

    backgroundColor: 'FF121111',
    contentColor: 'FFFFFFFF',
    price: 4.00,
  ),
  SubscriptionEntity(
    subscriptionId: 4,
    name: 'Discord Nitro',
    logo: Assets.svgsLogosDiscord,
    backgroundColor: 'FF5d6bf3',
    contentColor: 'FFFFFFFF',
    price: 9.99,
  ),
  SubscriptionEntity(
    subscriptionId: 5,
    name: 'Adobe Creative Cloud',
    logo: Assets.svgsLogosAdobe,
    backgroundColor: 'FF470138',
    contentColor: 'FFFFFFFF',
    price: 52.99,
  ),

  SubscriptionEntity(
    subscriptionId: 6,
    name: 'Amazon Prime',
    logo: Assets.svgsLogosPrime,
    backgroundColor: 'FF1b98fd',
    contentColor: 'FFFFFFFF',

    price: 14.99,
  ),
  SubscriptionEntity(
    subscriptionId: 7,
    name: 'YouTube Premium',
    logo: Assets.svgsLogosYoutube,
    backgroundColor: 'FFFF0000',
    contentColor: 'FFFFFFFF',
    price: 7.99,
  ),
  SubscriptionEntity(
    subscriptionId: 8,
    name: 'Microsoft Teams',
    logo: Assets.svgsLogosTeams,
    backgroundColor: 'FF4850b6',
    contentColor: 'FFFFFFFF',
    price: 10.99,
  ),
  SubscriptionEntity(
    subscriptionId: 9,
    name: 'Dribble',
    logo: Assets.svgsLogosDribble,
    backgroundColor: 'FFc52b66',
    contentColor: 'FFFFFFFF',
    price: 15.99,
  ),
  SubscriptionEntity(
    subscriptionId: 10,
    name: 'Disney+',
    logo: Assets.svgsLogosDisney,
    backgroundColor: 'FF148c9d',
    contentColor: 'FFFFFFFF',
    price: 7.99,
  ),
  SubscriptionEntity(
    subscriptionId: 11,
    name: 'Gmail',
    logo: Assets.svgsLogosGmail,
    backgroundColor: 'FFf3ba2a',
    contentColor: 'FF000000',
    price: 1.99,
  ),

  SubscriptionEntity(
    subscriptionId: 12,
    name: 'Figma',
    logo: Assets.svgsLogosFigma,
    backgroundColor: 'FFF24E1E',
    contentColor: 'FFFFFFFF',
    price: 12.00,
  ),
  SubscriptionEntity(
    subscriptionId: 13,
    name: 'GitHub',
    logo: Assets.svgsLogosGithub,
    backgroundColor: 'FF24292E',
    contentColor: 'FFFFFFFF',
    price: 3.45,
  ),
  SubscriptionEntity(
    subscriptionId: 14,
    name: 'Slack',
    logo: Assets.svgsLogosSlack,
    backgroundColor: 'FF491349',
    contentColor: 'FFFFFFFF',
    price: 6.67,
  ),
  SubscriptionEntity(
    subscriptionId: 15,
    name: 'Open AI',
    logo: Assets.svgsLogosOpenai,
    backgroundColor: 'FF1aa783',
    contentColor: 'FFFFFFFF',
    price: 9.99,
  ),
];
