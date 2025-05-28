import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prenumerata/core/extenstion/object_extension.dart';
import 'package:provider/provider.dart';

import '../../../../../core/util/snack_toast.dart';
import '../../../../../core/widget/buttons/btn_circuler.dart';
import '../../../../../core/widget/buttons/btn_primary.dart';
import '../../../../../core/widget/buttons/btn_tab.dart';
import '../../../../../core/widget/custom_circuler_progress.dart';
import '../../../../../domain/entities/my_subscription_enitity.dart';
import '../../../widget/all_subscription_bottom_sheet/provider.dart';
import '../../../widget/all_subscription_bottom_sheet/view.dart';
import '../../../widget/subscription_widget.dart';
import '../cubit/my_subscription_cubit.dart';

class MySubscriptionView extends StatelessWidget {
  const MySubscriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MySubscriptionCubit>();
    return BlocConsumer<MySubscriptionCubit, MySubscriptionState>(
      listenWhen: (previous, current) => current is MySubscriptionLoadError,
      listener: (context, state) {
        if (state is MySubscriptionLoadError) {
          SnackToast.show(message: state.message);
        }
      },

      buildWhen: (previous, current) =>
          current is MySubscriptionLoading || current is MySubscriptionsLoaded || current is MySubscriptionLoadError,

      builder: (context, state) {
        state.runtimeType.showLog;

        if (state is MySubscriptionLoading) {
          return const Center(child: CustomCirculerProgress());
        }

        if (state is MySubscriptionsLoaded) {
          if (cubit.mySubscriptions.isEmpty) {
            return _CreateNewListPage(() => showAddBottomsheet(context: context, cubit: cubit));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24.0),
              BlocBuilder<MySubscriptionCubit, MySubscriptionState>(
                buildWhen: (previous, current) => current is MySubsciptionTabChanged,
                builder: (context, _) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 12.0,
                      children: [
                        for (int i = 0; i < cubit.mySubscriptions.length; i++)
                          BtnTab(
                                isSelected: cubit.mySubscriptions[i].id == cubit.selectedListId,
                                title: cubit.mySubscriptions[i].title,
                                onTap: () {
                                  cubit.onChangeTab(cubit.mySubscriptions[i].id);
                                },
                              )
                              .animate(key: ValueKey(i))
                              .slideX(
                                duration: Duration(milliseconds: 700 + (i * 200)),
                                begin: cubit.isFirstLoad ? (3 + i).toDouble() : 0,
                                end: 0.0,
                                curve: Curves.ease,
                              )
                              .fadeIn(duration: Duration(milliseconds: cubit.isFirstLoad ? 0 : 500)),
                        BtnCirculer(
                              key: const ValueKey('add'),
                              radius: 24,
                              backgroundColor: Colors.white10,
                              // onTap: cubit.deleteAllSubscription,
                              child: const Icon(Icons.add),
                              onTap: () => showAddBottomsheet(context: context, cubit: cubit),
                            )
                            .animate(key: const ValueKey('add'))
                            .slideX(
                              duration: Duration(milliseconds: 700 + (cubit.mySubscriptions.length * 200)),
                              begin: cubit.isFirstLoad ? (3 + cubit.mySubscriptions.length).toDouble() : 0,
                              end: 0.0,
                              curve: Curves.ease,
                            ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24.0),
              Expanded(
                child: ClipRRect(
                  clipBehavior: Clip.hardEdge,
                  child: AnimatedList(
                    key: cubit.animatedListKey,
                    initialItemCount: 0,

                    padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 100.0),
                    itemBuilder: (context, index, animation) {
                      final subscription = cubit.currentSelectedSubscriptions[index];

                      if (subscription == null) {
                        return Align(
                          heightFactor: 0.7,
                          child: SlideTransition(
                            position: animation.drive(Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero)),
                            child: AddSubscriptionWidget(
                              key: const ValueKey(0),
                              onTap: () => showAddBottomsheet(
                                context: context,
                                cubit: cubit,
                                selectedList: cubit.mySubscriptions.firstWhereOrNull(
                                  (e) => e.id == cubit.selectedListId,
                                ),
                              ),
                            ),
                          ),
                        );
                      }

                      return Align(
                        heightFactor: 0.7,
                        child: SlideTransition(
                          position: animation.drive(Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero)),

                          child: SubscriptionWidget(
                            key: ValueKey(subscription.subscriptionId),

                            subscription: subscription,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        }
        return _ErrorPage(cubit.onRefresh);
      },
    );
  }

  void showAddBottomsheet({
    required BuildContext context,
    required MySubscriptionCubit cubit,
    MySubscriptionListEnitity? selectedList,
  }) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      useSafeArea: true,
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.85),
      transitionAnimationController: AnimationController(
        vsync: Navigator.of(context),
        duration: const Duration(milliseconds: 600),
      ),

      builder: (context) {
        return ChangeNotifierProvider(
          create: (_) => AllSubcriptionListBottomSheetProvider(
            allSubscriptions: cubit.allSubscriptions,
            onSave: cubit.onSaveUpdateSubscription,
            selectedList: selectedList,
          ),
          child: const AllSubscriptionBottomSheetView(),
        );
      },
    );
  }
}

class _CreateNewListPage extends StatelessWidget {
  final VoidCallback? onCreate;
  const _CreateNewListPage(this.onCreate);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.add_circle_outline, size: 48.0, color: Colors.white),
          const SizedBox(height: 16.0),
          Text(
            'Create a new subscription list',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 24.0),
          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.6,
            child: BtnPrimary(title: "Create", onPressed: onCreate),
          ),
        ],
      ),
    );
  }
}

class _ErrorPage extends StatelessWidget {
  final void Function()? onRefresh;
  const _ErrorPage(this.onRefresh);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48.0, color: Colors.red),
          const SizedBox(height: 16.0),
          Text(
            'Unable to load subscriptions',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.red),
          ),
          const SizedBox(height: 24.0),
          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.6,
            child: BtnPrimary(title: "Refresh", onPressed: onRefresh),
          ),
        ],
      ),
    );
  }
}
