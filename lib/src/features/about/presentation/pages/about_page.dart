import 'package:bedtimer/src/navigation/provider/router_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/presentation/widgets/custom_card.dart';
import '../../../../navigation/constants/named_route.dart';

class AboutPage extends ConsumerWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomCard(
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage('assets/icons/icon.png'),
                        radius: 24.0,
                      ),
                      const SizedBox(width: 16.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Bedtimer'),
                          Text('Version 1.0.0'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Bedtimer is like a normal timer but when time is up '
                    'instead of alarming it stops all current running video '
                    'and audio playback.',
                  ),
                  const SizedBox(height: 16.0),
                  const Text('(C) 2022 Justus Röderer'),
                ],
              ),
            ),
            const SizedBox(height: 8.0),
            CustomCard(
              crossAxisAlignment: CrossAxisAlignment.center,
              content: Wrap(
                alignment: WrapAlignment.center,
                spacing: 16.0,
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.bug_report),
                    onPressed: () async {
                      if (!await launchUrl(
                        Uri.parse(
                            'https://github.com/dateiexplorer/bedtimer/issues'),
                      )) {
                        throw 'Could not launch url';
                      }
                    },
                    label: const Text('Report Bug'),
                  ),
                  // TextButton.icon(
                  //   icon: const Icon(Icons.attach_money),
                  //   onPressed: () {},
                  //   label: const Text('Donate'),
                  // ),
                  TextButton.icon(
                    icon: const Icon(Icons.code),
                    onPressed: () async {
                      if (!await launchUrl(
                        Uri.parse('https://github.com/dateiexplorer/bedtimer'),
                      )) {
                        throw 'Could not launch url';
                      }
                    },
                    label: const Text('Source Code'),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.gavel),
                    onPressed: () => ref.read(routerProvider).goNamed(licenses),
                    label: const Text('Licences'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8.0),
            CustomCard(
              title: Text(
                'Authors',
                style: theme.textTheme.headlineMedium,
              ),
              content: Column(
                children: [
                  ListTile(
                    onTap: () async {
                      if (!await launchUrl(
                        Uri.parse('mailto:mail@dateiexplorer.de'),
                      )) {
                        throw 'Could not launch url';
                      }
                    },
                    title: const Text('Justus Röderer'),
                    subtitle: const Text('mail@dateiexplorer.de'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
