import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/widget/buttons/btn_circuler.dart';
import '../../../../core/widget/switcher.dart' show SlideSwitcher, SwitcherItem;
import '../../../../domain/repository/subscription_repository.dart';
import '../general/general_screen.dart';
import '../my_sub/cubit/my_subscription_cubit.dart';
import '../my_sub/screen/my_subscription_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        leading: BtnCirculer(
          radius: 24,
          backgroundColor: Colors.white10,
          child: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onTap: () {},
        ),

        backgroundColor: Colors.black,
        title: SlideSwitcher(
          items: const [
            SwitcherItem(
              title: 'General',
              selectedIcon: Icons.dashboard_customize,
              unselectedIcon: Icons.dashboard_outlined,
            ),
            SwitcherItem(
              title: 'My Subs',
              selectedIcon: CupertinoIcons.cube_box_fill,
              unselectedIcon: Icons.dashboard_outlined,
            ),
          ],
          onChanged: onTabchange,
        ),
        actions: [
          BtnCirculer(
            radius: 24,
            backgroundColor: Colors.white10,
            child: const Icon(
              Icons.notifications_outlined,
              color: Colors.white,
            ),
            onTap: () {},
          ),
          const SizedBox(
            width: 6.0,
          ),
        ],
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [
          const GeneralScreen(),
          BlocProvider(
            create: (context) => MySubscriptionCubit(subscriptionRepository: sl<SubscriptionRepository>()),
            child: const MySubscriptionView(),
          ),
        ],
      ),
    );
  }

  void onTabchange(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}
