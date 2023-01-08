import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../common/presentation/widgets/custom_card.dart';
import '../../../../common/presentation/widgets/custom_list_item.dart';
import '../provider/permission_provider.dart';

class OnboardingPage extends ConsumerWidget {
  static const _bottomSheetHeight = 64.0;

  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: Container(
        margin: const EdgeInsets.only(
          bottom: _bottomSheetHeight,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const CustomCard(
                content: Text(
                  'Bedtimer is like a normal timer but when time is up instead '
                  'of alarming it stops all current running video and audio '
                  'playback.',
                ),
              ),
              const SizedBox(height: 8.0),
              CustomCard(
                title: Text(
                  'What this app provides',
                  style: theme.textTheme.headlineMedium,
                ),
                content: Column(
                  children: const [
                    CustomListItem(
                      child: Text(
                        'Stop running audio and video playback',
                      ),
                    ),
                    CustomListItem(
                      child: Text(
                        'Digital weelbeing: Sleep better',
                      ),
                    ),
                    CustomListItem(
                      child: Text(
                        'No more problems with long videos or podcasts while '
                        'sleeping',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
              CustomCard(
                title: Text(
                  'About permissions',
                  style: theme.textTheme.headlineMedium,
                ),
                content: const Text(
                  'The app needs permission to display over other apps so '
                  'that can show up automatically when time is up. '
                  'Please allow in the following screen this permission for '
                  'the app. '
                  'You can revoke this permission at any time, but then the '
                  'app might not work as expected and this screen will show '
                  'up again.',
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        height: _bottomSheetHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_forward,
                color: theme.iconTheme.color,
              ),
              onPressed: () {
                ref.read(permissionControllerProvider.notifier).request();
              },
            ),
          ],
        ),
      ),
    );
  }
}
