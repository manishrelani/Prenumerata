import 'package:get_it/get_it.dart';

import '../../data/repositories/subscription_repository_impl.dart';
import '../../data/service/object_box.dart';
import '../../domain/repository/subscription_repository.dart';
import '../../objectbox.g.dart';

final GetIt sl = GetIt.instance;

Future<void> initServiceLocator() async {
  final box = await ObjectBox.create();
  sl.registerSingleton<Store>(box.store);

  // Repositories
  sl.registerFactory<SubscriptionRepository>(
    () => SubscriptionRepositoryLocaleImpl(sl<Store>()),
  );
}

Future<void> resetServiceLocator() async {
  await sl.reset();
}
