import 'package:firebase_database/firebase_database.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'app_update_result.dart';

class AppUpdateService {
  final DatabaseReference _db =
      FirebaseDatabase.instance.ref("app_updates/dev");

  Future<AppUpdateResult> checkForUpdate() async {
    try {
      // Current app version
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;

      // Firebase data
      final snapshot = await _db.get();

      if (!snapshot.exists) {
        return AppUpdateResult(
          hasUpdate: false,
          forceUpdate: false,
          latestVersion: currentVersion,
          skipCount: 0,
        );
      }

      final data = Map<String, dynamic>.from(snapshot.value as Map);

      final latestVersion = data['version'] ?? currentVersion;
      final shouldForceUpdate = data['should_force_update'] ?? false;
      final skipCount = data['skip_count'] ?? 0;

      bool hasUpdate = _isVersionGreater(latestVersion, currentVersion);

      return AppUpdateResult(
        hasUpdate: hasUpdate,
        forceUpdate: hasUpdate && shouldForceUpdate,
        latestVersion: latestVersion,
        skipCount: skipCount,
      );
    } catch (e) {
      return AppUpdateResult(
        hasUpdate: false,
        forceUpdate: false,
        latestVersion: "",
        skipCount: 0,
      );
    }
  }

  bool _isVersionGreater(String latest, String current) {
    List<int> latestParts = latest.split('.').map(int.parse).toList();

    List<int> currentParts = current.split('.').map(int.parse).toList();

    for (int i = 0; i < latestParts.length; i++) {
      int latestPart = latestParts[i];
      int currentPart = i < currentParts.length ? currentParts[i] : 0;

      if (latestPart > currentPart) {
        return true;
      } else if (latestPart < currentPart) {
        return false;
      }
    }

    return false;
  }
}
