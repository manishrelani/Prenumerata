import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extenstion/object_extension.dart';
import '../../../../../core/util/snack_toast.dart';
import '../../../../../domain/entities/my_subscription_enitity.dart';
import '../../../../../domain/entities/subscription_enitity.dart';
import '../../../../../domain/exceptions/subscription_exceptions.dart';
import '../../../../../domain/repository/subscription_repository.dart';
import '../../../widget/subscription_widget.dart';

part 'my_subscription_state.dart';

/// Cubit that manages the state of user's subscription lists
/// Handles loading, updating, deleting, and animating subscription lists
class MySubscriptionCubit extends Cubit<MySubscriptionState> {
  MySubscriptionCubit({required SubscriptionRepository subscriptionRepository})
    : _subscriptionRepository = subscriptionRepository,
      super(MySubscriptionLoading()) {
    _getMySubscription();
    _getAllSubscriptionList();
  }

  final SubscriptionRepository _subscriptionRepository;

  final animatedListKey = GlobalKey<AnimatedListState>();

  bool _isFirstLoad = true;
  bool get isFirstLoad => _isFirstLoad;

  int _selectedListId = 0;
  int get selectedListId => _selectedListId;

  List<MySubscriptionListEnitity> _mySubscriptions = [];
  List<MySubscriptionListEnitity> get mySubscriptions => _mySubscriptions;

  List<SubscriptionEntity> _allSubscriptionList = [];
  List<SubscriptionEntity> get allSubscriptions => _allSubscriptionList;

  List<SubscriptionEntity?> _currentSelectedSubscriptions = [];
  List<SubscriptionEntity?> get currentSelectedSubscriptions => _currentSelectedSubscriptions;

  void onRefresh() {
    emit(MySubscriptionLoading());
    _getMySubscription();
  }

  void _getAllSubscriptionList() {
    _allSubscriptionList = _subscriptionRepository.getAllSubscriptions();
  }

  Future<void> _getMySubscription() async {
    try {
      _mySubscriptions = _subscriptionRepository.getMySubscriptions();
      _loadListfirstTime();
    } on SubscriptionNotFound catch (_) {
      emit(MySubscriptionsLoaded());
    } catch (e, s) {
      e.showLog;
      s.showLog;

      emit(const MySubscriptionLoadError(message: 'Unable to load subscriptions'));
    }
  }

