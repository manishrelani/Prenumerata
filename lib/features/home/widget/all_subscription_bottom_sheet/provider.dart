import 'package:flutter/material.dart';

import '../../../../domain/entities/my_subscription_enitity.dart';
import '../../../../domain/entities/subscription_enitity.dart';

class AllSubcriptionListBottomSheetProvider with ChangeNotifier {
  final ValueChanged<MySubscriptionListEnitity> onSave;
  final List<SubscriptionEntity> allSubscriptions;

  AllSubcriptionListBottomSheetProvider({
    required this.onSave,
    required this.allSubscriptions,
    MySubscriptionListEnitity? selectedList,
  }) : _selectedList = selectedList {
    tecNameController.addListener(() {
      notifyListeners();
    });
  }

  final MySubscriptionListEnitity? _selectedList;

  late final Set<int> _selectedSubscriptions =
      _selectedList?.subscriptions.map((e) => e.subscriptionId).toSet() ?? <int>{};
  Set<int> get selectedSubscriptions => _selectedSubscriptions;

  late final tecNameController = TextEditingController(text: _selectedList?.title);

  void onSelectSubscription(int subscriptionId) {
    if (_selectedSubscriptions.contains(subscriptionId)) {
      _selectedSubscriptions.remove(subscriptionId);
    } else {
      _selectedSubscriptions.add(subscriptionId);
    }
    notifyListeners();
  }

  void onSaveSubscription() {
    final list = allSubscriptions.where((e) => _selectedSubscriptions.contains(e.subscriptionId)).toList();
    onSave(
      MySubscriptionListEnitity(title: tecNameController.text.trim(), subscriptions: list, id: _selectedList?.id ?? 0),
    );
  }

  @override
  void dispose() {
    tecNameController.dispose();
    super.dispose();
  }
}
