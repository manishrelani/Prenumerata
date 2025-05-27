import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../../core/widget/buttons/btn_primary.dart';
import '../../../../core/widget/circuler_widget.dart';
import '../../../../core/widget/input_field.dart';
import '../../../../core/widget/platform_spacer.dart';
import '../../../../domain/entities/subscription_enitity.dart';
import 'provider.dart';

class AllSubscriptionBottomSheetView extends StatelessWidget {
  const AllSubscriptionBottomSheetView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final provider = Provider.of<AllSubcriptionListBottomSheetProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16.0),
          Text(
            'Add Category',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 18.0,
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),

          Text(
            'Enter a name',
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(
            height: 8.0,
          ),

          InputField(
            hintText: 'e.g Office',
            controller: provider.tecNameController,
          ),
          const SizedBox(
            height: 24.0,
          ),
          Text(
            'Select Subscriptions',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 18.0,
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          Selector<AllSubcriptionListBottomSheetProvider, int>(
            selector: (_, provider) => provider.selectedSubscriptions.length,
            builder: (context, _, _) {
              return Expanded(
                child: ListView.separated(
                  itemCount: provider.allSubscriptions.length,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  itemBuilder: (context, index) {
                    final subscription = provider.allSubscriptions[index];
                    return SubscriptionSelectionTile(
                      subscription: subscription,
                      isSelected: provider.selectedSubscriptions.contains(
                        subscription.subscriptionId,
                      ),
                      onTap: () {
                        provider.onSelectSubscription(
                          subscription.subscriptionId,
                        );
                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 16.0,
                    );
                  },
                ),
              );
            },
          ),

          const SizedBox(
            height: 16.0,
          ),
          Selector<AllSubcriptionListBottomSheetProvider, String>(
            selector: (_, provider) => provider.tecNameController.text.trim(),
            builder: (context, name, _) {
              return BtnPrimary(
                title: 'Save',
                onPressed: name.isEmpty
                    ? null
                    : () {
                        Navigator.of(context).pop();
                        provider.onSaveSubscription();
                      },
              );
            },
          ),

          const PlatformSpacer(),
        ],
      ),
    );
  }
}

class SubscriptionSelectionTile extends StatelessWidget {
  final SubscriptionEntity subscription;
  final bool isSelected;
  final VoidCallback? onTap;
  const SubscriptionSelectionTile({
    required this.subscription,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        CirculerWidget(
          radius: 24,
          backgroundColor: Colors.white,
          child: SvgPicture.asset(
            subscription.logo,
            width: 36,
            height: 36,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(
          width: 16.0,
        ),
        Expanded(
          child: Text(
            subscription.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(
          width: 12.0,
        ),
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: isSelected
              ? CirculerWidget(
                  backgroundColor: theme.colorScheme.primary,
                  radius: 12,
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 18,
                  ),
                )
              : const CirculerWidget(
                  backgroundColor: Colors.black,
                  radius: 12,
                  child: SizedBox(),
                ),
        ),
      ],
    );
  }
}