  void _loadListfirstTime() {
    _isFirstLoad = true;
    _selectedListId = _mySubscriptions.first.id;

    // null is for add new subscription tile
    _currentSelectedSubscriptions = [null, ..._mySubscriptions.first.subscriptions];
    emit(MySubscriptionsLoaded());

    // animate after the fram initialized
    // so we will get the animatedListKey current state

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isFirstLoad = false;
      _addItemInAnimatedList(indexToAdd: 0, totalItemsToAdd: _currentSelectedSubscriptions.length);
    });
  }

  void onChangeTab(int listId) async {
    if (_selectedListId == listId) {
      return;
    }

    _selectedListId = listId;
    emit(MySubsciptionTabChanged(listId: listId));

    final newList = [null, ..._mySubscriptions.firstWhere((e) => e.id == listId).subscriptions];
    _updateTheSubscriptionList(_currentSelectedSubscriptions, newList);
  }

  void onSaveUpdateSubscription(MySubscriptionListEnitity subscription) {
    if (subscription.id != 0) {
      _updateSelectedList(subscription);
    } else {
      _onSaveMySubscription(subscription);
    }
  }

  void _updateSelectedList(MySubscriptionListEnitity subscription) async {
    try {
      if (_mySubscriptions.any((e) => e.id != subscription.id && e.title == subscription.title)) {
        SnackToast.show(message: 'Subscription with this name already exists');
        return;
      }

      final updatedSubscription = _subscriptionRepository.addUpdateMySubscription(subscription);
      final index = _mySubscriptions.indexWhere((e) => e.id == updatedSubscription.id);
      _mySubscriptions[index] = updatedSubscription;

      final newList = [null, ..._mySubscriptions[index].subscriptions];

      _updateTheSubscriptionList(_currentSelectedSubscriptions, newList);
    } on SubscriptionModificationFailed catch (e) {
      SnackToast.show(message: e.message);
    } catch (e, s) {
      e.showLog;
      s.showLog;
      SnackToast.show(message: 'Failed to update subscription');
    }
  }

  void _onSaveMySubscription(MySubscriptionListEnitity subscription) {
    try {
      if (_mySubscriptions.any((e) => e.title == subscription.title)) {
        SnackToast.show(message: 'Subscription with this name already exists');
        return;
      }

      final updatedSubscriptionList = _subscriptionRepository.addUpdateMySubscription(subscription);
      _mySubscriptions.add(updatedSubscriptionList);

      // If this is the first subscription, we nee to load it as first time
      final isEmptySubscription = _mySubscriptions.isEmpty;

      if (isEmptySubscription) {
        _loadListfirstTime();
      } else {
        onChangeTab(updatedSubscriptionList.id);
      }
    } on SubscriptionModificationFailed catch (e) {
      SnackToast.show(message: e.message);
    } catch (e, s) {
      e.showLog;
      s.showLog;
      SnackToast.show(message: 'Failed to save subscription');
    }
  }

  // void deleteAllSubscription() {
  //   try {
  //     _subscriptionRepository.deleteallMySubscriptions();
  //     _mySubscriptions.clear();
  //     _selectedListId = 0;
  //     _animateList(
  //       [null, ..._mySubscriptions.first.subscriptions],
  //       const [],
  //     );
  //     emit(const MySubscriptionsLoaded(mySubscriptions: [], selectedSubscriptions: []));
  //   } on SubscriptionModificationFailed catch (e) {
  //     SnackToast.show(message: e.message);
  //   } catch (e, s) {
  //     e.showLog;
  //     s.showLog;
  //     SnackToast.show(message: 'Failed to delete subscription');
  //   }
  // }

  Future<void> _updateTheSubscriptionList(
    List<SubscriptionEntity?> previousList,
    List<SubscriptionEntity?> newList,
  ) async {
    final commonItems = await _removeAndGetCommonItemsFromAnimatedList(previousList, newList);

    // Find items that are in currentList but not in previousList
    final itemsToAdd = newList.where((item) => !commonItems.contains(item)).toList();

    final updatedNewList = [...commonItems, ...itemsToAdd];

    if (itemsToAdd.isNotEmpty) {
      _addItemInAnimatedList(indexToAdd: commonItems.length, totalItemsToAdd: itemsToAdd.length);
    }

    _currentSelectedSubscriptions = updatedNewList;
  }

  Future<List<SubscriptionEntity?>> _removeAndGetCommonItemsFromAnimatedList(
    List<SubscriptionEntity?> previousList,
    List<SubscriptionEntity?> currentList,
  ) async {
    // Find items that are in previousList but not in currentList
    // and common items that are in both lists, which will remain in the list

    List<SubscriptionEntity?> itemsToRemove = [];
    List<SubscriptionEntity?> commonItems = [];

    for (final item in {...previousList, ...currentList}) {
      final inPrevious = previousList.contains(item);
      final inCurrent = currentList.contains(item);

      if (inPrevious && inCurrent) {
        commonItems.add(item);
      } else if (inPrevious && !inCurrent) {
        itemsToRemove.add(item);
      }
    }

    // Remove items first (remove from end to start to avoid index shifting)
    final sortedRemovalIndices = <int>[];
    for (final item in itemsToRemove) {
      final index = previousList.indexOf(item);
      if (index != -1) {
        sortedRemovalIndices.add(index);
      }
    }
    // Sort indices in descending order to remove from the end first
    sortedRemovalIndices.sort((a, b) => b.compareTo(a));

    for (int i = 0; i < sortedRemovalIndices.length; i++) {
      final index = sortedRemovalIndices[i];
      final itemToRemove = previousList[index];

      animatedListKey.currentState?.removeItem(
        index,
        (context, animation) => _buildRemovalItem(index, animation, itemToRemove),
        duration: Duration(milliseconds: 300 + (i * 100)),
      );
    }
    _currentSelectedSubscriptions = commonItems;

    // Wait for all removal animations to complete
    await Future.delayed(Duration(milliseconds: 300 + (sortedRemovalIndices.length * 100)));

    return commonItems;
  }

  void _addItemInAnimatedList({required int indexToAdd, required int totalItemsToAdd}) {
    for (int i = 0; i < totalItemsToAdd; i++) {
      animatedListKey.currentState!.insertItem(indexToAdd + i, duration: Duration(milliseconds: 300 + (i * 50)));
    }
  }

  Widget _buildRemovalItem(int index, Animation<double> animation, SubscriptionEntity? item) {
    return Align(
      heightFactor: 0.7,
      child: SlideTransition(
        key: ValueKey(item?.subscriptionId ?? 0),
        position: animation.drive(Tween<Offset>(begin: const Offset(-1.0, 0.0), end: Offset.zero)),
        child: item == null ? const AddSubscriptionWidget() : SubscriptionWidget(subscription: item),
      ),
    );
  }
}
