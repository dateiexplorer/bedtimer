import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../features/about/presentation/pages/about_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/onboarding/presentation/provider/permission_provider.dart';
import '../../features/timer/presentation/pages/time_is_up_page.dart';
import '../../features/timer/presentation/pages/timer_page.dart';
import '../constants/named_route.dart';

final routerProvider = Provider<GoRouter>(
  (ref) {
    final router = RouterNotifier(ref);

    return GoRouter(
      initialLocation: '/',
      refreshListenable: router,
      redirect: router.redirect,
      routes: router.routes,
    );
  },
);

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen(
      permissionControllerProvider,
      (previous, next) {
        notifyListeners();
      },
    );
  }

  String? redirect(BuildContext context, GoRouterState state) {
    final permissionState = _ref.read(permissionControllerProvider);
    final redirect = permissionState.whenData(
      (value) {
        if (value != PermissionStatus.granted) {
          return '/$onboarding';
        }

        if (state.location == '/$onboarding') {
          return '/';
        }

        return null;
      },
    ).value;

    return redirect;
  }

  List<GoRoute> get routes => [
        GoRoute(
          path: '/',
          name: timer,
          builder: (context, state) => TimerPage(),
          routes: [
            GoRoute(
              path: timeIsUp,
              name: timeIsUp,
              builder: (context, state) => const TimeIsUpPage(),
            ),
            GoRoute(
              path: about,
              name: about,
              builder: (context, state) => const AboutPage(),
              routes: [
                GoRoute(
                  path: licenses,
                  name: licenses,
                  builder: (context, state) => const LicensePage(),
                ),
              ],
            )
          ],
        ),
        GoRoute(
          path: '/$onboarding',
          name: onboarding,
          builder: (context, state) => const OnboardingPage(),
        ),
      ];
}
