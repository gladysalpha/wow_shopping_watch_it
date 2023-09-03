import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:wow_shopping/backend/auth_repo.dart';
import 'package:wow_shopping/features/main/main_screen.dart';
import 'package:wow_shopping/widgets/app_button.dart';
import 'package:wow_shopping/widgets/common.dart';

class LoginScreen extends StatelessWidget with WatchItMixin {
  const LoginScreen._();

  static Route<void> route() {
    return PageRouteBuilder(
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return FadeTransition(
          opacity: animation,
          child: const LoginScreen._(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    registerStreamHandler<AuthRepo, bool>(
      select: (AuthRepo authRepo) => authRepo.streamIsLoggedIn,
      handler: (_, value, __) {
        if (!value.hasData) {
          return;
        }
        if (value.data!) {
          Navigator.pushAndRemoveUntil(
              context, MainScreen.route(), (route) => false);
        } else {
          Navigator.pushAndRemoveUntil(
              context, LoginScreen.route(), (route) => false);
        }
      },
    );
    bool isExecuting = watchValue(
      (AuthRepo authRepo) => authRepo.loginCommand.isExecuting,
    );

    return Material(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButton(
              onPressed: isExecuting
                  ? null
                  : () {
                      di<AuthRepo>()
                          .loginCommand
                          .execute(('username', 'password'));
                    },
              label: 'Login',
            ),
            verticalMargin16,
            if (isExecuting) //
              const CircularProgressIndicator(),
            // if (state.hasError) //
            //   Text(state.lastError),
          ],
        ),
      ),
    );
  }
}
