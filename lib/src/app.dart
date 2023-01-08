import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'navigation/provider/router_provider.dart';
import 'features/onboarding/presentation/provider/permission_provider.dart';
import 'theme/app_theme.dart';

class App extends HookConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLifecycleState = useAppLifecycleState();
    useEffect(() {
      if (appLifecycleState == AppLifecycleState.resumed) {
        ref.read(permissionControllerProvider.notifier).checkPermission();
      }
      return null;
    }, [appLifecycleState]);

    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      // Don't show the debug banner.
      debugShowCheckedModeBanner: false,
      title: 'Bedtimer',
      theme: AppTheme.light,
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
    );
  }
}
