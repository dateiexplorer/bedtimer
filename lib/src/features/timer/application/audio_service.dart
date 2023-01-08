import 'package:audio_session/audio_session.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AudioService {
  static final AudioService _service = AudioService._internal();

  factory AudioService() {
    return _service;
  }

  AudioService._internal();

  Future<void> pauseAudioPlayback() async {
    final session = await AudioSession.instance;
    await session.setActive(true);
  }
}

final audioServiceProvider = Provider(
  (ref) => AudioService(),
);
