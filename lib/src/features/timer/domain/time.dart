class Time {
  final int hours;
  final int minutes;
  final int seconds;

  const Time({
    required this.hours,
    required this.minutes,
    required this.seconds,
  });

  int toSeconds() {
    return (hours * 3600) + (minutes * 60) + seconds;
  }

  static Time fromSeconds(int seconds) {
    final hours = seconds ~/ 3600;
    seconds = seconds % 3600;
    final minutes = seconds ~/ 60;
    seconds = seconds % 60;
    return Time(hours: hours, minutes: minutes, seconds: seconds);
  }

  Time copyWith({
    int? hours,
    int? minutes,
    int? seconds,
  }) =>
      Time(
        hours: hours ?? this.hours,
        minutes: minutes ?? this.minutes,
        seconds: seconds ?? this.seconds,
      );
}
