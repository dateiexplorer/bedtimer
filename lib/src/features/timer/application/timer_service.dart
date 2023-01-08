import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/time.dart';

class TimerService {
  static final TimerService _service = TimerService._internal();

  factory TimerService() {
    return _service;
  }

  TimerService._internal();

  static const _methodChannel = MethodChannel(
    'de.dateiexplorer.apps.bedtimer/timer.methods',
  );

  static const EventChannel _callbackChannel = EventChannel(
    'de.dateiexplorer.apps.bedtimer/timer.callback',
  );

  Future<void> start(Time time) async {
    try {
      final arguments = {
        'timeInSeconds': time.toSeconds(),
      };
      await _methodChannel.invokeMethod('startTimer', arguments);
    } on PlatformException catch (e) {
      log("Failed to invoke method: '${e.message}'.");
    }
  }

  Future<void> stop() async {
    try {
      await _methodChannel.invokeMethod('stopTimer');
    } on PlatformException catch (e) {
      log("Failed to invoke method: '${e.message}'.");
    }
  }

  Stream<int> get secondsUntilFinished {
    return _callbackChannel.receiveBroadcastStream().cast();
  }
}

final timerServiceProvider = Provider(
  (ref) => TimerService(),
);

final timerStreamProvider = StreamProvider(
  (ref) => ref.read(timerServiceProvider).secondsUntilFinished,
);
