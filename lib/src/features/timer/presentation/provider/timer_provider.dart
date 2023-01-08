import 'package:bedtimer/src/features/timer/application/audio_service.dart';
import 'package:bedtimer/src/features/timer/application/timer_service.dart';
import 'package:bedtimer/src/features/timer/data/time_persistence.dart';
import 'package:bedtimer/src/features/timer/domain/time.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../onboarding/presentation/provider/permission_provider.dart';
import 'timer_state.dart';

class TimerNotifier extends AsyncNotifier<TimerState> {
  @override
  Future<TimerState> build() async {
    ref.listen(permissionControllerProvider, (previous, next) {
      next.whenData((value) {
        if (value != PermissionStatus.granted) {
          reset();
        }
      });
    });

    ref.listen(timerStreamProvider, (previous, next) {
      next.whenData((value) {
        setTime(Time.fromSeconds(value));
        if (value == 0) {
          timeIsUp();
        }
      });
    });

    final time = await ref.read(timePersistenceProvider).load();
    return const TimerInitial().copyWith(
      time: time ?? Time.fromSeconds(0),
    );
  }

  void setHoursUi(int hours) {
    state = state.whenData(
      (value) => value.copyWith(
        time: value.time.copyWith(hours: hours),
        forced: false,
        isPaused: false,
      ),
    );
  }

  void setMinutesUi(int minutes) {
    state = state.whenData(
      (value) => value.copyWith(
        time: value.time.copyWith(minutes: minutes),
        forced: false,
        isPaused: false,
      ),
    );
  }

  void setSecondsUi(int seconds) {
    state = state.whenData(
      (value) => value.copyWith(
        time: value.time.copyWith(seconds: seconds),
        forced: false,
        isPaused: false,
      ),
    );
  }

  void setTime(Time time) {
    state = state.whenData(
      (value) => value.copyWith(
        time: time,
        forced: true,
        isPaused: false,
      ),
    );
  }

  void start() async {
    state = state.whenData(
      (value) {
        if (!value.isPaused) {
          ref.read(timePersistenceProvider).store(value.time);
        }

        ref.read(timerServiceProvider).start(value.time);
        return value.copyWith(
          isRunning: true,
          isPaused: false,
        );
      },
    );
  }

  void pause() async {
    await ref.read(timerServiceProvider).stop();
    state = state.whenData(
      (value) => value.copyWith(
        isRunning: false,
        isPaused: true,
      ),
    );
  }

  void reset() async {
    await ref.read(timerServiceProvider).stop();
    final time = await ref.read(timePersistenceProvider).load();
    state = state.whenData(
      (value) => const TimerInitial().copyWith(
        time: time ?? Time.fromSeconds(0),
      ),
    );
  }

  void timeIsUp() async {
    await ref.read(audioServiceProvider).pauseAudioPlayback();
    state = state.whenData(
      (value) => value.copyWith(
        timeIsUp: true,
      ),
    );
    reset();
  }
}

final timerProvider = AsyncNotifierProvider<TimerNotifier, TimerState>(
  () => TimerNotifier(),
);
