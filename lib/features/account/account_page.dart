import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:wow_shopping/backend/auth_repo.dart';
import 'package:wow_shopping/widgets/app_button.dart';
import 'package:wow_shopping/widgets/common.dart';

import '../login/login_screen.dart';

@immutable
class AccountPage extends StatelessWidget with WatchItMixin {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    registerStreamHandler<AuthRepo, bool>(
      select: (AuthRepo authRepo) => authRepo.streamIsLoggedIn,
      handler: (_, value, __) {
        if (!value.hasData) {
          return;
        }
        if (!value.data!) {
          Navigator.pushAndRemoveUntil(
              context, LoginScreen.route(), (route) => false);
        }
      },
    );
    return SizedBox.expand(
      child: Material(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Account'),
            verticalMargin48,
            verticalMargin48,
            AppButton(
              onPressed: () => di<AuthRepo>().logout(),
              label: 'Logout',
            ),
          ],
        ),
      ),
    );
  }
}
