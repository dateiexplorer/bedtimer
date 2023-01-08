import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/time.dart';

class TimePersistence {
  static const _id = "TIME";
  static final TimePersistence _timePersistence = TimePersistence._internal();

  factory TimePersistence() {
    return _timePersistence;
  }

  TimePersistence._internal();

  Future<void> store(Time time) async {
    final store = await SharedPreferences.getInstance();
    await store.setInt(_id, time.toSeconds());
  }

  Future<Time?> load() async {
    final store = await SharedPreferences.getInstance();
    final timeInSeconds = store.getInt(_id);
    if (timeInSeconds != null) {
      return Time.fromSeconds(timeInSeconds);
    }
    return null;
  }
}

final timePersistenceProvider = Provider(
  (ref) => TimePersistence(),
);
