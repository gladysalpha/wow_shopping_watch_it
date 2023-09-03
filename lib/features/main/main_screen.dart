import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:wow_shopping/features/connection_monitor/connection_monitor.dart';
import 'package:wow_shopping/features/main/widgets/bottom_nav_bar.dart';

export 'package:wow_shopping/models/nav_item.dart';

@immutable
class MainScreen extends StatefulWidget with WatchItStatefulWidgetMixin {
  const MainScreen._();

  static Route<void> route() {
    return PageRouteBuilder(
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return FadeTransition(
          opacity: animation,
          child: const MainScreen._(),
        );
      },
    );
  }

  static MainScreenState of(BuildContext context) {
    return context.findAncestorStateOfType<MainScreenState>()!;
  }

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  NavItem _selected = NavItem.home;

  void gotoSection(NavItem item) {
    setState(() => _selected = item);
  }

  @override
  Widget build(BuildContext context) {
    // registerStreamHandler<AuthRepo, bool>(
    //   select: (AuthRepo authRepo) => authRepo.streamIsLoggedIn,
    //   handler: (_, value, __) {
    //     if (!value.hasData) {
    //       return;
    //     }
    //     if (value.data!) {
    //       Navigator.pushAndRemoveUntil(
    //           context, MainScreen.route(), (route) => false);
    //     } else {
    //       Navigator.pushAndRemoveUntil(
    //           context, MainScreen.route(), (route) => false);
    //     }
    //   },
    // );
    return SizedBox.expand(
      child: Material(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ConnectionMonitor(
                child: IndexedStack(
                  index: _selected.index,
                  children: [
                    for (final item in NavItem.values) //
                      item.builder(),
                  ],
                ),
              ),
            ),
            BottomNavBar(
              onNavItemPressed: gotoSection,
              selected: _selected,
            ),
          ],
        ),
      ),
    );
  }
}
