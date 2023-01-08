import 'package:equatable/equatable.dart';

import '../../domain/time.dart';

class TimerState extends Equatable {
  const TimerState({
    required this.time,
    required this.forced,
    bool? isRunning,
    bool? isPaused,
    bool? timeIsUp,
  })  : isRunning = isRunning ?? false,
        isPaused = isPaused ?? false,
        timeIsUp = timeIsUp ?? false;

  final Time time;
  final bool isRunning;
  final bool isPaused;
  final bool forced;
  final bool timeIsUp;

  bool get isValid => time.toSeconds() > 0;

  TimerState copyWith({
    Time? time,
    bool? isRunning,
    bool? isPaused,
    bool? forced,
    bool? timeIsUp,
  }) =>
      TimerState(
        time: time ?? this.time,
        isRunning: isRunning ?? this.isRunning,
        isPaused: isPaused ?? this.isPaused,
        forced: forced ?? this.forced,
        timeIsUp: timeIsUp ?? this.timeIsUp,
      );

  @override
  List<Object> get props => [
        time,
        isRunning,
        isPaused,
        forced,
        timeIsUp,
      ];

  @override
  String toString() {
    return {
      "time": time.toSeconds(),
      "isRunning": isRunning,
      "isPaused": isPaused,
      "forced": forced,
      "timeIsUp": timeIsUp,
      "isValid": isValid,
    }.toString();
  }
}

class TimerInitial extends TimerState {
  const TimerInitial()
      : super(
          time: const Time(hours: 0, minutes: 0, seconds: 0),
          forced: true,
        );
}
