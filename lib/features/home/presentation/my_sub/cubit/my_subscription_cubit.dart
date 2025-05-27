import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extenstion/object_extension.dart';
import '../../../../../core/util/snack_toast.dart';
import '../../../../../domain/entities/id_name_entity.dart';
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
      emit(const MySubscriptionsLoaded(mySubscriptions: [], selectedSubscriptions: []));
    } catch (e, s) {
      e.showLog;
      s.showLog;

      emit(const MySubscriptionLoadError(message: 'Unable to load subscriptions'));
    }
  }

  void _loadListfirstTime() {
    _isFirstLoad = true;
    _selectedListId = _mySubscriptions.first.id;
    final headerList = _mySubscriptions.map((e) => IdNameEntity(id: e.id, name: e.title)).toList();
    final list = [null, ..._mySubscriptions.first.subscriptions];
    emit(MySubscriptionsLoaded(mySubscriptions: headerList, selectedSubscriptions: list));

    // animate after the fram initialized
    // so we will get the animatedListKey current state

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isFirstLoad = false;

      // null is for add new subscription tile
      _animateList(const [], [null, ..._mySubscriptions.first.subscriptions]);
    });
  }

  void onChangeTab(int listId) async {
    if (_selectedListId == listId) {
      return;
    }

    final previousList = _mySubscriptions.firstWhere((e) => e.id == _selectedListId).subscriptions;
    final currentList = _mySubscriptions.firstWhere((e) => e.id == listId).subscriptions;

    _selectedListId = listId;
    emit(MySubsciptionTabChanged());

    // null is for add new subscription tile
    final updatedCurrentList = await _animateList([null, ...previousList], [null, ...currentList]);

    // Update the state with the new selected list and subscriptions
    final headerList = _mySubscriptions.map((e) => IdNameEntity(id: e.id, name: e.title)).toList();

    emit(MySubscriptionsLoaded(mySubscriptions: headerList, selectedSubscriptions: updatedCurrentList));
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
      final previousList = _mySubscriptions.firstWhere((e) => e.id == _selectedListId).subscriptions;

      final updatedSubscription = _subscriptionRepository.addUpdateMySubscription(subscription);
      final index = _mySubscriptions.indexWhere((e) => e.id == updatedSubscription.id);
      _mySubscriptions[index] = updatedSubscription;

      final currentList = _mySubscriptions.firstWhere((e) => e.id == _selectedListId).subscriptions;

      final updatedCurrentList = await _animateList([null, ...previousList], [null, ...currentList]);

      final headerList = _mySubscriptions.map((e) => IdNameEntity(id: e.id, name: e.title)).toList();

      emit(MySubscriptionsLoaded(mySubscriptions: headerList, selectedSubscriptions: updatedCurrentList));
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
      final isEmptySubscription = _mySubscriptions.isEmpty;
      final updatedSubscription = _subscriptionRepository.addUpdateMySubscription(subscription);
      _mySubscriptions.add(updatedSubscription);
      if (isEmptySubscription) {
        _loadListfirstTime();
      } else {
        onChangeTab(updatedSubscription.id);
      }
    } on SubscriptionModificationFailed catch (e) {
      SnackToast.show(message: e.message);
    } catch (e, s) {
      e.showLog;
      s.showLog;
      SnackToast.show(message: 'Failed to save subscription');
    }
  }

  void deleteAllSubscription() {
    try {
      _subscriptionRepository.deleteallMySubscriptions();
      _mySubscriptions.clear();
      _selectedListId = 0;
      _animateList(
        [null, ..._mySubscriptions.first.subscriptions],
        const [],
      );
      emit(const MySubscriptionsLoaded(mySubscriptions: [], selectedSubscriptions: []));
    } on SubscriptionModificationFailed catch (e) {
      SnackToast.show(message: e.message);
    } catch (e, s) {
      e.showLog;
      s.showLog;
      SnackToast.show(message: 'Failed to delete subscription');
    }
  }

  /// Animates the transition between two subscription lists
  /// Handles removal of old items and addition of new items an returns the updated list
  Future<List<SubscriptionEntity?>> _animateList(
    List<SubscriptionEntity?> previousList,
    List<SubscriptionEntity?> currentList,
  ) async {
    final addedItems = <SubscriptionEntity?>[];
    final removableItems = <SubscriptionEntity?>[];
    final commonItems = <SubscriptionEntity?>[];

    for (final item in {...previousList, ...currentList}) {
      final inPrevious = previousList.contains(item);
      final inCurrent = currentList.contains(item);

      if (inPrevious && inCurrent) {
        commonItems.add(item);
      } else if (inPrevious && !inCurrent) {
        removableItems.add(item);
      } else if (!inPrevious && inCurrent) {
        addedItems.add(item);
      }
    }

    // Remove items first (remove from end to start to avoid index shifting)
    final sortedRemovalIndices = <int>[];
    for (final item in removableItems) {
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

    // Wait for all removal animations to complete
    await Future.delayed(Duration(milliseconds: 300 + (sortedRemovalIndices.length * 100)));

    for (int i = 0; i < addedItems.length; i++) {
      final indexToAdd = currentList.length - addedItems.length + i;
      animatedListKey.currentState!.insertItem(
        indexToAdd,
        duration: Duration(milliseconds: 300 + (i * 50)),
      );
    }
    final updatedCurrentList = [...commonItems, ...addedItems];

    return updatedCurrentList;
  }

  Widget _buildRemovalItem(int index, Animation<double> animation, SubscriptionEntity? item) {
    return Transform.translate(
      offset: Offset(0, -60.0 * index),
      child: SlideTransition(
        position: animation.drive(
          Tween<Offset>(
            begin: const Offset(-1.0, 0.0),
            end: Offset.zero,
          ),
        ),
        child: item == null
            ? const AddSubscriptionWidget()
            : SubscriptionWidget(
                subscription: item,
                key: ValueKey(item.subscriptionId),
              ),
      ),
    );
  }
}
