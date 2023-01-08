import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionController extends AsyncNotifier<PermissionStatus> {
  @override
  FutureOr<PermissionStatus> build() async {
    return Permission.systemAlertWindow.status;
  }

  Future<void> request() async {
    state = await AsyncValue.guard(
      () => Permission.systemAlertWindow.request(),
    );
  }

  Future<void> checkPermission() async {
    state = await AsyncValue.guard(
      () => Permission.systemAlertWindow.status,
    );
  }
}

final permissionControllerProvider =
    AsyncNotifierProvider<PermissionController, PermissionStatus>(
  () {
    return PermissionController();
  },
);
