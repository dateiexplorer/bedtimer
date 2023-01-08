import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../navigation/constants/named_route.dart';
import '../../../../navigation/provider/router_provider.dart';
import '../provider/timer_provider.dart';
import '../widgets/wheel.dart';

class TimerPage extends ConsumerWidget {
  TimerPage({super.key});

  final hoursTimerWheel = Wheel(
    text: 'Hours',
    values: List.generate(24, (index) => index),
    onSelectedValueChanged: (ref, value) {
      ref.read(timerProvider.notifier).setHoursUi(value);
    },
  );

  final minutesTimerWheel = Wheel(
    text: 'Minutes',
    values: List.generate(60, (index) => index),
    onSelectedValueChanged: (ref, value) {
      ref.read(timerProvider.notifier).setMinutesUi(value);
    },
  );

  final secondsTimerWheel = Wheel(
    text: 'Seconds',
    values: List.generate(60, (index) => index),
    onSelectedValueChanged: (ref, value) {
      ref.read(timerProvider.notifier).setSecondsUi(value);
    },
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      timerProvider,
      (previous, next) {
        next.whenData(
          (value) {
            if (value.forced) {
              hoursTimerWheel.jumpToValue(value.time.hours);
              minutesTimerWheel.jumpToValue(value.time.minutes);
              secondsTimerWheel.jumpToValue(value.time.seconds);
            }

            if (value.timeIsUp) {
              ref.read(routerProvider).goNamed(timeIsUp);
            }
          },
        );
      },
    );

    final state = ref.watch(timerProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bedtimer'),
        actions: [
          PopupMenuButton(
            position: PopupMenuPosition.under,
            icon: Icon(Icons.more_vert,
                color: Theme.of(context).appBarTheme.actionsIconTheme!.color),
            onSelected: (value) => value(),
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: () => ref.read(routerProvider).goNamed(about),
                  child: const Text('About'),
                ),
              ];
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomScrollView(
            physics: const NeverScrollableScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AbsorbPointer(
                      absorbing: state?.isRunning ?? false,
                      child: Wrap(
                        spacing: 8.0,
                        children: [
                          hoursTimerWheel,
                          minutesTimerWheel,
                          secondsTimerWheel,
                        ],
                      ),
                    ),
                    Wrap(
                      spacing: 16.0,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SizedBox(
                          width: 64,
                          height: 64,
                          child: IconButton(
                            onPressed: () {
                              ref.read(timerProvider.notifier).reset();
                            },
                            icon: const Icon(Icons.restart_alt),
                            iconSize: 32,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                        AbsorbPointer(
                          absorbing: !(state?.isValid ?? false),
                          child: Opacity(
                            opacity: (state?.isValid ?? false) ? 1.0 : 0.5,
                            child: SizedBox(
                              width: 96,
                              height: 96,
                              child: ElevatedButton(
                                onPressed: () {
                                  final timer =
                                      ref.read(timerProvider.notifier);
                                  if (state?.isRunning ?? false) {
                                    timer.pause();
                                  } else {
                                    timer.start();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                ),
                                child: (state?.isRunning ?? false)
                                    ? const Icon(Icons.pause)
                                    : const Icon(Icons.play_arrow),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 64,
                          height: 64,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
